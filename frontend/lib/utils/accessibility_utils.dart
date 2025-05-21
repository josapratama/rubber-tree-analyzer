import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AccessibilityUtils {
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _ttsEnabled = false;

  static void initTts() {
    _flutterTts.setLanguage('id-ID');
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
  }

  static Future<void> speak(String text) async {
    if (_ttsEnabled) {
      await _flutterTts.speak(text);
    }
  }

  static void toggleTts() {
    _ttsEnabled = !_ttsEnabled;
  }

  static Widget buildAccessibilityButton(BuildContext context) {
    return IconButton(
      icon: Icon(_ttsEnabled ? Icons.hearing : Icons.hearing_disabled),
      onPressed: () {
        toggleTts();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _ttsEnabled
                  ? 'Pembacaan teks diaktifkan'
                  : 'Pembacaan teks dinonaktifkan',
            ),
            duration: Duration(seconds: 2),
          ),
        );
      },
      tooltip: 'Bantuan Aksesibilitas',
    );
  }
}
