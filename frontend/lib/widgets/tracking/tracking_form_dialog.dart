import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/tracking.dart';

class TrackingFormDialog extends StatefulWidget {
  final int diagnosisId;
  final TreeTracking? initialTracking;
  final Function(TreeTracking, File?) onSubmit;

  const TrackingFormDialog({
    Key? key,
    required this.diagnosisId,
    this.initialTracking,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _TrackingFormDialogState createState() => _TrackingFormDialogState();
}

class _TrackingFormDialogState extends State<TrackingFormDialog> {
  final formKey = GlobalKey<FormState>();
  late int healthValue;
  String? notes;
  String? location;
  String? action;
  File? imageFile;
  bool isEditing = false;
  String? existingImageUrl;

  @override
  void initState() {
    super.initState();
    isEditing = widget.initialTracking != null;

    if (isEditing) {
      // Inisialisasi nilai dari tracking yang ada
      healthValue = widget.initialTracking!.tingkatKesehatan;
      notes = widget.initialTracking!.catatan;
      location = widget.initialTracking!.lokasi;
      action = widget.initialTracking!.tindakanDilakukan;
      existingImageUrl = widget.initialTracking!.fotoUrl;
    } else {
      // Nilai default untuk tambah baru
      healthValue = 50;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                isEditing
                    ? 'Edit Catatan Pelacakan'
                    : 'Tambah Catatan Pelacakan',
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
                ),
                initialValue: location,
                onChanged: (value) => location = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Catatan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                initialValue: notes,
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
                ),
                initialValue: action,
                maxLines: 2,
                onChanged: (value) => action = value,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.photo_camera),
                      label: Text('Pilih Foto'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              if (imageFile != null) ...[
                SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    imageFile!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ] else if (existingImageUrl != null) ...[
                SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    existingImageUrl!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Center(child: Text('Gagal memuat gambar')),
                      );
                    },
                  ),
                ),
              ],
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Batal'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // Create a TreeTracking object from the form data
                          final tracking = TreeTracking(
                            id: isEditing ? widget.initialTracking!.id : null,
                            diagnosisId: widget.diagnosisId,
                            tingkatKesehatan: healthValue,
                            tanggal: DateTime.now(),
                            catatan: notes,
                            lokasi: location,
                            petugas: null, // Add petugas if needed
                            tindakanDilakukan: action,
                            fotoUrl: existingImageUrl,
                          );
                          
                          // Pass the tracking object and image file to onSubmit
                          widget.onSubmit(tracking, imageFile);
                        }
                      },
                      child: Text('Simpan'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
