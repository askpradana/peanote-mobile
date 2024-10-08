import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peanote/constant/pea_theme.dart';
import 'package:peanote/controllers/login_controller.dart';
import 'package:peanote/views/register_page.dart';
import 'package:peanote/views/widgets/pea_button.dart';
import 'package:peanote/views/widgets/pea_textfield.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

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
                          text: "Don't have an account? ",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text: "Sign up",
                          style: const TextStyle(
                            color: PeaTheme.purpleColor,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(() => const RegisterPage());
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
                  const Text(
                    'Sign In\nto Your account',
                    style: TextStyle(fontSize: 28),
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
                      obsecureText: controller.obscurePassword.value,
                    );
                  }),
                  InkWell(
                    onTap: () {
                      //
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: PeaTheme.purpleColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PeaButton(
                    title: 'Login',
                    onPressed: () {
                      controller.onLogin();
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
