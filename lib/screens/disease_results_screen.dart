import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../localization/app_localizations.dart';
import '../models/disease_match_result.dart';
import '../models/symptom.dart';
import '../services/disease_matching_service.dart';
import '../utils/app_theme.dart';
import 'disease_details_screen.dart';

class DiseaseResultsScreen extends StatefulWidget {
  final CropItem crop;
  final List<Symptom> selectedSymptoms;
  final String language;

  const DiseaseResultsScreen({
    super.key,
    required this.crop,
    required this.selectedSymptoms,
    required this.language,
  });

  @override
  State<DiseaseResultsScreen> createState() => _DiseaseResultsScreenState();
}

class _DiseaseResultsScreenState extends State<DiseaseResultsScreen> {
  final DiseaseMatchingService _matchingService = DiseaseMatchingService();

  List<DiseaseMatchResult> _results = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _matchDiseases();
  }

  Future<void> _matchDiseases() async {
    setState(() => _isLoading = true);
    final results = await _matchingService.matchDiseases(
      cropNameEn: widget.crop.cropNameEn,
      selectedSymptoms: widget.selectedSymptoms,
    );

    if (mounted) {
      setState(() {
        _results = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final cropName = widget.crop.getName(widget.language);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(loc.get('possible_diseases')),
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _results.isEmpty
              ? _buildNoMatchState(loc)
              : _buildResultsList(loc, cropName),
    );
  }

  Widget _buildNoMatchState(AppLocalizations loc) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFFCC80)),
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 54,
                color: Color(0xFFE65100),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              loc.get('no_match_found'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              loc.get('no_match_desc'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded, size: 20),
              label: Text(loc.get('review_symptoms')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(AppLocalizations loc, String cropName) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 28),
      itemCount: _results.length + 1, // +1 for header & advisory note
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${loc.get('results_for')}: ',
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      cropName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_results.length} ${widget.language == 'ta' ? 'முடிவுகள்' : 'matches'}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Advisory note
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8E9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFDCEDC8)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.primaryDark,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          loc.get('disclaimer'),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF33691E),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        final matchResult = _results[index - 1];
        final disease = matchResult.disease;
        final diseaseName = disease.getDiseaseName(widget.language);
        final score = matchResult.matchPercentage.round();

        // Color coding based on match score
        Color scoreColor = AppColors.primary;
        Color scoreBg = AppColors.primaryLight;
        if (score < 50) {
          scoreColor = const Color(0xFFE65100);
          scoreBg = const Color(0xFFFFF3E0);
        } else if (score < 75) {
          scoreColor = const Color(0xFFF57F17);
          scoreBg = const Color(0xFFFFFDE7);
        }

        return Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border, width: 1.2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Possible Disease Label & Score Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F4F1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              loc.get('disease_label').toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            diseaseName,
                            style: const TextStyle(
                              fontSize: 17.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (widget.language == 'ta')
                            Text(
                              disease.diseaseNameEn,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: scoreBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: scoreColor.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$score%',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: scoreColor,
                            ),
                          ),
                          Text(
                            loc.get('match'),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: scoreColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Divider(height: 24, color: AppColors.border),

                // Matched Symptoms count & list
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${loc.get('matched_symptoms')}: ${matchResult.matchedSymptomsCount} ${loc.get('out_of')} ${matchResult.totalDiseaseSymptomsCount}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Preview of matched symptoms
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: matchResult.matchedSymptoms.take(2).map((s) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4.0, left: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Text(
                              s.getText(widget.language),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textSecondary,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 14),

                // Button to view details & recommendations
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    foregroundColor: AppColors.primaryDark,
                    elevation: 0,
                    side: const BorderSide(color: AppColors.primary, width: 1.2),
                    minimumSize: const Size(double.infinity, 46),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DiseaseDetailsScreen(
                          disease: disease,
                          language: widget.language,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.eco_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        loc.get('view_recommendations'),
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
