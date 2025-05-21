import 'dart:io';
import 'package:flutter/material.dart';
import '../models/diagnosis.dart';
import '../models/tracking.dart';
import '../services/api_service.dart';
import '../utils/accessibility_utils.dart';
import '../widgets/tracking/diagnosis_info_card.dart';
import '../widgets/tracking/health_chart.dart';
import '../widgets/tracking/tracking_list.dart';
import '../widgets/tracking/tracking_detail_sheet.dart';
import '../widgets/tracking/tracking_form_dialog.dart';

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
                    DiagnosisInfoCard(diagnosis: widget.diagnosis),
                    SizedBox(height: 24),
                    HealthChart(trackingList: _trackingList),
                    SizedBox(height: 24),
                    TrackingList(
                      trackingList: _trackingList,
                      onTrackingTap: _showTrackingDetail,
                    ),
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

  void _showTrackingDetail(TreeTracking tracking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => TrackingDetailSheet(
            tracking: tracking,
            onClose: () => Navigator.pop(context),
            onEdit: (tracking) {
              Navigator.pop(context);
              _showEditTrackingDialog(tracking);
            },
          ),
    );
  }

  void _showAddTrackingDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return TrackingFormDialog(
          diagnosisId: widget.diagnosis.id,
          onSubmit: _handleAddTracking,
        );
      },
    );
  }

  void _showEditTrackingDialog(TreeTracking tracking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return TrackingFormDialog(
          diagnosisId: widget.diagnosis.id,
          initialTracking: tracking,
          onSubmit: _handleEditTracking,
        );
      },
    );
  }

  // Add the missing method to handle adding a new tracking record
  Future<void> _handleAddTracking(
    TreeTracking tracking,
    File? imageFile,
  ) async {
    try {
      setState(() => _isLoading = true);

      String? photoUrl;
      if (imageFile != null) {
        photoUrl = await ApiService.uploadImage(imageFile);
      }

      await ApiService.addTracking(tracking, photoUrl);

      // Refresh the tracking list
      await _fetchTrackingData();

      // Close the dialog
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Catatan pelacakan berhasil ditambahkan'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // Add method to handle editing an existing tracking record
  Future<void> _handleEditTracking(
    TreeTracking tracking,
    File? imageFile,
  ) async {
    try {
      setState(() => _isLoading = true);

      String? photoUrl;
      if (imageFile != null) {
        photoUrl = await ApiService.uploadImage(imageFile);
      }

      // Update the tracking with the new photo URL if provided
      final updatedTracking = TreeTracking(
        id: tracking.id,
        diagnosisId: tracking.diagnosisId,
        tingkatKesehatan: tracking.tingkatKesehatan,
        tanggal: tracking.tanggal,
        catatan: tracking.catatan,
        lokasi: tracking.lokasi,
        petugas: tracking.petugas,
        tindakanDilakukan: tracking.tindakanDilakukan,
        fotoUrl: photoUrl ?? tracking.fotoUrl,
      );

      // Call the API to update the tracking
      await ApiService.updateTracking(updatedTracking);

      // Refresh the tracking list
      await _fetchTrackingData();

      // Close the dialog
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Catatan pelacakan berhasil diperbarui'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
}
