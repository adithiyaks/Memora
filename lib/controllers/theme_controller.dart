import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  // 1. Create a reactive '.obs' variable
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 2. Load the saved theme when the controller is created
    isDarkMode.value = _storage.read(_key) ?? false;
  }

  void toggleTheme() {
    // 3. Toggle the reactive variable's value
    isDarkMode.value = !isDarkMode.value;
    
    // 4. Save the new value to storage
    _storage.write(_key, isDarkMode.value);
    
    // 5. Apply the theme change
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    
    // The manual 'update()' call is no longer needed.
  }
}