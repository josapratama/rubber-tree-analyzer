import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../utils/accessibility_utils.dart';
import 'scan_screen.dart';
import 'history_screen.dart';
import 'disease_library_screen.dart';

class MainAppScreen extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final Function toggleTheme;

  const MainAppScreen({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.toggleTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [ScanPage(), HistoryPage(), DiseaseLibraryPage()];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.pageTitles[selectedIndex]),
        elevation: 0,
        backgroundColor: Colors.green.shade500,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () => toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          AccessibilityUtils.buildAccessibilityButton(context),
        ],
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Perpustakaan',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.green.shade500,
        unselectedItemColor: Colors.grey,
        onTap: onItemTapped,
      ),
    );
  }
}