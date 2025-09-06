import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/category.dart';
import '../controllers/category_controller.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categoryController = Get.find<CategoryController>();

      final totalCards = categoryController.getTotalCards(category.id);
      final completedCards = categoryController.getCompletedCards(category.id);
      final progress = totalCards > 0 ? (completedCards / totalCards) * 100 : 0.0;

      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Header
                Row(
                  children: [
                    // Category Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getCategoryIcon(category.name),
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Category Name & Card Count
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '$completedCards/$totalCards cards',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Text(
                          '${progress.toInt()}% complete',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(progress),
                      ),
                      minHeight: 4,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('math')) return Icons.calculate;
    if (name.contains('science')) return Icons.science;
    if (name.contains('history')) return Icons.history_edu;
    if (name.contains('geography')) return Icons.public;
    if (name.contains('language') || name.contains('spanish') || name.contains('english')) {
      return Icons.language;
    }
    return Icons.book;
  }

  Color _getProgressColor(double progress) {
    if (progress < 30) return Colors.red;
    if (progress < 70) return Colors.orange;
    return Colors.green;
  }
}