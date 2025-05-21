import 'package:flutter/material.dart';
import 'dart:async';

class LoadingIndicator extends StatefulWidget {
  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  int _seconds = 0;
  late Timer _timer;
  
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }
  
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  
  String get _timeText {
    if (_seconds < 30) {
      return 'Menganalisis gambar...';
    } else if (_seconds < 60) {
      return 'Masih menganalisis, mohon tunggu...';
    } else {
      return 'Analisis membutuhkan waktu lebih lama dari biasanya, mohon bersabar...';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            _timeText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Waktu: ${_seconds ~/ 60}:${(_seconds % 60).toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}