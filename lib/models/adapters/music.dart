import 'package:hive_flutter/hive_flutter.dart';

part 'music.g.dart';

@HiveType(typeId: 0)
class NotesMusicModel extends HiveObject {
  @HiveField(0)
  final Transcription? transcription;
  final int id;

  NotesMusicModel({this.transcription, this.id = 0});

  factory NotesMusicModel.fromJson(Map<String, dynamic> json) {
    return NotesMusicModel(
      transcription: json["transcription"] == null
          ? null
          : Transcription.fromJson(json["transcription"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "transcription": transcription?.toJson(),
    };
  }
}

@HiveType(typeId: 1)
class Transcription {
  @HiveField(0)
  final String? fullTranscript;

  @HiveField(1)
  final String? summary;

  @HiveField(2)
  final String? title;

  @HiveField(3)
  final String? createdAt;

  @HiveField(4)
  final List<Flashcard>? flashcards;

  @HiveField(5)
  final List<Quiz>? quiz;

  Transcription({
    this.fullTranscript,
    this.summary,
    this.title,
    this.createdAt,
    this.flashcards,
    this.quiz,
  });

  factory Transcription.fromJson(Map<String, dynamic> json) {
    return Transcription(
      fullTranscript: json["fullTranscript"],
      summary: json["summary"],
      title: json["title"],
      createdAt: json["createdAt"],
      flashcards: json["flashcards"] == null
          ? []
          : List<Flashcard>.from(
              json["flashcards"]!.map((x) => Flashcard.fromJson(x))),
      quiz: json["quiz"] == null
          ? []
          : List<Quiz>.from(json["quiz"]!.map((x) => Quiz.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fullTranscript": fullTranscript,
      "summary": summary,
      "title": title,
      "createdAt": createdAt,
      "flashcards": flashcards == null
          ? []
          : List<dynamic>.from(flashcards!.map((x) => x.toJson())),
      "quiz":
          quiz == null ? [] : List<dynamic>.from(quiz!.map((x) => x.toJson())),
    };
  }
}

@HiveType(typeId: 2)
class Flashcard {
  @HiveField(0)
  final String? question;

  @HiveField(1)
  final String? answer;

  Flashcard({this.question, this.answer});

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      question: json["question"],
      answer: json["answer"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "question": question,
      "answer": answer,
    };
  }
}

@HiveType(typeId: 3)
class Quiz {
  @HiveField(0)
  final String? question;

  @HiveField(1)
  final List<String>? answers;

  @HiveField(2)
  final String? correctAnswer;

  Quiz({this.question, this.answers, this.correctAnswer});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      question: json["question"],
      answers: json["answers"] == null
          ? []
          : List<String>.from(json["answers"]!.map((x) => x)),
      correctAnswer: json["correct_answer"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "question": question,
      "answers":
          answers == null ? [] : List<dynamic>.from(answers!.map((x) => x)),
      "correct_answer": correctAnswer,
    };
  }
}
