import 'package:flutter/material.dart';
import '../../models/diagnosis.dart';
import '../../utils/date_formatter.dart';

class DiagnosisInfoCard extends StatelessWidget {
  final Diagnosis diagnosis;

  const DiagnosisInfoCard({Key? key, required this.diagnosis}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            _buildInfoRow('Nama Pohon', diagnosis.namaPohon),
            _buildInfoRow('Status', diagnosis.status),
            if (diagnosis.jenisPenyakit != null)
              _buildInfoRow('Jenis Penyakit', diagnosis.jenisPenyakit!),
            _buildInfoRow(
              'Tanggal Diagnosis',
              DateFormatter.formatDate(diagnosis.createdAt),
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
}