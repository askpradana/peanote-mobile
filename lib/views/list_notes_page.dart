import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peanote/constant/pea_theme.dart';
import 'package:peanote/controllers/list_notes_controller.dart';
import 'package:peanote/views/add_notes_music_page.dart';
import 'package:peanote/views/add_notes_link_page.dart';
import 'package:peanote/views/user_profile_page.dart';
import 'package:peanote/views/widgets/pea_button.dart';

class ListNotesPage extends StatelessWidget {
  const ListNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ListNotesController controller = Get.put(ListNotesController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Notes',
                        style: TextStyle(fontSize: 24),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.to(() => const UserProfilePage());
                        },
                        icon: const Icon(Icons.settings_outlined),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _choiceChip(
                        text: 'All Notes',
                        onTap: () {
                          //
                        },
                      ),
                      _choiceChip(
                        text: 'Folders',
                        onTap: () {
                          //
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.indexCount.value,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: PeaTheme.greyColor,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: PeaTheme.purpleColor,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'A',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                title: const Text(
                                  'Welcome! This is sample notes bla bla bla',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: const Text('27 Sep 2024'),
                                trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.arrow_forward_ios,
                                      size: 15),
                                ),
                              ),
                            ),
                            index == controller.indexCount.value - 1
                                ? const SizedBox(
                                    height: 70,
                                  )
                                : const SizedBox(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Obx(
                  () {
                    return Column(
                      children: [
                        controller.isDisplay.value
                            ? _addNotesButton(
                                onTapLink: () {
                                  Get.to(() => const AddNotesLinkPage());
                                },
                                onTapMusic: () {
                                  Get.to(() => const AddNotesMusicPage());
                                },
                                onTapFolder: () {
                                  //
                                },
                              )
                            : const SizedBox(),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 178,
                          child: PeaButton(
                            pinkButton: true,
                            onPressed: () {
                              controller.addNotes();
                            },
                            title: 'New note',
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _addNotesButton({
  required VoidCallback? onTapLink,
  required VoidCallback? onTapMusic,
  required VoidCallback? onTapFolder,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _addNotesButtonComponent(
        onTap: onTapLink,
        icon: Icons.link_outlined,
      ),
      const SizedBox(width: 5),
      _addNotesButtonComponent(
        onTap: onTapMusic,
        icon: Icons.music_note_outlined,
      ),
      const SizedBox(width: 5),
      _addNotesButtonComponent(
        onTap: onTapFolder,
        icon: Icons.folder_open_outlined,
      )
    ],
  );
}

Widget _addNotesButtonComponent({
  required VoidCallback? onTap,
  required IconData icon,
}) {
  return InkWell(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    onTap: onTap,
    child: Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
          shape: BoxShape.circle, color: PeaTheme.pinkColor),
      child: Center(
        child: Icon(icon, color: PeaTheme.purpleColor),
      ),
    ),
  );
}

Widget _choiceChip({required String text, required VoidCallback? onTap}) {
  return InkWell(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(right: 5),
      height: 40,
      width: 80,
      decoration: BoxDecoration(
        border: Border.all(color: PeaTheme.greyColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    ),
  );
}
