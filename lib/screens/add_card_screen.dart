import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/flashcard_controller.dart';

// 1. MODIFIED WIDGET TO ACCEPT categoryId
class AddCardScreen extends StatefulWidget {
  final String categoryId;
  const AddCardScreen({super.key, required this.categoryId});

  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final FlashcardController flashcardController = Get.find<FlashcardController>();
  final ImagePicker _picker = ImagePicker();

  String? questionImagePath;
  String? answerImagePath;

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isQuestion) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          if (isQuestion) {
            questionImagePath = pickedFile.path;
          } else {
            answerImagePath = pickedFile.path;
          }
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error', 'Failed to pick image',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // --- UI HELPER WIDGETS (UNCHANGED) ---
  Widget _buildSectionCard({
    required String title,
    required Color titleColor,
    required IconData icon,
    required Widget content,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: titleColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(String? imagePath, bool isQuestion) {
    return Column(
      children: [
        if (imagePath != null) ...[
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(imagePath),
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isQuestion) {
                          questionImagePath = null;
                        } else {
                          answerImagePath = null;
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        InkWell(
          onTap: () => _pickImage(isQuestion),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  imagePath != null ? Icons.edit : Icons.add_photo_alternate,
                  color: Colors.blue, size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  imagePath != null ? 'Change Image' : 'Add Image',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      maxLines: 4,
      minLines: 2,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(fontSize: 16),
    );
  }
  // --- END OF UI HELPER WIDGETS ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Create Flashcard', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Question Section
            _buildSectionCard(
              title: 'Question',
              titleColor: Colors.blue,
              icon: Icons.help_outline,
              content: Column(
                children: [
                  _buildImageSection(questionImagePath, true),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: questionController,
                    label: 'Question Text',
                    hint: 'What do you want to learn?',
                    prefixIcon: Icons.quiz,
                  ),
                ],
              ),
            ),

            // Answer Section
            _buildSectionCard(
              title: 'Answer',
              titleColor: Colors.orange,
              icon: Icons.lightbulb_outline,
              content: Column(
                children: [
                  _buildImageSection(answerImagePath, false),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: answerController,
                    label: 'Answer Text',
                    hint: 'Provide the answer or explanation',
                    prefixIcon: Icons.lightbulb,
                  ),
                ],
              ),
            ),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (questionController.text.trim().isNotEmpty && 
                      answerController.text.trim().isNotEmpty) {
                    
                    // 2. MODIFIED CONTROLLER CALL TO PASS categoryId
                    await flashcardController.addCard(
                      questionController.text.trim(),
                      answerController.text.trim(),
                      questionImagePath: questionImagePath,
                      answerImagePath: answerImagePath,
                      categoryId: widget.categoryId, // <-- THE FIX
                    );
                    
                    Get.back();
                    Get.snackbar(
                      'Success! 🎉', 'Flashcard created successfully',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    Get.snackbar(
                      'Incomplete', 'Please fill in both question and answer',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.save, size: 20),
                label: const Text(
                  'Save Card',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}