import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:get/get.dart';
import '../models/flashcard.dart';
import '../controllers/flashcard_controller.dart';

class FlashcardWidget extends StatelessWidget {
  final Flashcard flashcard;
  final int? index;
  
  FlashcardWidget({
    required this.flashcard,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        speed: 600,
        onFlipDone: (status) {
          // Optional: Add haptic feedback when card flips
          // HapticFeedback.lightImpact();
        },
        front: _buildSide(
          flashcard.question, 
          Colors.blue,
          Icons.help_outline,
          "Question",
        ),
        back: _buildSide(
          flashcard.answer, 
          Colors.green,
          Icons.lightbulb_outline,
          "Answer",
        ),
      ),
    );
  }

  Widget _buildSide(String text, Color color, IconData icon, String label) {
    final FlashcardController flashcardController = Get.find<FlashcardController>();
    
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.white.withOpacity(0.8),
                    size: 24,
                  ),
                  SizedBox(height: 8),
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          
          // Top label
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          // Delete button (only show if index is provided)
          if (index != null)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  Get.dialog(
                    AlertDialog(
                      title: Text('Delete Flashcard'),
                      content: Text('Are you sure you want to delete this flashcard?'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await flashcardController.deleteCard(index!);
                            Get.back();
                            Get.snackbar(
                              'Deleted',
                              'Flashcard deleted successfully',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
