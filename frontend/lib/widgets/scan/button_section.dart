import 'package:flutter/material.dart';

class ButtonSection extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  const ButtonSection({
    Key? key,
    required this.isLoading,
    required this.onCameraPressed,
    required this.onGalleryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : onCameraPressed,
            icon: Icon(Icons.camera_alt),
            label: Text('Kamera'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : onGalleryPressed,
            icon: Icon(Icons.photo_library),
            label: Text('Galeri'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}