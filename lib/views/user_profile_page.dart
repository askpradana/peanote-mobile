import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peanote/constant/pea_theme.dart';
import 'package:peanote/controllers/home_controller.dart';
import 'package:peanote/views/login_page.dart';
import 'package:peanote/views/widgets/pea_button.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'App Version 0.1.1+1',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: 185,
                    child: PeaButton(
                      type: ButtonType.outlinedButton,
                      onPressed: () {
                        _onLogout(controller: controller);
                      },
                      title: 'Logout',
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    return Text(
                      controller.username.value,
                      style: const TextStyle(fontSize: 36),
                    );
                  }),
                  Obx(() {
                    return Text(
                      controller.userEmail.value,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: PeaTheme.greyColor,
                      ),
                    );
                  }),
                  const SizedBox(height: 32),
                  _userProfile(
                    text: 'Get unlimited record',
                    onTap: () {
                      //
                    },
                  ),
                  _userProfile(
                    text: 'Report something',
                    onTap: () {
                      //
                    },
                  ),
                  _userProfile(
                    text: 'Join discord',
                    onTap: () {
                      //,
                    },
                  ),
                  _userProfile(
                    text: 'FAQ',
                    onTap: () {
                      //
                    },
                  ),
                  _userProfile(
                    text: 'Terms and Condition',
                    onTap: () {
                      //
                    },
                  ),
                  _userProfile(
                    text: 'Language',
                    onTap: () {
                      //
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userProfile({required String text, required VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_forward_ios, size: 15),
        )
      ],
    );
  }

  Future<dynamic> _onLogout({required HomeController controller}) {
    return Get.defaultDialog(
      title: 'Confirm Exit',
      content: const Text('Are you sure want to exit?'),
      textConfirm: 'Yes',
      onConfirm: () async {
        Get.back();
        await controller.onLogout();
        Get.offAll(() => const LoginPage());
      },
      textCancel: 'No',
      onCancel: () {
        Get.back();
      },
    );
  }
}
