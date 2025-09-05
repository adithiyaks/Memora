import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:get/get.dart';
import '../models/flashcard.dart';
import '../controllers/flashcard_controller.dart';

class FlashcardWidget extends StatelessWidget {
  final Flashcard flashcard;
  final int? index;
  final VoidCallback? onMarkAsLearned;
  final bool showDeleteButton;
  final bool showLearnedButton;
  
  FlashcardWidget({
    required this.flashcard,
    this.index,
    this.onMarkAsLearned,
    this.showDeleteButton = true,
    this.showLearnedButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: flashcard.isLearned 
            ? BorderSide(color: Colors.green, width: 2)
            : BorderSide.none,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.67, // Reduced height
        child: FlipCard(
          direction: FlipDirection.HORIZONTAL,
          speed: 600,
          front: _buildSide(
            flashcard.question, 
            flashcard.questionImagePath,
            flashcard.isLearned ? Colors.green : Colors.blue,
            Icons.help_outline,
            "Question",
            isAnswerSide: false,
          ),
          back: _buildSide(
            flashcard.answer, 
            flashcard.answerImagePath,
            flashcard.isLearned ? Colors.green : Colors.orange,
            Icons.lightbulb_outline,
            "Answer",
            isAnswerSide: true,
          ),
        ),
      ),
    );
  }

  Widget _buildSide(
    String text, 
    String? imagePath,
    Color color, 
    IconData icon, 
    String label,
    {required bool isAnswerSide}
  ) {
    final FlashcardController flashcardController = Get.find<FlashcardController>();
    
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main content with image support
          _buildCardContent(text, imagePath, icon),
          
          // Top label
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
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
          
          // Delete button (always visible on top right)
          if (index != null && showDeleteButton)
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
                    color: Colors.white.withValues(alpha: 0.2),
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

          // Mark as learned button (only on answer side and if not learned)
          if (isAnswerSide && !flashcard.isLearned && showLearnedButton)
            Positioned(
              top: 8,
              right: 50, // Position next to delete button
              child: GestureDetector(
                onTap: () async {
                  if (onMarkAsLearned != null) {
                    onMarkAsLearned!();
                  } else if (index != null) {
                    await flashcardController.toggleLearned(index!);
                    Get.snackbar(
                      'Great!',
                      'Card marked as learned',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      duration: Duration(seconds: 2),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),

          // Learned status indicator (when card is learned)
          if (flashcard.isLearned)
            Positioned(
              top: 8,
              right: 50, // Position next to delete button
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCardContent(String text, String? imagePath, IconData icon) {
    // Check if image exists and is valid
    bool hasValidImage = imagePath != null && 
                        imagePath.isNotEmpty && 
                        File(imagePath).existsSync();

    if (hasValidImage) {
      // Layout with image: image at top, text below
      return Column(
        children: [
          // Image section (takes 60% of height)
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, 40, 16, 8), // Top padding for label
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(imagePath!),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // Text section (takes 40% of height)
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // Layout without image: centered text
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white.withValues(alpha: 0.7),
                size: 32,
              ),
              SizedBox(height: 12),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    }
  }
}
