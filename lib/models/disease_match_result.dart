import 'crop_disease.dart';
import 'symptom.dart';

class DiseaseMatchResult {
  final CropDisease disease;
  final int matchedSymptomsCount;
  final int totalDiseaseSymptomsCount;
  final double matchPercentage;
  final List<Symptom> matchedSymptoms;

  DiseaseMatchResult({
    required this.disease,
    required this.matchedSymptomsCount,
    required this.totalDiseaseSymptomsCount,
    required this.matchPercentage,
    required this.matchedSymptoms,
  });
}
