class CropDisease {
  final int? id;
  final String cropNameEn;
  final String cropNameTa;
  final String diseaseNameEn;
  final String diseaseNameTa;
  final String symptomsEn;
  final String symptomsTa;
  final String? symptomsSource;
  final String? chemicalPesticideEn;
  final String? chemicalPesticideTa;
  final String? organicAlternativeEn;
  final String? organicAlternativeTa;
  final String? chemicalFertilizerEn;
  final String? chemicalFertilizerTa;
  final String? biofertilizerEn;
  final String? biofertilizerTa;

  CropDisease({
    this.id,
    required this.cropNameEn,
    required this.cropNameTa,
    required this.diseaseNameEn,
    required this.diseaseNameTa,
    required this.symptomsEn,
    required this.symptomsTa,
    this.symptomsSource,
    this.chemicalPesticideEn,
    this.chemicalPesticideTa,
    this.organicAlternativeEn,
    this.organicAlternativeTa,
    this.chemicalFertilizerEn,
    this.chemicalFertilizerTa,
    this.biofertilizerEn,
    this.biofertilizerTa,
  });

  factory CropDisease.fromMap(Map<String, dynamic> map) {
    return CropDisease(
      id: map['id'] as int?,
      cropNameEn: (map['crop_name_en'] ?? '') as String,
      cropNameTa: (map['crop_name_ta'] ?? '') as String,
      diseaseNameEn: (map['disease_name_en'] ?? '') as String,
      diseaseNameTa: (map['disease_name_ta'] ?? '') as String,
      symptomsEn: (map['symptoms_en'] ?? '') as String,
      symptomsTa: (map['symptoms_ta'] ?? '') as String,
      symptomsSource: map['symptoms_source'] as String?,
      chemicalPesticideEn: map['chemical_pesticide_en'] as String?,
      chemicalPesticideTa: map['chemical_pesticide_ta'] as String?,
      organicAlternativeEn: map['organic_alternative_en'] as String?,
      organicAlternativeTa: map['organic_alternative_ta'] as String?,
      chemicalFertilizerEn: map['chemical_fertilizer_en'] as String?,
      chemicalFertilizerTa: map['chemical_fertilizer_ta'] as String?,
      biofertilizerEn: map['biofertilizer_en'] as String?,
      biofertilizerTa: map['biofertilizer_ta'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'crop_name_en': cropNameEn,
      'crop_name_ta': cropNameTa,
      'disease_name_en': diseaseNameEn,
      'disease_name_ta': diseaseNameTa,
      'symptoms_en': symptomsEn,
      'symptoms_ta': symptomsTa,
      'symptoms_source': symptomsSource,
      'chemical_pesticide_en': chemicalPesticideEn,
      'chemical_pesticide_ta': chemicalPesticideTa,
      'organic_alternative_en': organicAlternativeEn,
      'organic_alternative_ta': organicAlternativeTa,
      'chemical_fertilizer_en': chemicalFertilizerEn,
      'chemical_fertilizer_ta': chemicalFertilizerTa,
      'biofertilizer_en': biofertilizerEn,
      'biofertilizer_ta': biofertilizerTa,
    };
  }

  String getCropName(String lang) => lang == 'ta' ? cropNameTa : cropNameEn;
  String getDiseaseName(String lang) => lang == 'ta' ? diseaseNameTa : diseaseNameEn;
  String getSymptoms(String lang) => lang == 'ta' ? symptomsTa : symptomsEn;
  String getOrganicAlternative(String lang) {
    final val = lang == 'ta' ? organicAlternativeTa : organicAlternativeEn;
    return (val != null && val.trim().isNotEmpty) ? val.trim() : '';
  }
  String getBiofertilizer(String lang) {
    final val = lang == 'ta' ? biofertilizerTa : biofertilizerEn;
    return (val != null && val.trim().isNotEmpty) ? val.trim() : '';
  }
  String getChemicalPesticide(String lang) {
    final val = lang == 'ta' ? chemicalPesticideTa : chemicalPesticideEn;
    return (val != null && val.trim().isNotEmpty) ? val.trim() : '';
  }
  String getChemicalFertilizer(String lang) {
    final val = lang == 'ta' ? chemicalFertilizerTa : chemicalFertilizerEn;
    return (val != null && val.trim().isNotEmpty) ? val.trim() : '';
  }
}
