import 'package:flutter/material.dart';
import 'scan_screen.dart';
import 'history_screen.dart';
import 'disease_library_screen.dart';
import '../utils/accessibility_utils.dart';
import '../constants/app_constants.dart';
import 'welcome_screen.dart';
import 'main_app_screen.dart';

class HomePage extends StatefulWidget {
  final Function toggleTheme;

  const HomePage({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showMainApp = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Inisialisasi TTS
    AccessibilityUtils.initTts();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      // Membaca nama halaman dengan TTS
      AccessibilityUtils.speak(AppConstants.pageTitles[index]);
    }
  }

  void _enterMainApp() {
    setState(() {
      _showMainApp = true;
    });
    // Membaca nama halaman dengan TTS
    AccessibilityUtils.speak(AppConstants.pageTitles[_selectedIndex]);
  }

  @override
  Widget build(BuildContext context) {
    if (_showMainApp) {
      return MainAppScreen(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        toggleTheme: widget.toggleTheme,
      );
    } else {
      return WelcomeScreen(
        onEnterApp: _enterMainApp,
        toggleTheme: widget.toggleTheme,
      );
    }
  }
}
