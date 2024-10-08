import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNotesLinkController extends GetxController {
  TextEditingController linkController = TextEditingController();
  RxString previewLink = ''.obs;

  Future<void> onUpload() async {
    if (previewLink.value.isNotEmpty) {
      // Add your link upload logic here
    } else {
      previewLink.value = linkController.text;
    }
  }

  void onTextFieldChanged(String value) {
    linkController.text = value;
  }
}
