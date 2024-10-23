import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:peanote/constant/key.dart';
import 'package:peanote/models/user_model.dart';
import 'package:peanote/views/login_page.dart';
import 'package:peanote/views/my_home_page.dart';
import 'package:peanote/views/onboarding_page.dart';

class SplashController extends GetxController {
  RxBool isLogin = false.obs;
  RxString isNewUser = ''.obs;

  @override
  void onInit() {
    _onInitPage();
    super.onInit();
  }

  _onInitPage() async {
    await Future.delayed(const Duration(seconds: 3));
    _onCheckLogin();
  }

  Future<dynamic> _onReadUserData() async {
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());

    String? json = await storage.read(key: SecureStorageKey.loginResp);
    if (json != null) {
      return UserModel.fromJson(jsonDecode(json));
    }
    return null;
  }

  Future<void> _onSetUserData() async {
    UserModel? model = await _onReadUserData();

    if (model != null) {
      if (model.token.isNotEmpty) {
        isLogin(true);
      } else {
        isLogin(false);
      }
    } else {
      log('No user data found on secure storage.');
    }
  }

  Future<dynamic> _onReadOnBoardingData() async {
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());

    String? data = await storage.read(key: SecureStorageKey.onBoarding);
    if (data != null) {
      return isNewUser.value = data;
    } else {
      log('No onboarding data found on secure storage.');
    }
    return null;
  }

  Future<dynamic> _onCheckLogin() async {
    await _onReadOnBoardingData();

    if (isNewUser.value.isNotEmpty) {
      await _onSetUserData();

      if (isLogin.value) {
        Get.offAll(() => const MyHomePage());
      } else {
        Get.offAll(() => const LoginPage());
      }
    } else {
      Get.offAll(() => const OnBoardingPage());
    }
  }
}
