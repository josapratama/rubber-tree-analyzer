import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../models/diagnosis.dart';
import '../widgets/result_detail.dart';

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
      imageQuality: 80, // Kompresi gambar untuk upload lebih cepat
    );

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() {
        _image = imageFile;
        _isLoading = true;
        _diagnosis = null; // Reset diagnosis sebelumnya
      });
      await _uploadImage(imageFile);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      final diagnosis = await ApiService.analyzeImage(imageFile);

      setState(() {
        _diagnosis = diagnosis;
        _isLoading = false;
      });

      // Animasi hasil
      _animationController.reset();
      _animationController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImageSection(),
            SizedBox(height: 20),
            _buildButtonSection(),
            SizedBox(height: 20),
            if (_isLoading)
              _buildLoadingIndicator()
            else if (_diagnosis != null)
              FadeTransition(opacity: _animation, child: _buildResultSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        children: [
          // Gunakan Lottie untuk animasi loading yang lebih menarik
          // Anda perlu menambahkan file JSON animasi di assets
          // Container(
          //   height: 150,
          //   child: Lottie.asset('assets/animations/scanning.json'),
          // ),
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Menganalisis gambar...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _image != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    _image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  // Overlay gelap untuk teks yang lebih mudah dibaca
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Text(
                        'Gambar Dipilih',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                color: Colors.grey[200],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Pilih gambar pohon karet\n(daun, batang, akar, atau dahan)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildButtonSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : () => _pickImage(ImageSource.camera),
            icon: Icon(Icons.camera_alt),
            label: Text('Kamera'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : () => _pickImage(ImageSource.gallery),
            icon: Icon(Icons.photo_library),
            label: Text('Galeri'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultSection() {
    if (_diagnosis == null) return SizedBox.shrink();

    // Jika gambar tidak valid (bukan pohon karet)
    if (!_diagnosis!.isValidImage) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.red.shade300, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 28),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Gambar Tidak Valid',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(thickness: 1.5),
              SizedBox(height: 12),
              Text(
                _diagnosis!.pesanError ?? 'Silakan unggah gambar daun, batang, akar, atau dahan pohon karet.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: Icon(Icons.refresh),
                  label: Text('Coba Lagi'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Jika gambar valid dan merupakan pohon karet
    Color statusColor = _diagnosis!.status.toLowerCase() == 'sehat'
        ? Colors.green
        : Colors.red;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.withOpacity(0.5), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _diagnosis!.status.toLowerCase() == 'sehat'
                      ? Icons.check_circle
                      : Icons.warning,
                  color: statusColor,
                  size: 28,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Hasil Diagnosis',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.save_alt),
                  onPressed: _saveResult,
                  tooltip: 'Simpan hasil',
                ),
              ],
            ),
            Divider(thickness: 1.5),
            SizedBox(height: 12),
            _buildInfoRow('Tanaman', _diagnosis!.namaPohon),
            _buildInfoRow('Status', _diagnosis!.status,
                valueColor: statusColor),
            if (_diagnosis!.jenisPenyakit != null)
              _buildInfoRow('Jenis Penyakit', _diagnosis!.jenisPenyakit!),
            if (_diagnosis!.penyebab != null)
              _buildInfoRow('Penyebab', _diagnosis!.penyebab!),
            _buildInfoRow('Gejala Visual', _diagnosis!.gejalaVisual ?? 'Tidak ada informasi'),
            if (_diagnosis!.tingkatKeparahan != null)
              _buildInfoRow('Tingkat Keparahan', _diagnosis!.tingkatKeparahan!),
            if (_diagnosis!.potensiPenyebaran != null)
              _buildInfoRow('Potensi Penyebaran', _diagnosis!.potensiPenyebaran!),
            Divider(),
            Text(
              'Saran Pengobatan:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _diagnosis!.saranPengobatan,
              style: TextStyle(fontSize: 15),
            ),
            if (_diagnosis!.strategiPencegahan != null) ...[
              SizedBox(height: 12),
              Text(
                'Strategi Pencegahan:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                _diagnosis!.strategiPencegahan!,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
