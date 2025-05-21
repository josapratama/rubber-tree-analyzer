import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/diagnosis.dart';
import '../models/tracking.dart';
import '../services/api_service.dart';
import '../utils/accessibility_utils.dart';

class TrackingPage extends StatefulWidget {
  final Diagnosis diagnosis;

  const TrackingPage({Key? key, required this.diagnosis}) : super(key: key);

  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  List<TreeTracking> _trackingList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTrackingData();
  }

  Future<void> _fetchTrackingData() async {
    try {
      final trackingList = await ApiService.getTrackingByDiagnosisId(
        widget.diagnosis.id,
      );
      setState(() {
        _trackingList = trackingList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pelacakan Perkembangan'),
        actions: [AccessibilityUtils.buildAccessibilityButton(context)],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDiagnosisInfo(),
                    SizedBox(height: 24),
                    _buildHealthChart(),
                    SizedBox(height: 24),
                    _buildTrackingList(),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTrackingDialog,
        child: Icon(Icons.add),
        tooltip: 'Tambah Catatan Baru',
      ),
    );
  }

  Widget _buildDiagnosisInfo() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Diagnosis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Divider(),
            SizedBox(height: 8),
            _buildInfoRow('Nama Pohon', widget.diagnosis.namaPohon),
            _buildInfoRow('Status', widget.diagnosis.status),
            if (widget.diagnosis.jenisPenyakit != null)
              _buildInfoRow('Jenis Penyakit', widget.diagnosis.jenisPenyakit!),
            _buildInfoRow(
              'Tanggal Diagnosis',
              _formatDate(widget.diagnosis.createdAt),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildHealthChart() {
    if (_trackingList.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text(
              'Belum ada data pelacakan untuk menampilkan grafik',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Grafik Perkembangan Kesehatan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value % 20 == 0) {
                            return Text(value.toInt().toString());
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 &&
                              index < _trackingList.length &&
                              index % 2 == 0) {
                            return Text(
                              _formatShortDate(_trackingList[index].tanggal),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  minX: 0,
                  maxX: (_trackingList.length - 1).toDouble(),
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getHealthDataPoints(),
                      isCurved: true,
                      color:
                          Theme.of(
                            context,
                          ).primaryColor, // Changed from 'colors' to 'color'
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withAlpha(
                          76,
                        ), // Changed from 'colors' to 'color'
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(
                  'Tingkat Kesehatan (%)',
                  Theme.of(context).primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  List<FlSpot> _getHealthDataPoints() {
    List<FlSpot> spots = [];
    for (int i = 0; i < _trackingList.length; i++) {
      spots.add(
        FlSpot(i.toDouble(), _trackingList[i].tingkatKesehatan.toDouble()),
      );
    }
    return spots;
  }

  Widget _buildTrackingList() {
    if (_trackingList.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.track_changes, size: 48, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text(
                  'Belum ada catatan pelacakan',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text(
                  'Tambahkan catatan pertama dengan menekan tombol + di bawah',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Riwayat Pelacakan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _trackingList.length,
          itemBuilder: (context, index) {
            final tracking = _trackingList[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () => _showTrackingDetail(tracking),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(tracking.tanggal),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          _buildHealthIndicator(tracking.tingkatKesehatan),
                        ],
                      ),
                      SizedBox(height: 8),
                      if (tracking.catatan != null &&
                          tracking.catatan!.isNotEmpty)
                        Text(
                          tracking.catatan!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Text(
                            tracking.lokasi ?? 'Lokasi tidak dicatat',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      if (tracking.fotoUrl != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.photo,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Foto tersedia',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHealthIndicator(int health) {
    Color color;
    String label;

    if (health >= 80) {
      color = Colors.green;
      label = 'Sangat Baik';
    } else if (health >= 60) {
      color = Colors.lightGreen;
      label = 'Baik';
    } else if (health >= 40) {
      color = Colors.orange;
      label = 'Sedang';
    } else if (health >= 20) {
      color = Colors.deepOrange;
      label = 'Buruk';
    } else {
      color = Colors.red;
      label = 'Sangat Buruk';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(51),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$health%',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  void _showTrackingDetail(TreeTracking tracking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildTrackingDetailSheet(tracking),
    );
  }

  Widget _buildTrackingDetailSheet(TreeTracking tracking) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detail Pelacakan',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Divider(thickness: 1),
          SizedBox(height: 16),
          _buildDetailRow('Tanggal', _formatDate(tracking.tanggal)),
          _buildDetailRow('Tingkat Kesehatan', '${tracking.tingkatKesehatan}%'),
          if (tracking.lokasi != null)
            _buildDetailRow('Lokasi', tracking.lokasi!),
          if (tracking.petugas != null)
            _buildDetailRow('Petugas', tracking.petugas!),
          if (tracking.catatan != null)
            _buildDetailRow('Catatan', tracking.catatan!),
          if (tracking.tindakanDilakukan != null)
            _buildDetailRow('Tindakan', tracking.tindakanDilakukan!),
          SizedBox(height: 16),
          if (tracking.fotoUrl != null) ...[
            Text(
              'Foto',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                tracking.fotoUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: Center(child: Text('Gagal memuat gambar')),
                  );
                },
              ),
            ),
          ],
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Tutup'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showEditTrackingDialog(tracking),
                  icon: Icon(Icons.edit),
                  label: Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showAddTrackingDialog() {
    final formKey = GlobalKey<FormState>();
    int healthValue = 50;
    String? notes;
    String? location;
    String? action;
    File? imageFile;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tambah Catatan Pelacakan',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Divider(thickness: 1),
                      SizedBox(height: 16),
                      Text(
                        'Tingkat Kesehatan: $healthValue%',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Slider(
                        value: healthValue.toDouble(),
                        min: 0,
                        max: 100,
                        divisions: 20,
                        label: '$healthValue%',
                        onChanged: (value) {
                          setState(() {
                            healthValue = value.round();
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Lokasi',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        onChanged: (value) => location = value,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Catatan',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: Icon(Icons.note),
                        ),
                        maxLines: 3,
                        onChanged: (value) => notes = value,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Tindakan yang Dilakukan',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: Icon(Icons.healing),
                        ),
                        onChanged: (value) => action = value,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final picker = ImagePicker();
                                final pickedFile = await picker.pickImage(
                                  source: ImageSource.camera,
                                  imageQuality: 80,
                                );
                                if (pickedFile != null) {
                                  setState(() {
                                    imageFile = File(pickedFile.path);
                                  });
                                }
                              },
                              icon: Icon(Icons.camera_alt),
                              label: Text('Ambil Foto'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final picker = ImagePicker();
                                final pickedFile = await picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 80,
                                );
                                if (pickedFile != null) {
                                  setState(() {
                                    imageFile = File(pickedFile.path);
                                  });
                                }
                              },
                              icon: Icon(Icons.photo_library),
                              label: Text('Galeri'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (imageFile != null) ...[
                        SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            imageFile!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              Navigator.pop(context);

                              // Tampilkan loading
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder:
                                    (context) => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                              );

                              try {
                                // Buat objek tracking baru
                                final newTracking = TreeTracking(
                                  id: 0, // ID akan diberikan oleh server
                                  diagnosisId: widget.diagnosis.id,
                                  tanggal: DateTime.now(),
                                  tingkatKesehatan: healthValue,
                                  lokasi: location,
                                  petugas:
                                      'Pengguna Aplikasi', // Bisa diganti dengan data pengguna yang login
                                  catatan: notes,
                                  tindakanDilakukan: action,
                                  fotoUrl:
                                      null, // URL foto akan diupdate setelah upload
                                );

                                // Upload foto jika ada
                                String? photoUrl;
                                if (imageFile != null) {
                                  photoUrl = await ApiService.uploadImage(
                                    imageFile!,
                                  );
                                }

                                // Tambahkan data tracking ke server
                                await ApiService.addTracking(
                                  newTracking,
                                  photoUrl,
                                );

                                // Refresh data
                                await _fetchTrackingData();

                                // Tutup dialog loading
                                Navigator.pop(context);

                                // Tampilkan pesan sukses
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Catatan pelacakan berhasil ditambahkan',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (e) {
                                // Tutup dialog loading
                                Navigator.pop(context);

                                // Tampilkan pesan error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: Text(
                            'Simpan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditTrackingDialog(TreeTracking tracking) {
    // Implementasi dialog edit tracking
    // Mirip dengan _showAddTrackingDialog tetapi dengan nilai awal dari tracking yang ada
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatShortDate(DateTime date) {
    return '${date.day}/${date.month}';
  }
}

// ... existing code ...

// Gunakan metode ini untuk menggantikan kode yang berulang
Widget _buildInfoRow(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value ?? 'Tidak ada data',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    ),
  );
}
