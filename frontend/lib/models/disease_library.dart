class RubberTreeDisease {
  final int id;
  final String name;
  final String? description;
  final String? causes;
  final String? symptoms;
  final String? treatment;
  final String? prevention;
  final String? severity;
  final String? spreadPotential;
  final List<String> imageUrls;
  final List<String> affectedParts;

  RubberTreeDisease({
    required this.id,
    required this.name,
    this.description,
    this.causes,
    this.symptoms,
    this.treatment,
    this.prevention,
    this.severity,
    this.spreadPotential,
    required this.imageUrls,
    required this.affectedParts,
  });

  factory RubberTreeDisease.fromJson(Map<String, dynamic> json) {
    return RubberTreeDisease(
      id: json['id'],
      name: json['nama'] ?? 'Tidak diketahui',
      description: json['deskripsi'],
      causes: json['penyebab'],
      symptoms: json['gejala'],
      treatment: json['pengobatan'],
      prevention: json['pencegahan'],
      severity: json['tingkat_keparahan'],
      spreadPotential: json['spread_potential'],
      imageUrls:
          json['image_urls'] != null
              ? List<String>.from(json['image_urls'])
              : [],
      affectedParts:
          json['affected_parts'] != null
              ? List<String>.from(json['affected_parts'])
              : [],
    );
  }
}
