import 'package:flutter/material.dart';
import '../../models/diagnosis.dart';
import 'invalid_result_card.dart';
import 'valid_result_card.dart';

class ResultSection extends StatelessWidget {
  final Diagnosis diagnosis;
  final VoidCallback onSaveResult;
  final VoidCallback onTryAgain;

  const ResultSection({
    Key? key,
    required this.diagnosis,
    required this.onSaveResult,
    required this.onTryAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!diagnosis.isValidImage) {
      return InvalidResultCard(
        pesanError: diagnosis.pesanError,
        onTryAgain: onTryAgain,
      );
    } else {
      return ValidResultCard(
        diagnosis: diagnosis,
        onSaveResult: onSaveResult,
      );
    }
  }
}