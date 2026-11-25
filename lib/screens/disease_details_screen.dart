import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../models/crop_disease.dart';
import '../utils/app_theme.dart';
import '../widgets/recommendation_card.dart';

class DiseaseDetailsScreen extends StatefulWidget {
  final CropDisease disease;
  final String language;

  const DiseaseDetailsScreen({
    super.key,
    required this.disease,
    required this.language,
  });

  @override
  State<DiseaseDetailsScreen> createState() => _DiseaseDetailsScreenState();
}

class _DiseaseDetailsScreenState extends State<DiseaseDetailsScreen> {
  bool _showChemicalReference = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final cropName = widget.disease.getCropName(widget.language);
    final diseaseName = widget.disease.getDiseaseName(widget.language);
    final symptoms = widget.disease.getSymptoms(widget.language);
    final organicAlt = widget.disease.getOrganicAlternative(widget.language);
    final biofertilizer = widget.disease.getBiofertilizer(widget.language);
    final chemicalPesticide = widget.disease.getChemicalPesticide(widget.language);
    final chemicalFertilizer = widget.disease.getChemicalFertilizer(widget.language);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(loc.get('disease_details')),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 12, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Overview Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          cropName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.language == 'ta'
                            ? widget.disease.cropNameEn
                            : widget.disease.cropNameTa,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    diseaseName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (widget.language == 'ta')
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        widget.disease.diseaseNameEn,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Symptoms Card
            Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.border, width: 1.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.visibility_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          loc.get('symptoms_label'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SelectableText(
                      symptoms.isNotEmpty ? symptoms : loc.get('info_not_available'),
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Organic / Biopesticide Alternative Card (Primary emphasis)
            RecommendationCard(
              type: RecommendationType.organicPesticide,
              title: loc.get('organic_pesticide_title'),
              subtitle: loc.get('organic_pesticide_desc'),
              content: organicAlt,
              fallbackText: loc.get('info_not_available'),
            ),

            // Biofertilizer Alternative Card (Soil Health & Nutrition)
            RecommendationCard(
              type: RecommendationType.biofertilizer,
              title: loc.get('biofertilizer_title'),
              subtitle: loc.get('biofertilizer_desc'),
              content: biofertilizer,
              fallbackText: loc.get('info_not_available'),
            ),

            // Soil Health Advisory Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.eco_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      loc.get('soil_health_note'),
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.45,
                        color: Color(0xFF14532D),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Chemical Reference Toggle (clearly separate and muted)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _showChemicalReference = !_showChemicalReference;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.science_outlined, color: AppColors.textSecondary, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.language == 'ta'
                              ? 'இரசாயன குறிப்பு விவரங்கள் (ஒப்பீட்டுக்கு)'
                              : 'Chemical Reference Data (For Comparison)',
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Icon(
                        _showChemicalReference ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (_showChemicalReference) ...[
              const SizedBox(height: 6),
              RecommendationCard(
                type: RecommendationType.chemicalPesticideRef,
                title: loc.get('chemical_ref_pesticide'),
                subtitle: widget.language == 'ta'
                    ? 'இரசாயன பூச்சிக்கொல்லிக்கு மாற்றாக மேலே உள்ள இயற்கை மாற்று மருந்தைப் பயன்படுத்தவும்.'
                    : 'Use the organic/biopesticide alternative shown above to replace this chemical input.',
                content: chemicalPesticide,
                fallbackText: loc.get('info_not_available'),
              ),
              RecommendationCard(
                type: RecommendationType.chemicalFertilizerRef,
                title: loc.get('chemical_ref_fertilizer'),
                subtitle: widget.language == 'ta'
                    ? 'இரசாயன உரங்களுக்கு மாற்றாக உயிரி உரங்கள் மற்றும் தொழுவுரங்களைப் பயன்படுத்தவும்.'
                    : 'Use recommended biofertilizers and farmyard manure to replace chemical fertilizers.',
                content: chemicalFertilizer,
                fallbackText: loc.get('info_not_available'),
              ),
            ],

            // Source Reference if present
            if (widget.disease.symptomsSource != null &&
                widget.disease.symptomsSource!.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.link_rounded, color: AppColors.textMuted, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.get('source_ref'),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            widget.disease.symptomsSource!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
