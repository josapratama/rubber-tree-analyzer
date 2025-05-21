import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/diagnosis.dart';
import '../widgets/diagnosis_card.dart';
import '../widgets/result_detail.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Diagnosis> _diagnoses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDiagnoses();
  }

  Future<void> _fetchDiagnoses() async {
    try {
      final diagnoses = await ApiService.getAllDiagnoses();
      setState(() {
        _diagnoses = diagnoses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _fetchDiagnoses,
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _diagnoses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Belum ada riwayat diagnosis',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _diagnoses.length,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    return DiagnosisCard(
                      diagnosis: _diagnoses[index],
                      onTap: () => _showDiagnosisDetails(_diagnoses[index]),
                    );
                  },
                ),
    );
  }

  void _showDiagnosisDetails(Diagnosis diagnosis) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ResultDetail(diagnosis: diagnosis),
    );
  }
}