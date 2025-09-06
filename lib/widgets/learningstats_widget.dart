import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';

class LearningStatisticsCard extends StatelessWidget {
  const LearningStatisticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categoryController = Get.find<CategoryController>();
      final stats = categoryController.getLearningStatistics();
      
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learning Statistics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    '${stats['cardsStudied'] ?? 0}',
                    'Cards Studied',
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    '${stats['categories'] ?? 0}',
                    'Categories',
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}