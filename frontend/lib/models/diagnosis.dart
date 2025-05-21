class Diagnosis {
  final int id;
  final String filename;
  final String namaPohon;
  final String status;
  final String? jenisPenyakit;
  final String? penyebab;
  final String saranPengobatan;
  final String? gejalaVisual;
  final String? tingkatKeparahan;
  final String? potensiPenyebaran;
  final String? strategiPencegahan;
  final DateTime createdAt;
  final bool isValidImage;
  final String? pesanError;

  Diagnosis({
    required this.id,
    required this.filename,
    required this.namaPohon,
    required this.status,
    this.jenisPenyakit,
    this.penyebab,
    required this.saranPengobatan,
    this.gejalaVisual,
    this.tingkatKeparahan,
    this.potensiPenyebaran,
    this.strategiPencegahan,
    required this.createdAt,
    this.isValidImage = true,
    this.pesanError,
  });

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      id: json['id'],
      filename: json['filename'],
      namaPohon: json['nama_pohon'],
      status: json['status'],
      jenisPenyakit: json['jenis_penyakit'],
      penyebab: json['penyebab'],
      saranPengobatan: json['saran_pengobatan'],
      gejalaVisual: json['gejala_visual'],
      tingkatKeparahan: json['tingkat_keparahan'],
      potensiPenyebaran: json['potensi_penyebaran'],
      strategiPencegahan: json['strategi_pencegahan'],
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
      isValidImage: json['is_valid_image'] ?? true,
      pesanError: json['pesan_error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filename': filename,
      'nama_pohon': namaPohon,
      'status': status,
      'jenis_penyakit': jenisPenyakit,
      'penyebab': penyebab,
      'saran_pengobatan': saranPengobatan,
      'gejala_visual': gejalaVisual,
      'tingkat_keparahan': tingkatKeparahan,
      'potensi_penyebaran': potensiPenyebaran,
      'strategi_pencegahan': strategiPencegahan,
      'created_at': createdAt.toIso8601String(),
      'is_valid_image': isValidImage,
      'pesan_error': pesanError,
    };
  }

  /// ✅ Getter ini sekarang berada dalam konteks class dan bisa akses `filename`
  String get bagianTanaman {
    final parts = filename.split('_');
    return parts.isNotEmpty ? parts[0] : 'Tidak diketahui';
  }
}
