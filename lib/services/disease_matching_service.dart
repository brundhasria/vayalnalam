import '../database/database_helper.dart';
import '../models/disease_match_result.dart';
import '../models/symptom.dart';

class DiseaseMatchingService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<DiseaseMatchResult>> matchDiseases({
    required String cropNameEn,
    required List<Symptom> selectedSymptoms,
  }) async {
    if (selectedSymptoms.isEmpty) {
      return [];
    }

    final diseases = await _dbHelper.getDiseasesForCrop(cropNameEn);
    final List<DiseaseMatchResult> results = [];

    // Selected symptom texts normalized for matching
    final selectedEnSet = selectedSymptoms
        .map((s) => s.symptomEn.trim().toLowerCase())
        .toSet();

    for (final disease in diseases) {
      final diseaseSymptoms = await _dbHelper.getSymptomsForDisease(disease.id!);
      final List<Symptom> matched = [];

      for (final ds in diseaseSymptoms) {
        final dsText = ds.symptomEn.trim().toLowerCase();
        if (selectedEnSet.contains(dsText)) {
          matched.add(ds);
        }
      }

      final matchedCount = matched.length;
      final totalCount = diseaseSymptoms.isNotEmpty ? diseaseSymptoms.length : 1;

      if (matchedCount > 0) {
        final matchPercentage = (matchedCount / totalCount) * 100.0;

        results.add(DiseaseMatchResult(
          disease: disease,
          matchedSymptomsCount: matchedCount,
          totalDiseaseSymptomsCount: totalCount,
          matchPercentage: matchPercentage,
          matchedSymptoms: matched,
        ));
      }
    }

    // Sort by matching percentage descending, then matched count descending
    results.sort((a, b) {
      final comp = b.matchPercentage.compareTo(a.matchPercentage);
      if (comp != 0) return comp;
      return b.matchedSymptomsCount.compareTo(a.matchedSymptomsCount);
    });

    return results;
  }
}
