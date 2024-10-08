import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peanote/constant/pea_theme.dart';
import 'package:peanote/controllers/register_controller.dart';
import 'package:peanote/views/login_page.dart';
import 'package:peanote/views/widgets/pea_button.dart';
import 'package:peanote/views/widgets/pea_textfield.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.put(RegisterController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Stack(
            children: [
              Column(
                children: [
                  const Row(
                    children: [
                      FlutterLogo(size: 24),
                      SizedBox(width: 8),
                      Text(
                        'PeaNote',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                  const Spacer(),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        const TextSpan(
                          text: "Alerady have an account? ",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text: "Sign In",
                          style: const TextStyle(
                            color: PeaTheme.purpleColor,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(() => const LoginPage());
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PeaTextfield(
                    hintText: 'Username',
                    controller: controller.username,
                  ),
                  PeaTextfield(
                    hintText: 'Email',
                    controller: controller.email,
                  ),
                  Obx(() {
                    return PeaTextfield(
                      hintText: 'Password',
                      controller: controller.password,
                      isPassword: true,
                      onPressedSuffix: () {
                        controller.onObsecurePassword();
                      },
                      obsecureText: controller.obsecurePassword.value,
                    );
                  }),
                  Obx(() {
                    return PeaTextfield(
                      hintText: 'Confirm Password',
                      controller: controller.confirmPassword,
                      isPassword: true,
                      onPressedSuffix: () {
                        controller.onObsecureConfirmPassword();
                      },
                      obsecureText: controller.obsecureConfirmPassword.value,
                    );
                  }),
                  const SizedBox(height: 16),
                  PeaButton(
                    title: 'Create Account',
                    onPressed: () {
                      controller.onRegister();
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
}
