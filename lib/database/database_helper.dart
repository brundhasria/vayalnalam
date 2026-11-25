import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/crop_disease.dart';
import '../models/symptom.dart';
import 'database_importer.dart';

class CropItem {
  final String cropNameEn;
  final String cropNameTa;
  final int diseaseCount;

  CropItem({
    required this.cropNameEn,
    required this.cropNameTa,
    required this.diseaseCount,
  });

  String getName(String lang) => lang == 'ta' ? cropNameTa : cropNameEn;
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  static const String dbName = 'vayalnalam.db';
  static const int dbVersion = 1;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    // Check if database already exists in device directory
    final exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
        // Attempt to copy from assets/database/vayalnalam.db
        final data = await rootBundle.load('assets/database/$dbName');
        final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
      } catch (e) {
        // If asset copy fails or file not found, we create tables fresh and import
        // ignore: avoid_print
        print('Could not copy asset db: $e. Creating fresh db.');
      }
    }

    final db = await openDatabase(
      path,
      version: dbVersion,
      onCreate: _onCreate,
    );

    // Verify records exist
    await _verifyAndSeedData(db);

    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS crop_disease (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        crop_name_en TEXT NOT NULL,
        crop_name_ta TEXT NOT NULL,
        disease_name_en TEXT NOT NULL,
        disease_name_ta TEXT NOT NULL,
        symptoms_en TEXT NOT NULL,
        symptoms_ta TEXT NOT NULL,
        symptoms_source TEXT,
        chemical_pesticide_en TEXT,
        chemical_pesticide_ta TEXT,
        organic_alternative_en TEXT,
        organic_alternative_ta TEXT,
        chemical_fertilizer_en TEXT,
        chemical_fertilizer_ta TEXT,
        biofertilizer_en TEXT,
        biofertilizer_ta TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS crop_symptom (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        disease_id INTEGER NOT NULL,
        crop_name_en TEXT NOT NULL,
        crop_name_ta TEXT NOT NULL,
        symptom_index INTEGER NOT NULL,
        symptom_en TEXT NOT NULL,
        symptom_ta TEXT NOT NULL,
        FOREIGN KEY (disease_id) REFERENCES crop_disease(id)
      )
    ''');
  }

  Future<void> _verifyAndSeedData(Database db) async {
    try {
      // Ensure tables exist
      await _onCreate(db, dbVersion);

      final countResult = await db.rawQuery('SELECT COUNT(*) as count FROM crop_disease');
      final count = Sqflite.firstIntValue(countResult) ?? 0;

      if (count < 83) {
        await DatabaseImporter.importFromJson(db);
      }
    } catch (e) {
      // In case of any schema mismatch, reimport cleanly
      await _onCreate(db, dbVersion);
      await DatabaseImporter.importFromJson(db);
    }
  }

  Future<List<CropItem>> getAllCrops() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT crop_name_en, crop_name_ta, COUNT(*) as disease_count
      FROM crop_disease
      GROUP BY crop_name_en, crop_name_ta
      ORDER BY crop_name_en ASC
    ''');

    return maps.map((m) {
      return CropItem(
        cropNameEn: m['crop_name_en'] as String,
        cropNameTa: m['crop_name_ta'] as String,
        diseaseCount: (m['disease_count'] as int?) ?? 0,
      );
    }).toList();
  }

  Future<List<CropDisease>> getDiseasesForCrop(String cropNameEn) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'crop_disease',
      where: 'crop_name_en = ?',
      whereArgs: [cropNameEn],
      orderBy: 'disease_name_en ASC',
    );

    return maps.map((m) => CropDisease.fromMap(m)).toList();
  }

  Future<List<Symptom>> getSymptomsForCrop(String cropNameEn) async {
    final db = await database;
    // Retrieve distinct symptoms for the crop
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT MIN(id) as id, disease_id, crop_name_en, crop_name_ta,
             symptom_index, symptom_en, symptom_ta
      FROM crop_symptom
      WHERE crop_name_en = ?
      GROUP BY symptom_en
      ORDER BY symptom_index ASC, id ASC
    ''', [cropNameEn]);

    return maps.map((m) => Symptom.fromMap(m)).toList();
  }

  Future<List<Symptom>> getSymptomsForDisease(int diseaseId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'crop_symptom',
      where: 'disease_id = ?',
      whereArgs: [diseaseId],
      orderBy: 'symptom_index ASC',
    );

    return maps.map((m) => Symptom.fromMap(m)).toList();
  }

  Future<CropDisease?> getDiseaseById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'crop_disease',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return CropDisease.fromMap(maps.first);
    }
    return null;
  }
}
