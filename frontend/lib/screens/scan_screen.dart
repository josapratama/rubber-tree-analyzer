import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../models/diagnosis.dart';
import '../widgets/scan/image_section.dart';
import '../widgets/scan/button_section.dart';
import '../widgets/scan/loading_indicator.dart';
import '../widgets/scan/result_section.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage>
    with SingleTickerProviderStateMixin {
  File? _image;
  bool _isLoading = false;
  Diagnosis? _diagnosis;
  late AnimationController _animationController;
  late Animation<double> _animation;
  String? _errorMessage;
  bool _isValidImage = true; // Tambahkan flag untuk validasi gambar

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 50, // Turunkan kualitas gambar untuk upload lebih cepat
      maxWidth: 800,    // Batasi lebar maksimum
      maxHeight: 800,   // Batasi tinggi maksimum
    );

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() {
        _image = imageFile;
        _isLoading = true;
        _diagnosis = null; // Reset diagnosis sebelumnya
        _errorMessage = null; // Reset pesan error
        _isValidImage = true; // Reset flag validasi gambar
      });
      await _uploadImage(imageFile);
    }
  }

  // Tambahkan variabel untuk melacak request
  bool _isCancelled = false;
  
  Future<void> _uploadImage(File imageFile) async {
    // Reset flag pembatalan
    _isCancelled = false;
    
    try {
      // Jika dibatalkan, hentikan proses
      if (_isCancelled) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      
      final diagnosis = await ApiService.analyzeImage(imageFile);
      
      // Jika dibatalkan, jangan update UI
      if (_isCancelled) return;

      setState(() {
        _diagnosis = diagnosis;
        _isLoading = false;
      });
      
      // Cek apakah gambar valid
      if (diagnosis.isValidImage == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(diagnosis.pesanError ?? 'Gambar tidak valid'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      
      // Animasi hasil
      _animationController.reset();
      _animationController.forward();
    } catch (e) {
      // Jika dibatalkan, jangan tampilkan error
      if (_isCancelled) return;
      
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _saveResult() {
    // Implementasi untuk menyimpan hasil ke riwayat lokal
    if (_diagnosis != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hasil diagnosis berhasil disimpan'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _cancelAnalysis() {
    setState(() {
      _isCancelled = true;
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Analisis gambar dibatalkan'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImageSection(image: _image),
            SizedBox(height: 20),
            ButtonSection(
              isLoading: _isLoading,
              onCameraPressed: () => _pickImage(ImageSource.camera),
              onGalleryPressed: () => _pickImage(ImageSource.gallery),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              Column(
                children: [
                  LoadingIndicator(),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _cancelAnalysis,
                    icon: Icon(Icons.cancel),
                    label: Text('Batalkan Analisis'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              )
            else if (_diagnosis != null)
              FadeTransition(
                opacity: _animation, 
                child: ResultSection(
                  diagnosis: _diagnosis!,
                  onSaveResult: _saveResult,
                  onTryAgain: () => _pickImage(ImageSource.gallery),
                ),
              )
            else if (_errorMessage != null)
              Center(
                child: Column(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    SizedBox(height: 16),
                    Text(
                      'Terjadi kesalahan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: Icon(Icons.refresh),
                      label: Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
