import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:memora/controllers/category_controller.dart';
import 'package:memora/controllers/flashcard_controller.dart';
import 'package:memora/models/category.dart';
import 'package:memora/screens/home_screen.dart';
import 'models/flashcard.dart';
// import 'screens/cards_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(FlashcardAdapter());
  Hive.registerAdapter(CategoryAdapter());
    

  Get.put(FlashcardController());
  Get.put(CategoryController());
  
  runApp(Memora());
}

class Memora extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Memora',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[100],
        // Additional theme customizations
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 6,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
