import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:peanote/constant/base_string.dart';
import 'package:peanote/data/baseapi.dart';
import 'package:peanote/views/login_page.dart';
import 'package:peanote/views/widgets/pea_dialog.dart';

class RegisterController extends GetxController {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  RxBool obsecurePassword = true.obs;
  RxBool obsecureConfirmPassword = true.obs;

  Future<void> onRegister() async {
    if (onValidatePasswordAndConfirmPassword()) {
      Map<dynamic, dynamic> body = {};
      body['username'] = username.text;
      body['email'] = email.text;
      body['password'] = password.text;

      var response = await BaseApi().post(BaseString.register, body: body);
      if (response['status'] == 'success') {
        Get.dialog(
          PeaDialog(
            title: 'Success',
            content: response['message'],
            buttons: [
              CupertinoDialogAction(
                onPressed: () {
                  Get.offAll(() => const LoginPage());
                },
                child: const Text("Oke"),
              ),
            ],
          ),
        );
      }
    }
  }

  void onObsecurePassword() {
    obsecurePassword.value = !obsecurePassword.value;
  }

  void onObsecureConfirmPassword() {
    obsecureConfirmPassword.value = !obsecureConfirmPassword.value;
  }

  bool onValidatePasswordAndConfirmPassword() {
    if (password.text != confirmPassword.text) {
      Get.dialog(
        PeaDialog(
          title: 'Error',
          content: 'Password and Confirm Password is different',
          buttons: [
            CupertinoDialogAction(
              onPressed: () {
                Get.back();
              },
              child: const Text("Close"),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }
}
