import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/feature_item.dart';
import '../widgets/guide_dialog.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onEnterApp;
  final Function toggleTheme;

  const WelcomeScreen({
    Key? key,
    required this.onEnterApp,
    required this.toggleTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade700, Colors.green.shade500],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogo(),
                  SizedBox(height: 32),
                  _buildAppTitle(),
                  SizedBox(height: 8),
                  _buildAppTagline(),
                  SizedBox(height: 40),
                  _buildAppDescription(context),
                  SizedBox(height: 40),
                  _buildStartButton(),
                  SizedBox(height: 16),
                  _buildGuideButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => toggleTheme(),
        child: Icon(Icons.brightness_6),
        tooltip: 'Toggle Theme',
        mini: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green.shade700,
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(Icons.eco, size: 80, color: Colors.green.shade700),
      ),
    );
  }

  Widget _buildAppTitle() {
    return Text(
      AppConstants.appName,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildAppTagline() {
    return Text(
      AppConstants.appTagline,
      style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAppDescription(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            AppConstants.appDescription,
            style: TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FeatureItem(icon: Icons.camera_alt, label: 'Deteksi Penyakit'),
              SizedBox(width: 20),
              FeatureItem(icon: Icons.history, label: 'Riwayat Diagnosis'),
              SizedBox(width: 20),
              FeatureItem(icon: Icons.library_books, label: 'Perpustakaan'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return ElevatedButton(
      onPressed: onEnterApp,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green.shade700,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
      ),
      child: Text(
        'MULAI APLIKASI',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildGuideButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        _showGuideDialog(context);
      },
      child: Text(
        'Panduan Penggunaan',
        style: TextStyle(
          color: Colors.white,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  void _showGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => GuideDialog(onStart: onEnterApp),
    );
  }
}
