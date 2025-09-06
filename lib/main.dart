import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:memora/controllers/category_controller.dart';
import 'package:memora/controllers/flashcard_controller.dart';
import 'package:memora/controllers/theme_controller.dart';
import 'package:memora/models/category.dart';
import 'package:memora/screens/home_screen.dart';
import 'models/flashcard.dart';
// import 'screens/cards_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  await GetStorage.init();
  Get.put(ThemeController());
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
    final ThemeController themeController = Get.find();
    return Obx(() => GetMaterialApp(
      title: 'Memora',
      debugShowCheckedModeBanner: false, 
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   scaffoldBackgroundColor: Colors.blue[100],
      //   // Additional theme customizations
      //   appBarTheme: AppBarTheme(
      //     elevation: 0,
      //     centerTitle: true,
      //   ),
      //   cardTheme: CardThemeData(
      //     elevation: 4,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(12),
      //     ),
      //   ),
      //   floatingActionButtonTheme: FloatingActionButtonThemeData(
      //     elevation: 6,
      //   ),
      // ),
      // Set the themes as before
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50], // Your desired light blue
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),

      // 2. THIS IS YOUR CUSTOM DARK THEME
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF121212), // A standard dark background
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
        ),
      ),
      
      // --- THEME CUSTOMIZATION END ---

      themeMode: themeController.isDarkMode.value 
          ? ThemeMode.dark 
          : ThemeMode.light,

      home: HomeScreen(),
    ));
  }
}
