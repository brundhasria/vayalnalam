import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../localization/app_localizations.dart';
import '../models/symptom.dart';
import '../services/symptom_service.dart';
import '../utils/app_theme.dart';
import '../widgets/symptom_card.dart';
import 'disease_results_screen.dart';

class SymptomSelectionScreen extends StatefulWidget {
  final CropItem crop;
  final String language;

  const SymptomSelectionScreen({
    super.key,
    required this.crop,
    required this.language,
  });

  @override
  State<SymptomSelectionScreen> createState() => _SymptomSelectionScreenState();
}

class _SymptomSelectionScreenState extends State<SymptomSelectionScreen> {
  final SymptomService _symptomService = SymptomService();

  List<Symptom> _symptoms = [];
  final Set<Symptom> _selectedSymptoms = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSymptoms();
  }

  Future<void> _loadSymptoms() async {
    setState(() => _isLoading = true);
    final symptoms = await _symptomService.getSymptomsForCrop(widget.crop.cropNameEn);
    if (mounted) {
      setState(() {
        _symptoms = symptoms;
        _isLoading = false;
      });
    }
  }

  void _toggleSymptom(Symptom symptom, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedSymptoms.add(symptom);
      } else {
        _selectedSymptoms.remove(symptom);
      }
    });
  }

  void _clearAll() {
    setState(() {
      _selectedSymptoms.clear();
    });
  }

  void _selectAll() {
    setState(() {
      _selectedSymptoms.addAll(_symptoms);
    });
  }

  void _onContinue() {
    final loc = AppLocalizations.of(context);
    if (_selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.get('please_select_symptom')),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DiseaseResultsScreen(
          crop: widget.crop,
          selectedSymptoms: _selectedSymptoms.toList(),
          language: widget.language,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final cropName = widget.crop.getName(widget.language);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(loc.get('select_symptoms')),
        backgroundColor: Colors.white,
        actions: [
          if (_selectedSymptoms.isNotEmpty)
            TextButton(
              onPressed: _clearAll,
              child: Text(
                loc.get('clear_all'),
                style: const TextStyle(
                  color: AppColors.warning,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Crop Header Card
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.eco, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cropName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        loc.get('select_symptoms_sub'),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Count & Action Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F2),
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _selectedSymptoms.isNotEmpty
                            ? AppColors.primary
                            : AppColors.textMuted,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_selectedSymptoms.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${loc.get('selected_count')} / ${_symptoms.length}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                if (_symptoms.isNotEmpty)
                  InkWell(
                    onTap: _selectedSymptoms.length == _symptoms.length ? _clearAll : _selectAll,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Text(
                        _selectedSymptoms.length == _symptoms.length
                            ? loc.get('clear_all')
                            : (widget.language == 'ta' ? 'அனைத்தும் தேர்வு' : 'Select All'),
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Symptoms List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _symptoms.isEmpty
                    ? Center(
                        child: Text(
                          loc.get('no_symptoms_for_crop'),
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 90),
                        itemCount: _symptoms.length,
                        itemBuilder: (context, index) {
                          final symptom = _symptoms[index];
                          final isSelected = _selectedSymptoms.contains(symptom);
                          return SymptomCard(
                            symptom: symptom,
                            displayIndex: index + 1,
                            language: widget.language,
                            isSelected: isSelected,
                            onChanged: (val) {
                              _toggleSymptom(symptom, val ?? false);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),

      // Bottom Sticky Button Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _onContinue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  loc.get('identify_disease'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
