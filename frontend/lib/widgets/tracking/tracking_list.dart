import 'package:flutter/material.dart';
import '../../models/tracking.dart';
import '../../utils/date_formatter.dart';
import '../../utils/health_indicator.dart';

class TrackingList extends StatelessWidget {
  final List<TreeTracking> trackingList;
  final Function(TreeTracking) onTrackingTap;

  const TrackingList({
    Key? key,
    required this.trackingList,
    required this.onTrackingTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (trackingList.isEmpty) {
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
          itemCount: trackingList.length,
          itemBuilder: (context, index) {
            final tracking = trackingList[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () => onTrackingTap(tracking),
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
                            DateFormatter.formatDate(tracking.tanggal),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          HealthIndicator.buildHealthIndicator(
                            tracking.tingkatKesehatan,
                            context,
                          ),
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
}