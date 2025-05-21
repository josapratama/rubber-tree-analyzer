class TreeTracking {
  final int? id;  // Make id nullable
  final int diagnosisId;
  final int tingkatKesehatan;
  final DateTime tanggal;
  final String? catatan;
  final String? lokasi;
  final String? petugas;
  final String? tindakanDilakukan;
  final String? fotoUrl;

  TreeTracking({
    this.id,  // Now accepts null
    required this.diagnosisId,
    required this.tingkatKesehatan,
    required this.tanggal,
    this.catatan,
    this.lokasi,
    this.petugas,
    this.tindakanDilakukan,
    this.fotoUrl,
  });

  factory TreeTracking.fromJson(Map<String, dynamic> json) {
    return TreeTracking(
      id: json['id'],
      diagnosisId: json['diagnosis_id'],
      tanggal: DateTime.parse(json['tanggal']),
      tingkatKesehatan: json['tingkat_kesehatan'],
      lokasi: json['lokasi'],
      petugas: json['petugas'],
      catatan: json['catatan'],
      tindakanDilakukan: json['tindakan_dilakukan'],
      fotoUrl: json['foto_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'diagnosis_id': diagnosisId,
      'tanggal': tanggal.toIso8601String(),
      'tingkat_kesehatan': tingkatKesehatan,
      'lokasi': lokasi,
      'petugas': petugas,
      'catatan': catatan,
      'tindakan_dilakukan': tindakanDilakukan,
      'foto_url': fotoUrl,
    };
  }
}