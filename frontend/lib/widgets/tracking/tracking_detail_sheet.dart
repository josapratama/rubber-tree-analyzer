import 'package:flutter/material.dart';
import '../../models/tracking.dart';
import '../../utils/date_formatter.dart';

class TrackingDetailSheet extends StatelessWidget {
  final TreeTracking tracking;
  final VoidCallback onClose;
  final Function(TreeTracking) onEdit;

  const TrackingDetailSheet({
    Key? key,
    required this.tracking,
    required this.onClose,
    required this.onEdit,
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
            'Detail Pelacakan',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Divider(thickness: 1),
          SizedBox(height: 16),
          _buildDetailRow('Tanggal', DateFormatter.formatDate(tracking.tanggal)),
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
                  onPressed: onClose,
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
                  onPressed: () => onEdit(tracking),
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
}