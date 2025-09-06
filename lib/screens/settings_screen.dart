import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../controllers/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      // body: GetBuilder<ThemeController>(
      //   builder: (themeController) {
      //     return ListView(
      //       padding: const EdgeInsets.all(16),
      //       children: [
      //         // Dark Mode Section
      //         Card(
      //           child: ListTile(
      //             leading: Icon(
      //               themeController.isDarkMode 
      //                   ? Icons.dark_mode 
      //                   : Icons.light_mode,
      //               color: Colors.blue,
      //             ),
      //             title: const Text('Dark Mode'),
      //             subtitle: Text(
      //               themeController.isDarkMode ? 'Enabled' : 'Disabled',
      //             ),
      //             trailing: Switch(
      //               value: themeController.isDarkMode,
      //               onChanged: (_) => themeController.toggleTheme(),
      //               activeColor: Colors.blue,
      //             ),
      //           ),
      //         ),
              
      //         const SizedBox(height: 16),
              
      //         // App Info Section
      //         Card(
      //           child: Column(
      //             children: [
      //               ListTile(
      //                 leading: const Icon(Icons.info, color: Colors.blue),
      //                 title: const Text('App Version'),
      //                 subtitle: const Text('1.0.0'),
      //               ),
      //               ListTile(
      //                 leading: const Icon(Icons.code, color: Colors.blue),
      //                 title: const Text('Built with Flutter'),
      //                 subtitle: const Text('Level 3 - Categories & Persistence'),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     );
      //   },
      // ),
    );
  }
}
