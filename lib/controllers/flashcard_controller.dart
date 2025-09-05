import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:memora/models/flashcard.dart';

class FlashcardController extends GetxController {
  var flashcards = <Flashcard>[].obs;
  var unlearnedFlashcards = <Flashcard>[].obs;
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
  
  // Load flashcards
  void loadFlashcards() {
    flashcards.value = _flashcardBox.values.toList();
    _updateUnlearnedCards();
  }

  // Update unlearned cards list
  void _updateUnlearnedCards() {
    unlearnedFlashcards.value = flashcards.where((card) => !card.isLearned).toList();
  }

  // Save flashcard with image support
  Future<void> addCard(
    String q, 
    String a, 
    {String? questionImagePath, 
    String? answerImagePath}
  ) async {
    if (q.trim().isNotEmpty && a.trim().isNotEmpty) {
      final flashcard = Flashcard(
        question: q.trim(), 
        answer: a.trim(),
        questionImagePath: questionImagePath,
        answerImagePath: answerImagePath,
      );
      await _flashcardBox.add(flashcard);
      loadFlashcards(); // Refresh the observable lists
    }
  }

  // Delete flashcard
  Future<void> deleteCard(int index) async {
    if (index >= 0 && index < flashcards.length) {
      await flashcards[index].delete(); // HiveObject method
      loadFlashcards(); // Refresh the observable lists
    }
  }

  // Edit flashcard with image support
  Future<void> editCard(
    int index, 
    String newQuestion, 
    String newAnswer,
    {String? questionImagePath, 
    String? answerImagePath}
  ) async {
    if (index >= 0 && index < flashcards.length &&
        newQuestion.trim().isNotEmpty && newAnswer.trim().isNotEmpty) {
      flashcards[index].question = newQuestion.trim();
      flashcards[index].answer = newAnswer.trim();
      flashcards[index].questionImagePath = questionImagePath;
      flashcards[index].answerImagePath = answerImagePath;
      await flashcards[index].save(); // HiveObject method
      loadFlashcards(); // Refresh the observable lists
    }
  }

  // Mark card as learned/unlearned
  Future<void> toggleLearned(int index) async {
    if (index >= 0 && index < flashcards.length) {
      flashcards[index].isLearned = !flashcards[index].isLearned;
      await flashcards[index].save();
      loadFlashcards(); // Refresh both lists
    }
  }

  // Mark card as learned by Flashcard object (for swiper)
  Future<void> markAsLearned(Flashcard card) async {
    card.isLearned = true;
    await card.save();
    loadFlashcards();
  }

  // Get statistics
  int get totalCards => flashcards.length;
  int get learnedCards => flashcards.where((card) => card.isLearned).length;
  int get unlearnedCount => flashcards.where((card) => !card.isLearned).length;
  
  // Clear all flashcards
  Future<void> clearAllCards() async {
    await _flashcardBox.clear();
    loadFlashcards();
  }

  // Reset all cards to unlearned
  Future<void> resetAllProgress() async {
    for (var card in flashcards) {
      card.isLearned = false;
      await card.save();
    }
    loadFlashcards();
  }

  // Filter methods for different views
  List<Flashcard> get allCards => flashcards;
  List<Flashcard> get onlyUnlearned => unlearnedFlashcards;
  List<Flashcard> get onlyLearned => flashcards.where((card) => card.isLearned).toList();
}
