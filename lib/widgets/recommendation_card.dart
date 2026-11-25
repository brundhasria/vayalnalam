import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

enum RecommendationType {
  organicPesticide,
  biofertilizer,
  chemicalPesticideRef,
  chemicalFertilizerRef,
}

class RecommendationCard extends StatelessWidget {
  final RecommendationType type;
  final String title;
  final String subtitle;
  final String content;
  final String fallbackText;

  const RecommendationCard({
    super.key,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.fallbackText,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = content.trim().isNotEmpty;
    final displayContent = isAvailable ? content.trim() : fallbackText;

    Color headerBg;
    Color headerBorder;
    Color iconColor;
    IconData icon;
    String badgeText;

    switch (type) {
      case RecommendationType.organicPesticide:
        headerBg = const Color(0xFFE8F5E9);
        headerBorder = const Color(0xFFA5D6A7);
        iconColor = AppColors.primary;
        icon = Icons.spa_rounded;
        badgeText = 'ORGANIC ALTERNATIVE';
        break;
      case RecommendationType.biofertilizer:
        headerBg = const Color(0xFFE3F2FD);
        headerBorder = const Color(0xFF90CAF9);
        iconColor = const Color(0xFF1565C0);
        icon = Icons.grass_rounded;
        badgeText = 'SOIL HEALTH & NUTRITION';
        break;
      case RecommendationType.chemicalPesticideRef:
      case RecommendationType.chemicalFertilizerRef:
        headerBg = const Color(0xFFF5F5F5);
        headerBorder = const Color(0xFFE0E0E0);
        iconColor = const Color(0xFF757575);
        icon = Icons.science_outlined;
        badgeText = 'CHEMICAL REFERENCE';
        break;
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: headerBorder, width: 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: headerBg,
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        badgeText,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: iconColor,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subtitle.isNotEmpty) ...[
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                SelectableText(
                  displayContent,
                  style: TextStyle(
                    fontSize: 14.5,
                    height: 1.5,
                    color: isAvailable ? AppColors.textPrimary : AppColors.textMuted,
                    fontWeight: isAvailable ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
