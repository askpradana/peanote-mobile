import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:peanote/constant/pea_theme.dart';
import 'package:peanote/models/adapters/music.dart';
import 'package:peanote/views/splash_page.dart';
import 'package:path_provider/path_provider.dart' as path;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await path.getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(NotesMusicModelAdapter());
  Hive.registerAdapter(TranscriptionAdapter());
  Hive.registerAdapter(FlashcardAdapter());
  Hive.registerAdapter(QuizAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: PeaTheme.theme,
      home: const SplashPage(),
    );
  }
}
