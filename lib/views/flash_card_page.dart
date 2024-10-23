import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:get/get.dart';
import 'package:peanote/constant/pea_theme.dart';
import 'package:peanote/models/adapters/music.dart';
import 'package:peanote/views/widgets/pea_button.dart';

class FlashCardPage extends StatefulWidget {
  final NotesMusicModel notesMusicModel;
  const FlashCardPage({super.key, required this.notesMusicModel});

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage> {
  final FlipCardController controller = FlipCardController();
  int index = 0;
  bool isFlipped = false;

  @override
  Widget build(BuildContext context) {
    final flashCardIndex =
        widget.notesMusicModel.transcription?.flashcards?[index];
    final flashCardLength =
        widget.notesMusicModel.transcription?.flashcards?.length;
    final size = MediaQuery.of(context).size;

    void flashButton() {
      if (isFlipped) {
        if (index < (flashCardLength ?? 0) - 1) {
          setState(() {
            isFlipped = false;
          });
          controller.flipcard();
          // future delay agar data tidak di load sebelum animasi flip selesai
          Future.delayed(const Duration(milliseconds: 800), () {
            setState(() {
              index++;
            });
          });
        } else {
          Get.back();
        }
      } else {
        setState(() {
          isFlipped = true;
        });
        controller.flipcard();
      }
    }

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: FlipCard(
                    rotateSide: RotateSide.right,
                    axis: FlipAxis.vertical,
                    controller: controller,
                    frontWidget: _buildCardWidget(
                      'Question ${index + 1} of $flashCardLength',
                      flashCardIndex?.question,
                      size,
                    ),
                    backWidget: _buildCardWidget(
                      'Answer ${index + 1} of $flashCardLength',
                      flashCardIndex?.answer,
                      size,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: kToolbarHeight),
              SizedBox(
                width: 178,
                child: PeaButton(
                  type: isFlipped ? ButtonType.outlinedButton : null,
                  title: isFlipped
                      ? (index < (flashCardLength ?? 0) - 1 ? 'Next' : 'Finish')
                      : 'Reveal Answer',
                  onPressed: () {
                    flashButton();
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardWidget(String title, String? content, Size size) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      height: size.height / 3,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: PeaTheme.purpleColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          Expanded(
            child: Center(
              child: Text(
                content ?? '',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
