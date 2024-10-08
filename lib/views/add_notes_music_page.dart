import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peanote/controllers/add_notes_music_controller.dart';
import 'package:peanote/views/widgets/pea_button.dart';
import 'package:peanote/views/widgets/pea_dropdown.dart';
import 'package:peanote/views/widgets/pea_textfield.dart';

class AddNotesMusicPage extends StatelessWidget {
  const AddNotesMusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AddNotesMusicController controller =
        Get.put(AddNotesMusicController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Form link',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(height: 16),
              PeaTextfield(
                hintText: 'Topics',
                helperText: 'Help us to recognized data',
                controller: controller.topics,
              ),
              PeaDropdown(
                hintText: 'Audio Languages',
                helperText: 'Help us to recognized recorded languages',
                items: controller.items,
                onChanged: (value) {
                  controller.onAudioLanguageChanged(value);
                },
              ),
              PeaDropdown(
                hintText: 'Notes Languages',
                helperText: 'Help us to understand summary notes',
                items: controller.items,
                onChanged: (value) {
                  controller.onNotesLanguageChanged(value);
                },
              ),
              const Spacer(),
              SizedBox(
                width: 178,
                child: PeaButton(
                  onPressed: () {
                    controller.onRecord();
                  },
                  title: 'Record',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
