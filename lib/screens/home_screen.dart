import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/flashcard_controller.dart';
import '../widgets/flashcard_widget.dart';
import 'add_card_screen.dart';

class HomeScreen extends StatelessWidget {
  final FlashcardController flashcardController = Get.put(FlashcardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Memora",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Obx(() => Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '${flashcardController.flashcards.length} cards',
                style: TextStyle(fontSize: 16),
              ),
            ),
          )),
        ],
      ),
      body: Obx(() {
        if (flashcardController.flashcards.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 100,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 20),
                Text(
                  'No flashcards yet!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Tap the + button to create your first card',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: flashcardController.flashcards.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3/4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return FlashcardWidget(
                flashcard: flashcardController.flashcards[index],
                index: index,
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddCardScreen()),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: Icon(Icons.add, size: 28),
        tooltip: 'Add new flashcard',
      ),
    );
  }
}
