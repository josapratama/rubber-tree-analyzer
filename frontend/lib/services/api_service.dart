import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/diagnosis.dart';
import '../models/disease_library.dart';
import '../models/tracking.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  
  factory ApiService() {
    return _instance;
  }
  
  ApiService._internal();
  
  // Metode umum untuk menangani error
  static Future<T> _handleResponse<T>(Future<http.Response> responseFuture, T Function(dynamic json) fromJson) async {
    try {
      final response = await responseFuture;
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = json.decode(response.body);
        return fromJson(jsonData);
      } else {
        throw Exception('Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    } on HttpException {
      throw Exception('Tidak dapat menemukan layanan yang diminta.');
    } on FormatException {
      throw Exception('Format respons tidak valid.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
  
  // Metode untuk analisis gambar
  static Future<Diagnosis> analyzeImage(File imageFile) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.analyzeEndpoint}');
    
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Diagnosis.fromJson(jsonData);
    } else {
      throw Exception('Gagal menganalisis gambar: ${response.statusCode}');
    }
  }
  
  // Implementasi metode lainnya dengan pola yang sama
  static Future<List<Diagnosis>> getAllDiagnoses() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.diagnosesEndpoint}');
    
    return _handleResponse(
      http.get(uri),
      (json) => (json as List).map((item) => Diagnosis.fromJson(item)).toList(),
    );
  }
  
  static Future<List<RubberTreeDisease>> getAllDiseases() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.diseaseLibraryEndpoint}');
    
    return _handleResponse(
      http.get(uri),
      (json) => (json as List).map((item) => RubberTreeDisease.fromJson(item)).toList(),
    );
  }
  
  static Future<List<TreeTracking>> getTrackingByDiagnosisId(int diagnosisId) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.trackingEndpoint}?diagnosis_id=$diagnosisId');
    
    return _handleResponse(
      http.get(uri),
      (json) => (json as List).map((item) => TreeTracking.fromJson(item)).toList(),
    );
  }
  
  // Menambahkan metode addTracking yang hilang
  static Future<TreeTracking> addTracking(TreeTracking tracking, String? photoUrl) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.trackingEndpoint}');
    
    final Map<String, dynamic> data = tracking.toJson();
    if (photoUrl != null) {
      data['foto_url'] = photoUrl;
    }
    
    return _handleResponse(
      http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      ),
      (json) => TreeTracking.fromJson(json),
    );
  }
  
  // Tambahkan metode lain sesuai kebutuhan
  static Future<String> uploadImage(File imageFile) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.analyzeEndpoint}');
    
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['url'] ?? '';
    } else {
      throw Exception('Failed to upload image: ${response.statusCode}');
    }
  }
}
