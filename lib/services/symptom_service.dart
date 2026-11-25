import '../database/database_helper.dart';
import '../models/symptom.dart';

class SymptomService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Symptom>> getSymptomsForCrop(String cropNameEn) async {
    return await _dbHelper.getSymptomsForCrop(cropNameEn);
  }

  Future<List<Symptom>> getSymptomsForDisease(int diseaseId) async {
    return await _dbHelper.getSymptomsForDisease(diseaseId);
  }
}
