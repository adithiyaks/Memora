// In screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => SwitchListTile(
              title: const Text('Dark Mode'),
              secondary: Icon(
                themeController.isDarkMode.value
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
              ),
              // Use the .value of the reactive variable
              value: themeController.isDarkMode.value,
              onChanged: (value) {
                themeController.toggleTheme();
              },
            )),
      ),
    );
  }
}