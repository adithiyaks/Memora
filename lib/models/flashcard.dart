import 'package:hive/hive.dart';

part 'flashcard.g.dart'; // Generated file

@HiveType(typeId: 0)
class Flashcard extends HiveObject {
  @HiveField(0)
  String question;

  @HiveField(1)
  String answer;

  @HiveField(2)
  String? questionImagePath;

  @HiveField(3)
  String? answerImagePath;

  @HiveField(4)
  bool isLearned;

  Flashcard({
    required this.question,
    required this.answer,
    this.questionImagePath,
    this.answerImagePath,
    this.isLearned = false,
  });
}
