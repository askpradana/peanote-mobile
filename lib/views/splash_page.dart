import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peanote/controllers/splash_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterLogo(),
              Text('wait a minute'),
            ],
          ),
        ),
      ),
    );
  }
}
