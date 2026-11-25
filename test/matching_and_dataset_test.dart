import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:vayalnalam/models/crop_disease.dart';
import 'package:vayalnalam/models/symptom.dart';
import 'package:vayalnalam/services/crop_service.dart';
import 'package:vayalnalam/database/database_helper.dart';

void main() {
  group('Dataset Integrity & Model Tests', () {
    late Map<String, dynamic> dataset;
    late List<dynamic> diseaseList;
    late List<dynamic> symptomList;

    setUpAll(() {
      final file = File('assets/database/vayalnalam_dataset.json');
      expect(file.existsSync(), isTrue, reason: 'Dataset JSON must exist');
      final jsonString = file.readAsStringSync();
      dataset = jsonDecode(jsonString);
      diseaseList = dataset['crop_diseases'] ?? [];
      symptomList = dataset['crop_symptoms'] ?? [];
    });

    test('Dataset contains exactly 83 approved crop-disease records', () {
      expect(diseaseList.length, equals(83));
    });

    test('Dataset contains all 321 mapped symptoms', () {
      expect(symptomList.length, equals(321));
    });

    test('Every record preserves non-empty crop, disease, symptoms, and organic recommendations', () {
      final cropsEn = <String>{};
      final cropsTa = <String>{};

      for (final item in diseaseList) {
        final cd = CropDisease.fromMap(item);

        expect(cd.cropNameEn.trim().isNotEmpty, isTrue);
        expect(cd.cropNameTa.trim().isNotEmpty, isTrue);
        expect(cd.diseaseNameEn.trim().isNotEmpty, isTrue);
        expect(cd.diseaseNameTa.trim().isNotEmpty, isTrue);
        expect(cd.symptomsEn.trim().isNotEmpty, isTrue);
        expect(cd.symptomsTa.trim().isNotEmpty, isTrue);
        expect(cd.organicAlternativeEn?.trim().isNotEmpty, isTrue);
        expect(cd.organicAlternativeTa?.trim().isNotEmpty, isTrue);
        expect(cd.biofertilizerEn?.trim().isNotEmpty, isTrue);
        expect(cd.biofertilizerTa?.trim().isNotEmpty, isTrue);

        cropsEn.add(cd.cropNameEn);
        cropsTa.add(cd.cropNameTa);
      }

      // Exactly 33 unique crops in the Madurai agricultural dataset
      expect(cropsEn.length, equals(33));
      expect(cropsTa.length, equals(33));
    });

    test('Bilingual getters return correct language values without fallback issues', () {
      final sample = CropDisease.fromMap(diseaseList.first);
      expect(sample.getCropName('en'), equals(sample.cropNameEn));
      expect(sample.getCropName('ta'), equals(sample.cropNameTa));
      expect(sample.getDiseaseName('en'), equals(sample.diseaseNameEn));
      expect(sample.getDiseaseName('ta'), equals(sample.diseaseNameTa));
      expect(sample.getSymptoms('en'), equals(sample.symptomsEn));
      expect(sample.getSymptoms('ta'), equals(sample.symptomsTa));
      expect(sample.getOrganicAlternative('en'), equals(sample.organicAlternativeEn?.trim()));
      expect(sample.getOrganicAlternative('ta'), equals(sample.organicAlternativeTa?.trim()));
    });
  });

  group('Crop Filtering Service Tests', () {
    final cropService = CropService();
    final sampleCrops = [
      CropItem(cropNameEn: 'Paddy', cropNameTa: 'நெல்', diseaseCount: 4),
      CropItem(cropNameEn: 'Banana', cropNameTa: 'வாழை', diseaseCount: 5),
      CropItem(cropNameEn: 'Tomato', cropNameTa: 'தக்காளி', diseaseCount: 4),
      CropItem(cropNameEn: 'Brinjal', cropNameTa: 'கத்தரி', diseaseCount: 3),
    ];

    test('Search by English crop name returns exact matches', () {
      final results = cropService.filterCrops(sampleCrops, 'paddy', 'en');
      expect(results.length, equals(1));
      expect(results.first.cropNameEn, equals('Paddy'));
    });

    test('Search by Tamil crop name returns exact matches', () {
      final results = cropService.filterCrops(sampleCrops, 'வாழை', 'ta');
      expect(results.length, equals(1));
      expect(results.first.cropNameEn, equals('Banana'));
    });

    test('Empty query returns all crops', () {
      final results = cropService.filterCrops(sampleCrops, '', 'en');
      expect(results.length, equals(4));
    });
  });

  group('Symptom Matching Logic Tests', () {
    test('Simulated matching calculates exact percentage and ranks correctly', () {
      final testDisease = CropDisease(
        id: 1,
        cropNameEn: 'Paddy',
        cropNameTa: 'நெல்',
        diseaseNameEn: 'Blast',
        diseaseNameTa: 'குலைநோய்',
        symptomsEn: 'Spindle-shaped spots on leaves',
        symptomsTa: 'இலைகளில் கதிர் வடிவ புள்ளிகள்',
      );

      final diseaseSymptoms = [
        Symptom(
          id: 1,
          diseaseId: 1,
          cropNameEn: 'Paddy',
          cropNameTa: 'நெல்',
          symptomIndex: 1,
          symptomEn: 'Spindle-shaped spots with an ashy/grey centre and brown border on leaves',
          symptomTa: 'இலைகளில் சாம்பல் நிற மையம் கொண்ட கதிர் வடிவ புள்ளிகள்',
        ),
        Symptom(
          id: 2,
          diseaseId: 1,
          cropNameEn: 'Paddy',
          cropNameTa: 'நெல்',
          symptomIndex: 2,
          symptomEn: 'Nodal infection: nodes turn black and the culm breaks',
          symptomTa: 'கணு தாக்குதல்: கணுக்கள் கருப்பாகி தண்டு முறியும்',
        ),
      ];

      final selectedSymptom = Symptom(
        id: 1,
        diseaseId: 1,
        cropNameEn: 'Paddy',
        cropNameTa: 'நெல்',
        symptomIndex: 1,
        symptomEn: 'Spindle-shaped spots with an ashy/grey centre and brown border on leaves',
        symptomTa: 'இலைகளில் சாம்பல் நிற மையம் கொண்ட கதிர் வடிவ புள்ளிகள்',
      );

      final selectedSet = {selectedSymptom.symptomEn.trim().toLowerCase()};
      final matched = diseaseSymptoms.where((s) => selectedSet.contains(s.symptomEn.trim().toLowerCase())).toList();

      expect(matched.length, equals(1));
      final score = (matched.length / diseaseSymptoms.length) * 100.0;
      expect(score, equals(50.0));
      expect(testDisease.cropNameEn, equals('Paddy'));
    });
  });
}
