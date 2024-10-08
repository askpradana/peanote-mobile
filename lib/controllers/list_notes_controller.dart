import 'package:get/get.dart';

class ListNotesController extends GetxController {
  RxBool isDisplay = false.obs;
  RxInt indexCount = 10.obs;

  addNotes() {
    isDisplay.value = !isDisplay.value;
  }
}
