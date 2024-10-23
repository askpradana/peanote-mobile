import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peanote/controllers/home_controller.dart';
import 'package:peanote/views/list_notes_page.dart';
import 'package:peanote/views/widgets/pea_button.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PeaButton(
                  title: 'List Notes',
                  onPressed: () {
                    Get.to(() => const ListNotesPage());
                  },
                ),
                const SizedBox(height: 32),
                PeaButton(
                  title: 'Refresh Token',
                  secondaryButton: true,
                  onPressed: () {
                    controller.onRefreshToken();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
