import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../controllers/flashcard_controller.dart';
import '../widgets/flashcard_widget.dart';
import 'add_card_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlashcardController flashcardController = Get.put(FlashcardController());
  final CardSwiperController _swiperController = CardSwiperController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          "MEMORA",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        )),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white70,
        centerTitle: true,
        actions: [
          Obx(() => Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${flashcardController.flashcards.length} cards',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  if (flashcardController.flashcards.isNotEmpty)
                    Text(
                      '${flashcardController.learnedCards} learned',
                      style: TextStyle(fontSize: 12),
                    ),
                ],
              ),
            ),
          )),
        ],
        elevation: 0,
      ),
      body: Obx(() {
        final cards = flashcardController.flashcards;
        
        if (cards.isEmpty) {
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

        // Ensure _currentIndex is within valid range
        if (_currentIndex >= cards.length) {
          _currentIndex = 0;
        }

        // Calculate numberOfCardsDisplayed safely
        int numberOfCardsToDisplay = cards.length <= 3 ? cards.length : 3;
        
        // Only enable swipe if there's more than one card
        bool isSwipeEnabled = cards.length > 1;

        return Column(
          children: [
            // Progress indicator
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Card ${_currentIndex + 1} of ${cards.length}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      Text(
                        cards.length == 1 ? '1 Card (No Swipe)' : '${cards.length} Total',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: cards.isNotEmpty ? (_currentIndex + 1) / cards.length : 0,
                    backgroundColor: Colors.blue.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ],
              ),
            ),

            // Card Display - Use different widgets based on card count
            Expanded(
              child: Container(
                child: isSwipeEnabled
                    ? CardSwiper(
                        controller: _swiperController,
                        cardsCount: cards.length,
                        numberOfCardsDisplayed: numberOfCardsToDisplay,
                        backCardOffset: const Offset(40, 40),
                        padding: const EdgeInsets.all(24.0),
                        onSwipe: (previousIndex, currentIndex, direction) {
                          // Safely update current index with bounds checking
                          setState(() {
                            if (currentIndex != null && currentIndex < cards.length) {
                              _currentIndex = currentIndex;
                            } else {
                              _currentIndex = 0;
                            }
                          });
                          return true;
                        },
                        cardBuilder: (context, index, horizontalThreshold, verticalThreshold) {
                          // Additional safety check
                          if (index >= cards.length) {
                            return Container(); // Return empty container if index is out of bounds
                          }
                          
                          return FlashcardWidget(
                            flashcard: cards[index],
                            index: index,
                            showDeleteButton: true,
                            showLearnedButton: true,
                            onMarkAsLearned: () async {
                              // Additional safety check before toggling
                              if (index < cards.length) {
                                await flashcardController.toggleLearned(index);
                                Get.snackbar(
                                  "Great!",
                                  "Card marked as learned! 🎉",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  duration: Duration(seconds: 2),
                                );
                              }
                            },
                          );
                        },
                      )
                    : // Single card display (no swipe)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: FlashcardWidget(
                            flashcard: cards[0],
                            index: 0,
                            showDeleteButton: true,
                            showLearnedButton: true,
                            onMarkAsLearned: () async {
                              await flashcardController.toggleLearned(0);
                              Get.snackbar(
                                "Great!",
                                "Card marked as learned! 🎉",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                duration: Duration(seconds: 2),
                              );
                            },
                          ),
                        ),
                      ),
              ),
            ),
            SizedBox(height: 70,)
          ],
        
        );
      
      }),

      

      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddCardScreen()),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        tooltip: 'Add new flashcard',
        child: Icon(Icons.add, size: 28),
      ),
    );
  }
}
