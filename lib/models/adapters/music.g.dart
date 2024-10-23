// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotesMusicModelAdapter extends TypeAdapter<NotesMusicModel> {
  @override
  final int typeId = 0;

  @override
  NotesMusicModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotesMusicModel(
      transcription: fields[0] as Transcription?,
    );
  }

  @override
  void write(BinaryWriter writer, NotesMusicModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.transcription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotesMusicModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TranscriptionAdapter extends TypeAdapter<Transcription> {
  @override
  final int typeId = 1;

  @override
  Transcription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transcription(
      fullTranscript: fields[0] as String?,
      summary: fields[1] as String?,
      title: fields[2] as String?,
      createdAt: fields[3] as String?,
      flashcards: (fields[4] as List?)?.cast<Flashcard>(),
      quiz: (fields[5] as List?)?.cast<Quiz>(),
    );
  }

  @override
  void write(BinaryWriter writer, Transcription obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.fullTranscript)
      ..writeByte(1)
      ..write(obj.summary)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.flashcards)
      ..writeByte(5)
      ..write(obj.quiz);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranscriptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FlashcardAdapter extends TypeAdapter<Flashcard> {
  @override
  final int typeId = 2;

  @override
  Flashcard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Flashcard(
      question: fields[0] as String?,
      answer: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Flashcard obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.question)
      ..writeByte(1)
      ..write(obj.answer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuizAdapter extends TypeAdapter<Quiz> {
  @override
  final int typeId = 3;

  @override
  Quiz read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quiz(
      question: fields[0] as String?,
      answers: (fields[1] as List?)?.cast<String>(),
      correctAnswer: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Quiz obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.question)
      ..writeByte(1)
      ..write(obj.answers)
      ..writeByte(2)
      ..write(obj.correctAnswer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
