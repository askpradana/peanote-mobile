import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:peanote/constant/base_string.dart';
import 'package:peanote/constant/key.dart';
import 'package:peanote/data/baseapi.dart';
import 'package:peanote/models/adapters/music.dart';
import 'package:peanote/models/user_model.dart';
import 'package:peanote/services/user_data_storage.dart';
import 'package:peanote/views/list_notes_page.dart';
import 'package:permission_handler/permission_handler.dart';

class AddNotesRecordController extends GetxController {
  TextEditingController topics = TextEditingController();
  RxString audioLanguage = ''.obs;
  RxString notesLanguage = ''.obs;
  RxList<String> items = <String>['Indonesian', 'English'].obs;
  RxBool isUploading = false.obs;
  NotesMusicModel? _notesMusicModel;
  final RxString _token = ''.obs;

  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer player = FlutterSoundPlayer();
  RxBool isRecording = false.obs;
  RxBool isPaused = false.obs;
  RxString latestFilePath = ''.obs;
  RxBool isPlaying = false.obs;

  @override
  void onInit() {
    _onSetUserData();
    _onInitializeRecorder();
    _onRequestPermissions();
    super.onInit();
  }

  @override
  void onClose() {
    recorder.closeRecorder();
    player.closePlayer();
    super.onClose();
  }

  void onAudioLanguageChanged(String? value) {
    audioLanguage.value = value ?? '';
  }

  void onNotesLanguageChanged(String? value) {
    notesLanguage.value = value ?? '';
  }

  Future<void> _onRequestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> _onInitializeRecorder() async {
    await recorder.openRecorder();
    await player.openPlayer();
  }

  Future<String> _onGetAudioFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/peanote_audio_record.aac';
  }

  Future<void> onStartRecording() async {
    if (isRecording.value) return;
    final filePath = await _onGetAudioFilePath();
    await recorder.startRecorder(toFile: filePath);
    log("Recording started: $filePath");
    isRecording(true);
    isPaused(false);
    latestFilePath.value = filePath;
  }

  Future<void> onStopRecording() async {
    await recorder.stopRecorder();
    final fileExists = await File(latestFilePath.value).exists();
    log("Recording stopped: ${latestFilePath.value}, File exists: $fileExists");
    isRecording(false);
    isPaused(false);
  }

  Future<void> onPauseRecording() async {
    if (isRecording.value && !isPaused.value) {
      await recorder.pauseRecorder();
      isPaused(true);
      log("Recording paused");
    }
  }

  Future<void> onResumeRecording() async {
    if (isRecording.value && isPaused.value) {
      await recorder.resumeRecorder();
      isPaused(false);
      log("Recording resumed");
    }
  }

  Future<void> onPlayLastRecording() async {
    if (latestFilePath.value.isNotEmpty) {
      isPlaying(true);

      await player.startPlayer(
          fromURI: latestFilePath.value,
          whenFinished: () {
            isPlaying(false);
            log("Playing: ${latestFilePath.value}");
          });
    } else {
      log("No recorded audio found");
    }
  }

  Future<void> onDeleteLastRecording() async {
    final fileExists = await File(latestFilePath.value).exists();
    if (fileExists) {
      await File(latestFilePath.value).delete();
      log("Deleted recording: ${latestFilePath.value}");
      await recorder.stopRecorder();
      isRecording(false);
      isPaused(false);
      isPlaying(false);
      latestFilePath.value = '';
    } else {
      log("No recording found to delete.");
    }
  }

  Future<void> onUploadData() async {
    if (latestFilePath.value.isEmpty ||
        topics.text.isEmpty ||
        audioLanguage.value.isEmpty ||
        notesLanguage.isEmpty) {
      Get.defaultDialog(
        title: 'Error',
        content: const Text('Please select a file and fill all fields.'),
        textConfirm: 'Close',
        onConfirm: () {
          Get.back();
        },
      );
      return;
    }

    isUploading(true);

    try {
      Map<String, dynamic> body = {
        'topics': topics.text,
        'audioLanguages': audioLanguage.value,
        'notesLanguage': notesLanguage.value,
      };

      final file = File(latestFilePath.value);
      final fileName = file.uri.pathSegments.last;
      final fileSize = await file.length();

      final platformFile = PlatformFile(
        name: fileName,
        size: fileSize,
        path: latestFilePath.value,
      );

      http.StreamedResponse response = await BaseApi().postMultipart(
        BaseString.baseUrl + BaseString.uploadMusicNotes,
        body: body,
        file: platformFile,
        bearerToken: _token.value,
      );

      log('Upload response: ${response.statusCode}');
      String responseBody = await response.stream.bytesToString();
      log('Response body: $responseBody');

      if (response.statusCode == 200) {
        _notesMusicModel = NotesMusicModel.fromJson(json.decode(responseBody));

        late Box<NotesMusicModel> openBox;
        final isOpen = Hive.isBoxOpen(HiveKey.notesBox);

        if (isOpen) {
          openBox = Hive.box(HiveKey.notesBox);
        } else {
          openBox = await Hive.openBox(HiveKey.notesBox);
        }

        final music = _notesMusicModel;
        if (music != null) {
          openBox.add(music).then((value) {
            log('Notes has been created with id $value');
          }).onError((error, stackTrace) {
            log('Error adding notes music: $error');
          });
        }

        Get.defaultDialog(
          barrierDismissible: false,
          title: 'Success',
          content: const Text('Upload Successful!'),
          textConfirm: 'Oke',
          onConfirm: () {
            Get.offAll(() => const ListNotesPage(),
                predicate: (route) => route.isFirst);
          },
        );
      } else {
        Get.defaultDialog(
          title: 'Error',
          content: Text('Upload failed with status: ${response.statusCode}'),
          textConfirm: 'Close',
          onConfirm: () {
            Get.back();
          },
        );
      }
    } catch (e) {
      log('Error during upload: $e');
      Get.defaultDialog(
        title: 'Error',
        content: Text('An error occurred during upload: $e'),
        textConfirm: 'Close',
        onConfirm: () {
          Get.back();
        },
      );
    } finally {
      isUploading(false);
    }
  }

  Future<void> _onSetUserData() async {
    UserModel? model = await UserDataStorage.onReadFromSecureStorage();

    if (model != null) {
      _token.value = model.token;
    } else {
      log('No token found on secure storage.');
    }
  }
}
