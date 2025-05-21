import 'package:flutter/material.dart';
import '../models/diagnosis.dart';

class ResultDetail extends StatelessWidget {
  final Diagnosis diagnosis;

  const ResultDetail({
    Key? key,
    required this.diagnosis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            'Detail Diagnosis',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Divider(thickness: 1),
          SizedBox(height: 16),
          _buildDetailRow('ID', diagnosis.id.toString()),
          _buildDetailRow('Nama Pohon', diagnosis.namaPohon),
          _buildDetailRow('Status', diagnosis.status),
          if (diagnosis.jenisPenyakit != null)
            _buildDetailRow('Jenis Penyakit', diagnosis.jenisPenyakit!),
          if (diagnosis.penyebab != null)
            _buildDetailRow('Penyebab', diagnosis.penyebab!),
          _buildDetailRow('Saran Pengobatan', diagnosis.saranPengobatan),
          if (diagnosis.gejalaVisual != null)
            _buildDetailRow('Gejala Visual', diagnosis.gejalaVisual!),
          if (diagnosis.tingkatKeparahan != null)
            _buildDetailRow('Tingkat Keparahan', diagnosis.tingkatKeparahan!),
          if (diagnosis.potensiPenyebaran != null)
            _buildDetailRow('Potensi Penyebaran', diagnosis.potensiPenyebaran!),
          if (diagnosis.strategiPencegahan != null)
            _buildDetailRow('Strategi Pencegahan', diagnosis.strategiPencegahan!),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Tutup',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
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
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}