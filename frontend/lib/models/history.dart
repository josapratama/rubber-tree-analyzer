class History {
  final int id;
  final int diagnosisId;
  final String? lokasi;
  final DateTime waktu;
  final String? petugas;
  final String? catatan;
  final String? tindakanLanjutan;
  final String? statusPenanganan;
  final String? fotoUrl;
  final bool isResolved;

  History({
    required this.id,
    required this.diagnosisId,
    this.lokasi,
    required this.waktu,
    this.petugas,
    this.catatan,
    this.tindakanLanjutan,
    this.statusPenanganan,
    this.fotoUrl,
    required this.isResolved,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'],
      diagnosisId: json['diagnosis_id'],
      lokasi: json['lokasi'],
      waktu: DateTime.parse(json['waktu']),
      petugas: json['petugas'],
      catatan: json['catatan'],
      tindakanLanjutan: json['tindakan_lanjutan'],
      statusPenanganan: json['status_penanganan'],
      fotoUrl: json['foto_url'],
      isResolved: json['is_resolved'],
    );
  }
}