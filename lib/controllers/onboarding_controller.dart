import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:peanote/constant/key.dart';

class OnBoardingController extends GetxController {
  int currentIndex = 0;
  List<String> title = ['Record', 'Summarize', 'Practices'];
  List<String> description = [
    'Capture today class',
    'Summarize notes with help of an AI',
    'Capture faster, study smarter, grade greater'
  ];

  void onMoveToNextPage(controller) {
    if (currentIndex < 2) {
      currentIndex++;
    }
    controller.jumpToPage(currentIndex);
  }

  Future<void> onWriteOnBoarding() async {
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());

    await storage.write(key: SecureStorageKey.onBoarding, value: 'done');
  }
}
