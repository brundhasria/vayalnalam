import '../database/database_helper.dart';
import '../models/crop_disease.dart';

class RecommendationService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<CropDisease?> getDiseaseDetails(int diseaseId) async {
    return await _dbHelper.getDiseaseById(diseaseId);
  }
}
