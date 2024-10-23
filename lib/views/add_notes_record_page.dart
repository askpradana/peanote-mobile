import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peanote/controllers/add_notes_record_controller.dart';
import 'package:peanote/views/widgets/pea_button.dart';
import 'package:peanote/views/widgets/pea_dropdown.dart';
import 'package:peanote/views/widgets/pea_textfield.dart';

class AddNotesRecordPage extends StatelessWidget {
  const AddNotesRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AddNotesRecordController controller =
        Get.put(AddNotesRecordController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Record',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      controller.onDeleteLastRecording();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(),
                      ),
                      child: const Icon(Icons.delete_outlined),
                    ),
                  ),
                  Obx(() {
                    final String isLatestPath = controller.latestFilePath.value;
                    final bool isRecording = controller.isRecording.value;
                    final bool isPaused = controller.isPaused.value;
                    final bool isPlaying = controller.isPlaying.value;

                    return SizedBox(
                      width: 178,
                      child: Column(
                        children: [
                          if (isLatestPath.isNotEmpty && isPaused)
                            PeaButton(
                              type: ButtonType.textButton,
                              title:
                                  isPlaying ? 'Listening...' : 'Play Recording',
                              onPressed: () {
                                isPlaying
                                    ? null
                                    : controller.onPlayLastRecording();
                              },
                            ),
                          const SizedBox(height: 16),
                          if (!isRecording)
                            PeaButton(
                              title: 'Record',
                              icon: Icons.mic_outlined,
                              onPressed: () {
                                controller.onStartRecording();
                              },
                            ),
                          if (isRecording && !isPaused)
                            PeaButton(
                              secondaryButton: true,
                              title: 'Listening',
                              icon: Icons.hearing_outlined,
                              onPressed: () {
                                controller.onPauseRecording();
                              },
                            ),
                          if (isRecording && isPaused)
                            PeaButton(
                              secondaryButton: true,
                              title: 'Resume',
                              icon: Icons.hearing_outlined,
                              onPressed: () {
                                controller.onResumeRecording();
                              },
                            ),
                        ],
                      ),
                    );
                  }),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      controller.onUploadData();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(),
                      ),
                      child: const Icon(Icons.save_outlined),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
