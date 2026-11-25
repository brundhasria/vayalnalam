class Symptom {
  final int? id;
  final int diseaseId;
  final String cropNameEn;
  final String cropNameTa;
  final int symptomIndex;
  final String symptomEn;
  final String symptomTa;

  Symptom({
    this.id,
    required this.diseaseId,
    required this.cropNameEn,
    required this.cropNameTa,
    required this.symptomIndex,
    required this.symptomEn,
    required this.symptomTa,
  });

  factory Symptom.fromMap(Map<String, dynamic> map) {
    return Symptom(
      id: map['id'] as int?,
      diseaseId: (map['disease_id'] ?? 0) as int,
      cropNameEn: (map['crop_name_en'] ?? '') as String,
      cropNameTa: (map['crop_name_ta'] ?? '') as String,
      symptomIndex: (map['symptom_index'] ?? 0) as int,
      symptomEn: (map['symptom_en'] ?? '') as String,
      symptomTa: (map['symptom_ta'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'disease_id': diseaseId,
      'crop_name_en': cropNameEn,
      'crop_name_ta': cropNameTa,
      'symptom_index': symptomIndex,
      'symptom_en': symptomEn,
      'symptom_ta': symptomTa,
    };
  }

  String getText(String lang) => lang == 'ta' ? symptomTa : symptomEn;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Symptom &&
          runtimeType == other.runtimeType &&
          symptomEn == other.symptomEn;

  @override
  int get hashCode => symptomEn.hashCode;
}
