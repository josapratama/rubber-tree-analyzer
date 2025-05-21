class TreeTracking {
  final int id;
  final int diagnosisId;
  final DateTime tanggal;
  final int tingkatKesehatan;
  final String? lokasi;
  final String? petugas;
  final String? catatan;
  final String? tindakanDilakukan;
  final String? fotoUrl;

  TreeTracking({
    required this.id,
    required this.diagnosisId,
    required this.tanggal,
    required this.tingkatKesehatan,
    this.lokasi,
    this.petugas,
    this.catatan,
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