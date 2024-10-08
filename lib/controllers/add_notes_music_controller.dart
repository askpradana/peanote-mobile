import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNotesMusicController extends GetxController {
  TextEditingController topics = TextEditingController();
  RxString audioLanguage = ''.obs;
  RxString notesLanguage = ''.obs;
  RxList<String> items = <String>['Indonesian', 'English'].obs;

  void onAudioLanguageChanged(String? value) {
    audioLanguage.value = value ?? '';
  }

  void onNotesLanguageChanged(String? value) {
    notesLanguage.value = value ?? '';
  }

  void onRecord() {
    print('topics: ${topics.text}');
    print('audioLanguage: ${audioLanguage.value}');
    print('notesLanguage: ${notesLanguage.value}');
  }
}
