import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:peanote/constant/base_string.dart';
import 'package:peanote/constant/key.dart';
import 'package:peanote/data/baseapi.dart';
import 'package:peanote/models/user_model.dart';
import 'package:peanote/views/my_home_page.dart';

class LoginController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  RxBool obscurePassword = true.obs;
  UserModel? _userModel;

  void onObsecurePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> onLogin() async {
    Map<dynamic, dynamic> body = {};
    body['email'] = email.text;
    body['password'] = password.text;

    var response = await BaseApi().post(BaseString.login, body: body);
    if (response['token'] != null) {
      _userModel = UserModel.fromJson(response);
      final userData = response['userData'];

      await _onWriteUserData();

      Get.defaultDialog(
        title: 'Success',
        content: Text('Welcome ${userData['username']}'),
        textConfirm: 'Oke',
        onConfirm: () {
          Get.offAll(() => const MyHomePage());
        },
      );
    }
  }

  Future<void> _onWriteUserData() async {
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());

    String json = jsonEncode(_userModel?.toJson());
    await storage.write(key: SecureStorageKey.loginResp, value: json);
  }
}
