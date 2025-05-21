import 'package:flutter/material.dart';
import '../../models/diagnosis.dart';
import '../../utils/health_indicator.dart';

class ValidResultCard extends StatelessWidget {
  final Diagnosis diagnosis;
  final VoidCallback onSaveResult;

  const ValidResultCard({
    Key? key,
    required this.diagnosis,
    required this.onSaveResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor =
        diagnosis.status.toLowerCase() == 'sehat' ? Colors.green : Colors.red;

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
                  diagnosis.status.toLowerCase() == 'sehat'
                      ? Icons.check_circle
                      : Icons.warning,
                  color: statusColor,
                  size: 28,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Hasil Diagnosis',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                HealthIndicator.buildHealthIndicator(
                  0, // Replace with appropriate default value or existing property
                  context,
                ),
              ],
            ),
            Divider(thickness: 1.5),
            SizedBox(height: 12),
            _buildInfoRow('Nama Pohon', diagnosis.namaPohon),
            _buildInfoRow('Status', diagnosis.status),
            if (diagnosis.jenisPenyakit != null && diagnosis.jenisPenyakit!.isNotEmpty)
              _buildInfoRow('Jenis Penyakit', diagnosis.jenisPenyakit!),
            if (diagnosis.penyebab != null && diagnosis.penyebab!.isNotEmpty)
              _buildInfoRow('Penyebab', diagnosis.penyebab!),
            _buildInfoRow('Saran Pengobatan', diagnosis.saranPengobatan),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: onSaveResult,
                  icon: Icon(Icons.save),
                  label: Text('Simpan Hasil'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}