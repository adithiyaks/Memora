import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // <-- 1. IMPORT THE PACKAGE
import 'package:memora/widgets/category_widget.dart';
import 'package:memora/widgets/create_cat_dialog.dart';
import 'package:memora/widgets/learningstats_widget.dart';
import '../controllers/category_controller.dart';
import '../models/category.dart';
import 'cards_screen.dart';
import 'settings_screen.dart'; // <-- 2. IMPORT THE SETTINGS SCREEN

// 3. CONVERTED TO A STATEFULWIDGET
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 4. ADD A VARIABLE TO TRACK THE SELECTED PAGE INDEX
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // 5. CHANGE THE APPBAR TITLE BASED ON THE SELECTED PAGE
          _pageIndex == 0 ? 'MEMORA' : 'Settings',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
      ),
      // 6. SET THE BODY BASED ON THE SELECTED PAGE
      body: _pageIndex == 0 ? _buildHomeContent() : const SettingsScreen(),
      
      // 7. ADD THE CURVED NAVIGATION BAR
      bottomNavigationBar: CurvedNavigationBar(
        index: _pageIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.settings, size: 30),
        ],
        color: Colors.blue,
        buttonBackgroundColor: Colors.blue,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }

  // 8. MOVED YOUR ORIGINAL HOME SCREEN CONTENT INTO THIS HELPER METHOD
  Widget _buildHomeContent() {
    return Obx(() {
      final categoryController = Get.find<CategoryController>();
      final categories = categoryController.categories;
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Categories List
            Expanded(
              child: categories.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return CategoryCard(
                          category: category,
                          onTap: () => _navigateToCards(category),
                        );
                      },
                    ),
            ),
            
            // Create New Category Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: OutlinedButton.icon(
                onPressed: () => _showCreateCategoryDialog(context),
                icon: const Icon(Icons.add, color: Colors.blue),
                label: const Text(
                  'Create New Category',
                  style: TextStyle(color: Colors.blue),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Colors.blue.withOpacity(0.3),
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            ),
            
            // Learning Statistics
            const LearningStatisticsCard(),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No categories yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first category to start learning!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToCards(Category category) {
    Get.to(() => CardsScreen(categoryId: category.id));
  }

  void _showCreateCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateCategoryDialog(),
    );
  }
}