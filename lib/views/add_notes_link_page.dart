import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peanote/views/widgets/pea_button.dart';
import 'package:peanote/views/widgets/pea_textfield.dart';

import '../controllers/add_notes_link_controller.dart';

class AddNotesLinkPage extends StatelessWidget {
  const AddNotesLinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AddNotesLinkController controller = Get.put(AddNotesLinkController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Form link',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 16),
              Obx(() {
                return controller.previewLink.value.isNotEmpty
                    ? AnyLinkPreview.builder(
                        link: controller.previewLink.value,
                        itemBuilder: (context, metadata, imageProvider) {
                          return Column(
                            children: [
                              Image.network(
                                metadata.image ?? '',
                                height: MediaQuery.of(context).size.height / 3,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.fill,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                metadata.title ?? '',
                                style: const TextStyle(fontSize: 28),
                                maxLines: 1,
                              ),
                              Text(
                                metadata.desc ?? '',
                                maxLines: 3,
                                style: const TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.w500),
                              ),
                            ],
                          );
                        },
                      )
                    : const SizedBox();
              }),
              const Spacer(),
              PeaTextfield(
                hintText: 'Input youtube link',
                controller: controller.linkController,
                onChanged: (value) {
                  controller.onTextFieldChanged(value);
                },
              ),
              Obx(() {
                return PeaButton(
                  title: controller.previewLink.value.isNotEmpty
                      ? 'Upload'
                      : 'Preview',
                  onPressed: () {
                    controller.onUpload();
                  },
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
