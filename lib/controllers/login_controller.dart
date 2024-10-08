import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:peanote/constant/base_string.dart';
import 'package:peanote/constant/secure_storage_key.dart';
import 'package:peanote/data/baseapi.dart';
import 'package:peanote/models/user_model.dart';
import 'package:peanote/views/my_home_page.dart';
import 'package:peanote/views/widgets/pea_dialog.dart';

class LoginController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  UserModel? userModel;

  RxBool obscurePassword = true.obs;

  Future<void> onLogin() async {
    Map<dynamic, dynamic> body = {};
    body['email'] = email.text;
    body['password'] = password.text;

    var response = await BaseApi().post(BaseString.login, body: body);
    if (response['token'] != null) {
      userModel = UserModel.fromJson(response);
      final userData = response['userData'];

      await _writeUserData();

      Get.dialog(
        PeaDialog(
          title: 'Success',
          content: 'Welcome ${userData['username']}',
          buttons: [
            CupertinoDialogAction(
              onPressed: () {
                Get.offAll(() => const MyHomePage());
              },
              child: const Text("Oke"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _writeUserData() async {
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());

    String json = jsonEncode(userModel?.toJson());
    await storage.write(key: SecureStorageKey.loginResp, value: json);
  }

  void onObsecurePassword() {
    obscurePassword.value = !obscurePassword.value;
  }
}
