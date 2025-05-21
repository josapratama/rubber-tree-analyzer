import 'package:flutter/material.dart';
import 'scan_screen.dart';
import 'history_screen.dart';
import 'disease_library_screen.dart';
import '../utils/accessibility_utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showMainApp = false;
  int _selectedIndex = 0;
  final List<Widget> _pages = [ScanPage(), HistoryPage(), DiseaseLibraryPage()];
  final List<String> _titles = [
    'Deteksi Pohon Karet',
    'Riwayat Diagnosis',
    'Perpustakaan Penyakit',
  ];

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
      AccessibilityUtils.speak(_titles[index]);
    }
  }

  void _enterMainApp() {
    setState(() {
      _showMainApp = true;
    });
    // Membaca nama halaman dengan TTS
    AccessibilityUtils.speak(_titles[_selectedIndex]);
  }

  @override
  Widget build(BuildContext context) {
    if (_showMainApp) {
      return _buildMainApp();
    } else {
      return _buildWelcomeScreen();
    }
  }

  Widget _buildMainApp() {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        elevation: 0,
        backgroundColor: Colors.green.shade500,
        actions: [AccessibilityUtils.buildAccessibilityButton(context)],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Perpustakaan',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green.shade500,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildWelcomeScreen() {
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
                  // Logo aplikasi
                  Container(
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
                      child: Icon(
                        Icons.eco,
                        size: 80,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                  SizedBox(height: 32),

                  // Nama aplikasi
                  Text(
                    'POHON KARET',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 8),

                  // Tagline aplikasi
                  Text(
                    'Pemantau Kesehatan Pohon Karet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),

                  // Deskripsi aplikasi
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Aplikasi untuk membantu petani karet mendeteksi dan mengelola kesehatan pohon karet dengan teknologi kecerdasan buatan.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFeatureItem(
                              Icons.camera_alt,
                              'Deteksi Penyakit',
                            ),
                            SizedBox(width: 24),
                            _buildFeatureItem(
                              Icons.history,
                              'Riwayat Diagnosis',
                            ),
                            SizedBox(width: 24),
                            _buildFeatureItem(
                              Icons.library_books,
                              'Perpustakaan',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),

                  // Tombol masuk
                  ElevatedButton(
                    onPressed: _enterMainApp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green.shade700,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
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
                  ),
                  SizedBox(height: 16),

                  // Tombol panduan penggunaan
                  TextButton(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  void _showGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Panduan Penggunaan'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildGuideStep(
                    '1. Deteksi Penyakit',
                    'Ambil foto pohon karet untuk mendeteksi penyakit secara otomatis.',
                  ),
                  SizedBox(height: 12),
                  _buildGuideStep(
                    '2. Riwayat Diagnosis',
                    'Lihat riwayat diagnosis pohon karet yang telah dilakukan sebelumnya.',
                  ),
                  SizedBox(height: 12),
                  _buildGuideStep(
                    '3. Perpustakaan Penyakit',
                    'Pelajari berbagai jenis penyakit pohon karet dan cara penanganannya.',
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Tutup'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _enterMainApp();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: Text('Mulai Aplikasi'),
              ),
            ],
          ),
    );
  }

  Widget _buildGuideStep(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 4),
        Text(description),
      ],
    );
  }
}
