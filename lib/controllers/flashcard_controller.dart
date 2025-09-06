import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:memora/models/flashcard.dart';

class FlashcardController extends GetxController {
  var flashcards = <Flashcard>[].obs;
  var unlearnedFlashcards = <Flashcard>[].obs;
  
  // Box is made nullable initially
  Box<Flashcard>? _flashcardBox;

  @override
  void onInit() {
    super.onInit();
    
    // Asynchronously initialize the box
    _initHive();
  }

  // Initialize Hive box and load initial data
  Future<void> _initHive() async {
    _flashcardBox = await Hive.openBox<Flashcard>('flashcards');
    loadFlashcards();
  }
  
  // Load flashcards from the box into the reactive list
  void loadFlashcards() {
    // Check if the box is open before using it
    if (_flashcardBox != null) {
      flashcards.value = _flashcardBox!.values.toList();
      _updateUnlearnedCards();
    }
  }

  // Update unlearned cards list
  void _updateUnlearnedCards() {
    unlearnedFlashcards.value = flashcards.where((card) => !card.isLearned).toList();
  }

  // Add a new flashcard
  Future<void> addCard(
    String q, 
    String a, 
    {String? questionImagePath, 
    String? answerImagePath,
    String? categoryId}
  ) async {
    if (q.trim().isNotEmpty && a.trim().isNotEmpty && _flashcardBox != null) {
      final flashcard = Flashcard(
        question: q.trim(), 
        answer: a.trim(),
        categoryId: categoryId ?? 'default', 
        questionImagePath: questionImagePath,
        answerImagePath: answerImagePath,
      );
      await _flashcardBox!.add(flashcard);
      loadFlashcards();
    }
  }

  // Delete a flashcard by its object
  Future<void> deleteCard(Flashcard card) async {
    await card.delete();
    loadFlashcards();
  }

  // Delete all flashcards belonging to a specific category
  Future<void> deleteCardsForCategory(String categoryId) async {
    if (_flashcardBox == null) return;
    
    final cardsToDelete = _flashcardBox!.values.where((card) => card.categoryId == categoryId).toList();
    
    for (var card in cardsToDelete) {
      await card.delete();
    }
    
    loadFlashcards();
  }
  
  // Mark card as learned/unlearned
  Future<void> toggleLearned(Flashcard card) async {
    card.isLearned = !card.isLearned;
    await card.save();
    loadFlashcards();
  }

  // Get statistics
  int get totalCards => flashcards.length;
  int get learnedCards => flashcards.where((card) => card.isLearned).length;
}