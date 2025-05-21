import 'package:flutter/material.dart';

class HealthIndicator {
  static Widget buildHealthIndicator(int health, BuildContext context) {
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
}