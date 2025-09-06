import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:get/get.dart';
import '../models/flashcard.dart';
import '../controllers/flashcard_controller.dart';

class FlashcardWidget extends StatelessWidget {
  final Flashcard flashcard;
  final VoidCallback? onMarkAsLearned;
  final bool showDeleteButton;
  final bool showLearnedButton;
  
  const FlashcardWidget({
    super.key,
    required this.flashcard,
    this.onMarkAsLearned,
    this.showDeleteButton = true,
    this.showLearnedButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: .1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: flashcard.isLearned 
            ? const BorderSide(color: Colors.green, width: 2.5)
            : BorderSide.none,
      ),
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        speed: 500,
        front: _buildSide(
          context,
          flashcard.question, 
          flashcard.questionImagePath,
          flashcard.isLearned ? Colors.green : Colors.blue,
          Icons.help_outline,
          "Question",
          isAnswerSide: false,
        ),
        back: _buildSide(
          context,
          flashcard.answer, 
          flashcard.answerImagePath,
          flashcard.isLearned ? Colors.green : Colors.deepOrange,
          Icons.lightbulb_outline,
          "Answer",
          isAnswerSide: true,
        ),
      ),
    );
  }

  Widget _buildSide(
    BuildContext context,
    String text, 
    String? imagePath,
    Color color, 
    IconData icon, 
    String label,
    {required bool isAnswerSide}
  ) {
    final FlashcardController flashcardController = Get.find<FlashcardController>();
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha:0.9), color],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Stack(
        children: [
          _buildCardContent(text, imagePath, icon),
          
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          
          if (showDeleteButton)
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Delete Flashcard'),
                      content: const Text('Are you sure you want to delete this flashcard?'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await flashcardController.deleteCard(flashcard);
                            Get.back();
                            Get.snackbar(
                              'Deleted',
                              'Flashcard deleted successfully',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          if (isAnswerSide && showLearnedButton)
            Positioned(
              bottom: 8,
              right: 8,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (onMarkAsLearned != null) {
                    onMarkAsLearned!();
                  } else {
                    flashcardController.toggleLearned(flashcard);
                  }
                },
                icon: Icon(
                  flashcard.isLearned ? Icons.remove_done : Icons.check_circle, 
                  size: 18,
                ),
                label: Text(flashcard.isLearned ? 'Mark Unlearned' : 'Got it!'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: flashcard.isLearned ? Colors.grey[700] : Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCardContent(String text, String? imagePath, IconData icon) {
    bool hasValidImage = imagePath != null && 
                        imagePath.isNotEmpty && 
                        File(imagePath).existsSync();

    if (hasValidImage) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(imagePath!),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 60),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
  }
}