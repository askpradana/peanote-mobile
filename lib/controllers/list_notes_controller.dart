import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:peanote/constant/key.dart';
import 'package:peanote/models/adapters/music.dart';

class ListNotesController extends GetxController {
  RxBool isDisplay = false.obs;
  RxList<NotesMusicModel> notesMusicModel = <NotesMusicModel>[].obs;

  @override
  void onInit() {
    _onLoadNotes();
    super.onInit();
  }

  onDisplaySubButton() {
    isDisplay.value = !isDisplay.value;
  }

  onCloseDisplaySubButton() {
    isDisplay.value = false;
  }

  _onLoadNotes() {
    Hive.openBox<NotesMusicModel>(HiveKey.notesBox).then((box) {
      notesMusicModel.addAll(
        box.values.map((e) {
          final notesMusic = NotesMusicModel(
            transcription: e.transcription,
            id: e.key,
          );
          return notesMusic;
        }).toList(),
      );
    });
  }

  Future<void> onDeleteData(int id) async {
    late Box<NotesMusicModel> box;
    if (Hive.isBoxOpen(HiveKey.notesBox)) {
      box = Hive.box(HiveKey.notesBox);
    } else {
      box = await Hive.openBox(HiveKey.notesBox);
    }
    await box.delete(id);
    _onRefreshData();
  }

  Future<void> _onRefreshData() async {
    late Box<NotesMusicModel> box;
    if (Hive.isBoxOpen(HiveKey.notesBox)) {
      box = Hive.box(HiveKey.notesBox);
    } else {
      box = await Hive.openBox(HiveKey.notesBox);
    }
    notesMusicModel
      ..clear()
      ..addAll(box.values.map((e) {
        final notesMusic = NotesMusicModel(
          transcription: e.transcription,
          id: e.key,
        );
        return notesMusic;
      }).toList());
  }
}
