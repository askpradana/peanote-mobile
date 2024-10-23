import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peanote/constant/pea_theme.dart';
import 'package:peanote/controllers/add_notes_file_controller.dart';
import 'package:peanote/views/widgets/pea_button.dart';
import 'package:peanote/views/widgets/pea_dropdown.dart';
import 'package:peanote/views/widgets/pea_textfield.dart';

class AddNotesFilePage extends StatelessWidget {
  const AddNotesFilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AddNotesFileController controller = Get.put(AddNotesFileController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'File Upload',
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
                ],
              ),
            ),
            Obx(() {
              return controller.selectedFile.value != null
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: PeaTheme.greyColor.withOpacity(0.2),
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.transparent),
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.settings_outlined,
                            color: PeaTheme.purpleColor,
                          ),
                        ),
                        title: Text(
                          controller.selectedFile.value!.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${controller.bytesToMegabytes(controller.selectedFile.value!.size).toStringAsFixed(2)} MB',
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            controller.onClearSelectedAudio();
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(),
                            ),
                            child: const Icon(Icons.delete_outlined),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox();
            }),
            const Spacer(),
            Obx(() {
              return controller.isUploading.value
                  ? const LinearProgressIndicator()
                  : const SizedBox();
            }),
            Obx(() {
              return controller.selectedFile.value != null
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        width: 100,
                        child: PeaButton(
                          title: 'Upload',
                          onPressed: () {
                            controller.onUploadData();
                          },
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: PeaTheme.greyColor.withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.image_outlined, size: 32),
                          const SizedBox(width: 5),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Browse File',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'Any audio file up to 25 mb',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 100,
                            child: PeaButton(
                              type: ButtonType.outlinedButton,
                              title: 'Browse',
                              onPressed: () {
                                controller.onPickAudioFile();
                              },
                            ),
                          ),
                        ],
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
