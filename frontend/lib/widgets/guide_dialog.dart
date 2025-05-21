import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class GuideDialog extends StatelessWidget {
  final VoidCallback onStart;

  const GuideDialog({
    Key? key,
    required this.onStart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Panduan Penggunaan'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: AppConstants.guideSteps.entries.map((entry) {
            return _buildGuideStep(context, entry.key, entry.value);
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Tutup'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onStart();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
          ),
          child: Text('Mulai Aplikasi'),
        ),
      ],
    );
  }

  Widget _buildGuideStep(BuildContext context, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 4),
        Text(description),
        SizedBox(height: 12),
      ],
    );
  }
}