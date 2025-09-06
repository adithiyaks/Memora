import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memora/widgets/category_widget.dart';
import 'package:memora/widgets/create_cat_dialog.dart';
import 'package:memora/widgets/learningstats_widget.dart';
import '../controllers/category_controller.dart';
import '../models/category.dart';
import 'cards_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MEMORA',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Obx(() {
        
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
        }),
      
    );
  }}

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


