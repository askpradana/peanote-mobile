import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peanote/models/adapters/music.dart';
import 'package:peanote/views/flash_card_page.dart';
import 'package:peanote/views/full_transcript_page.dart';
import 'package:peanote/views/quiz_card_page.dart';
import 'package:peanote/views/widgets/pea_button.dart';

class DetailNotesPage extends StatelessWidget {
  final NotesMusicModel notesMusicModel;
  const DetailNotesPage({super.key, required this.notesMusicModel});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios, size: 18),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notesMusicModel.transcription?.title ?? '',
                  style: const TextStyle(fontSize: 24),
                ),
                Row(
                  children: [
                    //TODO : Hide for now.  Enable _choiceChip widget if ready to use
                    // _choiceChip(
                    //   text: 'Add to folders',
                    //   onTap: () {
                    //     //
                    //   },
                    // ),
                    Text(notesMusicModel.transcription?.createdAt ?? ''),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * 0.43,
                      child: PeaButton(
                        title: 'Quiz',
                        icon: Icons.quiz_outlined,
                        onPressed: () {
                          Get.to(() =>
                              QuizCardPage(notesMusicModel: notesMusicModel));
                        },
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.43,
                      child: PeaButton(
                        title: 'Flashcards',
                        icon: Icons.flash_on_outlined,
                        onPressed: () {
                          Get.to(() =>
                              FlashCardPage(notesMusicModel: notesMusicModel));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * 0.43,
                      child: PeaButton(
                        title: 'Translate',
                        icon: Icons.translate_outlined,
                        onPressed: () {
                          //
                        },
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.43,
                      child: PeaButton(
                        title: 'Share',
                        icon: Icons.share_outlined,
                        onPressed: () {
                          //
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(notesMusicModel.transcription?.summary ?? ''),
                const SizedBox(height: 16),
                PeaButton(
                  type: ButtonType.outlinedButton,
                  title: 'View full transcript',
                  onPressed: () {
                    Get.to(() =>
                        FullTranscriptPage(notesMusicModel: notesMusicModel));
                  },
                ),
                const SizedBox(height: 16),
                PeaButton(
                  type: ButtonType.outlinedButton,
                  title: 'Export notes to local storage',
                  onPressed: () {
                    //
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget _choiceChip({required String text, required VoidCallback? onTap}) {
//   return InkWell(
//     splashColor: Colors.transparent,
//     highlightColor: Colors.transparent,
//     onTap: onTap,
//     child: Container(
//       margin: const EdgeInsets.only(right: 5),
//       height: 40,
//       width: 80,
//       decoration: BoxDecoration(
//         border: Border.all(color: PeaTheme.purpleColor),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Center(
//         child: Text(
//           text,
//           style: const TextStyle(fontWeight: FontWeight.w500),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     ),
//   );
// }
