import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peanote/models/adapters/music.dart';

class FullTranscriptPage extends StatelessWidget {
  final NotesMusicModel? notesMusicModel;
  const FullTranscriptPage({super.key, required this.notesMusicModel});

  @override
  Widget build(BuildContext context) {
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
              children: [
                Text(notesMusicModel?.transcription?.fullTranscript ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
