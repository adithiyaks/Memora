import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:memora/models/flashcard.dart';

class FlashcardController extends GetxController {
  var flashcards = <Flashcard>[].obs;
  late Box<Flashcard> _flashcardBox;

  @override
  void onInit() {
    super.onInit();
    _initHive();
  }

  // Initialize Hive box
  Future<void> _initHive() async {
    _flashcardBox = await Hive.openBox<Flashcard>('flashcards');
    loadFlashcards();
  }

  // Load flashcards from Hive
  void loadFlashcards() {
    flashcards.value = _flashcardBox.values.toList();
  }

  // Save flashcard to Hive
  Future<void> addCard(String q, String a) async {
    if (q.trim().isNotEmpty && a.trim().isNotEmpty) {
      final flashcard = Flashcard(question: q.trim(), answer: a.trim());
      await _flashcardBox.add(flashcard);
      loadFlashcards(); // Refresh the observable list
    }
  }

  // Delete flashcard from Hive
  Future<void> deleteCard(int index) async {
    if (index >= 0 && index < flashcards.length) {
      await flashcards[index].delete(); // HiveObject method
      loadFlashcards(); // Refresh the observable list
    }
  }

  // Edit flashcard in Hive
  Future<void> editCard(int index, String newQuestion, String newAnswer) async {
    if (index >= 0 && index < flashcards.length &&
        newQuestion.trim().isNotEmpty && newAnswer.trim().isNotEmpty) {
      flashcards[index].question = newQuestion.trim();
      flashcards[index].answer = newAnswer.trim();
      await flashcards[index].save(); // HiveObject method
      loadFlashcards(); // Refresh the observable list
    }
  }

  // Clear all flashcards
  Future<void> clearAllCards() async {
    await _flashcardBox.clear();
    loadFlashcards();
  }

  // Keep all other methods the same (getStatistics, searchFlashcards, etc.)
  // Just remove saveFlashcards() method as Hive handles persistence automatically
}
