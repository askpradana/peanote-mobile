import 'dart:convert';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:peanote/constant/base_string.dart';
import 'package:peanote/constant/key.dart';
import 'package:peanote/data/baseapi.dart';
import 'package:peanote/models/adapters/music.dart';
import 'package:peanote/models/user_model.dart';
import 'package:peanote/services/user_data_storage.dart';
import 'package:peanote/views/list_notes_page.dart';

class AddNotesFileController extends GetxController {
  TextEditingController topics = TextEditingController();
  RxString audioLanguage = ''.obs;
  RxString notesLanguage = ''.obs;
  RxList<String> items = <String>['Indonesian', 'English'].obs;
  var selectedFile = Rx<PlatformFile?>(null);
  RxBool isUploading = false.obs;
  NotesMusicModel? _notesMusicModel;
  final RxString _token = ''.obs;

  @override
  void onInit() {
    _onSetUserData();
    super.onInit();
  }

  void onAudioLanguageChanged(String? value) {
    audioLanguage.value = value ?? '';
  }

  void onNotesLanguageChanged(String? value) {
    notesLanguage.value = value ?? '';
  }

  void onClearSelectedAudio() {
    selectedFile.value = null;
  }

  double bytesToMegabytes(int bytes) {
    if (bytes < 0) {
      throw ArgumentError('Bytes cannot be negative');
    }
    return bytes / (1024 * 1024); // Convert bytes to MB
  }

  Future<void> onPickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,

      /// variable that can be accessed from the widget that calls this function.
      allowedExtensions: ['mp3', 'wav', 'aac', 'm4a'],
      withData: true,
    );

    if (result != null) {
      selectedFile.value = result.files.single;
    }
  }

  Future<void> onUploadData() async {
    if (selectedFile.value == null ||
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

      http.StreamedResponse response = await BaseApi().postMultipart(
        BaseString.baseUrl + BaseString.uploadMusicNotes,
        body: body,
        file: selectedFile.value!,
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
