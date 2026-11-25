import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseImporter {
  static const String datasetAssetPath = 'assets/database/vayalnalam_dataset.json';

  static Future<void> importFromJson(Database db) async {
    try {
      final jsonString = await rootBundle.loadString(datasetAssetPath);
      final Map<String, dynamic> data = jsonDecode(jsonString);

      final List<dynamic> diseaseList = data['crop_diseases'] ?? [];
      final List<dynamic> symptomList = data['crop_symptoms'] ?? [];

      await db.transaction((txn) async {
        // Clear if any
        await txn.delete('crop_symptom');
        await txn.delete('crop_disease');

        final batch = txn.batch();

        for (final item in diseaseList) {
          batch.insert('crop_disease', {
            'id': item['id'],
            'crop_name_en': item['crop_name_en'],
            'crop_name_ta': item['crop_name_ta'],
            'disease_name_en': item['disease_name_en'],
            'disease_name_ta': item['disease_name_ta'],
            'symptoms_en': item['symptoms_en'],
            'symptoms_ta': item['symptoms_ta'],
            'symptoms_source': item['symptoms_source'],
            'chemical_pesticide_en': item['chemical_pesticide_en'],
            'chemical_pesticide_ta': item['chemical_pesticide_ta'],
            'organic_alternative_en': item['organic_alternative_en'],
            'organic_alternative_ta': item['organic_alternative_ta'],
            'chemical_fertilizer_en': item['chemical_fertilizer_en'],
            'chemical_fertilizer_ta': item['chemical_fertilizer_ta'],
            'biofertilizer_en': item['biofertilizer_en'],
            'biofertilizer_ta': item['biofertilizer_ta'],
          });
        }

        for (final item in symptomList) {
          batch.insert('crop_symptom', {
            'id': item['id'],
            'disease_id': item['disease_id'],
            'crop_name_en': item['crop_name_en'],
            'crop_name_ta': item['crop_name_ta'],
            'symptom_index': item['symptom_index'],
            'symptom_en': item['symptom_en'],
            'symptom_ta': item['symptom_ta'],
          });
        }

        await batch.commit(noResult: true);
      });
    } catch (e) {
      // Graceful error logging
      // ignore: avoid_print
      print('DatabaseImporter error: $e');
      rethrow;
    }
  }
}
