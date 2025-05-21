import 'package:flutter/material.dart';
import '../models/disease_library.dart';
import '../services/api_service.dart';
import '../utils/accessibility_utils.dart';

class DiseaseLibraryPage extends StatefulWidget {
  @override
  _DiseaseLibraryPageState createState() => _DiseaseLibraryPageState();
}

class _DiseaseLibraryPageState extends State<DiseaseLibraryPage> {
  List<RubberTreeDisease> _diseases = [];
  List<RubberTreeDisease> _filteredDiseases = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchDiseases();
  }

  Future<void> _fetchDiseases() async {
    try {
      final diseases = await ApiService.getAllDiseases();
      setState(() {
        _diseases = diseases;
        _filteredDiseases = diseases;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _filterDiseases(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredDiseases = _diseases;
      } else {
        _filteredDiseases = _diseases.where((disease) {
          final nameLower = disease.name.toLowerCase();
          final queryLower = query.toLowerCase();
          final symptomsLower = disease.symptoms?.toLowerCase() ?? '';
          
          return nameLower.contains(queryLower) || symptomsLower.contains(queryLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari penyakit...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _filterDiseases,
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _filteredDiseases.isEmpty
                    ? Center(
                      child: Text(
                        _searchQuery.isEmpty
                            ? 'Tidak ada data penyakit'
                            : 'Tidak ditemukan penyakit untuk "$_searchQuery"',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                    : ListView.builder(
                      itemCount: _filteredDiseases.length,
                      itemBuilder: (context, index) {
                        final disease = _filteredDiseases[index];
                        return _buildDiseaseCard(disease);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseCard(RubberTreeDisease disease) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Membaca nama penyakit dengan TTS
          AccessibilityUtils.speak(disease.name);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DiseaseDetailPage(disease: disease),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                disease.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                disease.description ?? 'Tidak ada deskripsi',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children:
                    disease.affectedParts.map((part) {
                      return Chip(
                        label: Text(part),
                        backgroundColor: Colors.green.shade100,
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DiseaseDetailPage extends StatelessWidget {
  final RubberTreeDisease disease;

  const DiseaseDetailPage({Key? key, required this.disease}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(disease.name)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (disease.imageUrls.isNotEmpty)
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: disease.imageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          disease.imageUrls[index],
                          fit: BoxFit.cover,
                          width: 200,
                          height: 200,
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 16),
            _buildSection('Deskripsi', disease.description ?? 'Tidak ada informasi'),
            _buildSection('Gejala', disease.symptoms ?? 'Tidak ada informasi'),
            _buildSection('Penyebab', disease.causes ?? 'Tidak ada informasi'),
            _buildSection('Pengobatan', disease.treatment ?? 'Tidak ada informasi'),
            _buildSection('Pencegahan', disease.prevention ?? 'Tidak ada informasi'),
            _buildSection('Tingkat Keparahan', disease.severity ?? 'Tidak ada informasi'),
            _buildSection('Potensi Penyebaran', disease.spreadPotential ?? 'Tidak ada informasi'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
          SizedBox(height: 8),
          Text(content, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
