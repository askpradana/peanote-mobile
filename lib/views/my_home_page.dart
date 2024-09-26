import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peanote/controllers/home_controller.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            var data = await HomeController().fetchTodos();
            print(data);
          },
          child: Text('btnHome'.tr),
        ),
      ),
    );
  }
}
