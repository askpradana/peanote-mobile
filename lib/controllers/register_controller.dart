import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peanote/constant/base_string.dart';
import 'package:peanote/data/baseapi.dart';
import 'package:peanote/views/login_page.dart';

class RegisterController extends GetxController {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  RxBool obsecurePassword = true.obs;
  RxBool obsecureConfirmPassword = true.obs;

  void onObsecurePassword() {
    obsecurePassword.value = !obsecurePassword.value;
  }

  void onObsecureConfirmPassword() {
    obsecureConfirmPassword.value = !obsecureConfirmPassword.value;
  }

  Future<void> onRegister() async {
    if (_onValidatePasswordAndConfirmPassword()) {
      Map<dynamic, dynamic> body = {};
      body['username'] = username.text;
      body['email'] = email.text;
      body['password'] = password.text;

      var response = await BaseApi().post(BaseString.register, body: body);
      if (response['status'] == 'success') {
        Get.defaultDialog(
          title: 'Success',
          content: Text(response['message']),
          textConfirm: 'Oke',
          onConfirm: () {
            Get.offAll(() => const LoginPage());
          },
        );
      }
    }
  }

  bool _onValidatePasswordAndConfirmPassword() {
    if (password.text != confirmPassword.text) {
      Get.defaultDialog(
        title: 'Error',
        content: const Text('Password and Confirm Password is different'),
        textConfirm: 'Close',
        onConfirm: () {
          Get.back();
        },
      );
      return false;
    }
    return true;
  }
}
