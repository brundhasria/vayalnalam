import '../database/database_helper.dart';

class CropService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<CropItem>> getAllCrops() async {
    return await _dbHelper.getAllCrops();
  }

  List<CropItem> filterCrops(List<CropItem> crops, String query, String lang) {
    if (query.trim().isEmpty) return crops;
    final lowerQuery = query.trim().toLowerCase();

    return crops.where((crop) {
      final nameEn = crop.cropNameEn.toLowerCase();
      final nameTa = crop.cropNameTa.toLowerCase();
      return nameEn.contains(lowerQuery) || nameTa.contains(lowerQuery);
    }).toList();
  }
}
