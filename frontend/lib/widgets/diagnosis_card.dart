import 'package:flutter/material.dart';
import '../models/diagnosis.dart';

class DiagnosisCard extends StatelessWidget {
  final Diagnosis diagnosis;
  final VoidCallback onTap;

  const DiagnosisCard({
    Key? key,
    required this.diagnosis,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          diagnosis.namaPohon,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text('Status: ${diagnosis.status}'),
            if (diagnosis.jenisPenyakit != null)
              Text('Penyakit: ${diagnosis.jenisPenyakit}'),
            // Replace bagianTanaman with filename since it likely contains the plant part info
            Text('Bagian: ${diagnosis.filename.split('_').first}'),
            Text('Tanggal: ${_formatDate(diagnosis.createdAt)}'),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}