import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:memora/controllers/flashcard_controller.dart';
import 'package:memora/models/category.dart';
// import '../models/flashcard.dart';

class CategoryController extends GetxController {
  var categories = <Category>[].obs;

  Box<Category>? _categoriesBox;
  late FlashcardController _flashcardController;

  @override
  void onInit() {
    super.onInit();
    _flashcardController = Get.find<FlashcardController>();
    // Asynchronously initialize the box
    _initHive();
  }

  // Initialize Hive box and load initial data
  Future<void> _initHive() async {
    _categoriesBox = await Hive.openBox<Category>('categories');
    loadCategories();
  }

  // Load categories into the reactive list
  void loadCategories() {
    if (_categoriesBox != null) {
      categories.value = _categoriesBox!.values.toList();
    }
  }

  // CREATE Category
  Future<void> addCategory(String name) async {
    if (name.trim().isEmpty || _categoriesBox == null) return;
    
    final category = Category(name: name.trim());
    await _categoriesBox!.add(category);
    loadCategories();
  }

  // READ Category by ID
  Category? getCategoryById(String id) {
    return categories.firstWhereOrNull((cat) => cat.id == id);
  }

  // UPDATE Category
  Future<void> updateCategory(Category category) async {
    await category.save();
    loadCategories();
  }

  // DELETE Category and its flashcards
  Future<void> deleteCategory(String categoryId) async {
    // 1. Delegate flashcard deletion
    await _flashcardController.deleteCardsForCategory(categoryId);

    // 2. Delete the category itself
    if (_categoriesBox != null) {
      final categoryToDelete = _categoriesBox!.values.firstWhereOrNull((c) => c.id == categoryId);
      if (categoryToDelete != null) {
        await categoryToDelete.delete();
      }
    }
    
    loadCategories();
  }

  // --- PROGRESS CALCULATION METHODS ---

  int getTotalCards(String categoryId) {
    return _flashcardController.flashcards
        .where((card) => card.categoryId == categoryId)
        .length;
  }

  int getCompletedCards(String categoryId) {
    return _flashcardController.flashcards
        .where((card) => card.categoryId == categoryId && card.isLearned)
        .length;
  }

  Map<String, int> getLearningStatistics() {
  int totalCardsStudied = 0;
  
  // Loop through the reactive 'categories' list
  for (var category in categories) {
    // For each category, get the number of completed cards and add to the total
    totalCardsStudied += getCompletedCards(category.id);
  }
  
  // Return a map with the total cards studied and the total number of categories
  return {
    'cardsStudied': totalCardsStudied,
    'categories': categories.length,
  };
}

}