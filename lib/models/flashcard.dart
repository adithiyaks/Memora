import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'flashcard.g.dart';

@HiveType(typeId: 0)
class Flashcard extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String question;

  @HiveField(2)
  late String answer;

  @HiveField(3)
  late String? questionImagePath;

  @HiveField(4)
  late String? answerImagePath;

  @HiveField(5)
  late bool isLearned;

  @HiveField(6)
  late DateTime createdAt;

  @HiveField(7)
  late String categoryId; // NEW: Category ID field

  Flashcard({
    String? id,
    required this.question,
    required this.answer,
    required this.categoryId, // Now required
    this.questionImagePath,
    this.answerImagePath,
    this.isLearned = false,
    DateTime? createdAt,
  }) {
    this.id = id ?? const Uuid().v4();
    this.createdAt = createdAt ?? DateTime.now();
  }
}
