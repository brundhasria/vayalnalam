import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/app_localizations.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  final Function(Locale) onLanguageChanged;

  const SettingsScreen({super.key, required this.onLanguageChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _currentLang = 'en';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentLang = Localizations.localeOf(context).languageCode;
  }

  Future<void> _changeLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefLanguageKey, langCode);
    setState(() {
      _currentLang = langCode;
    });
    widget.onLanguageChanged(Locale(langCode));
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(loc.get('settings')),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // Language Card
          Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 16),
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
                      const Icon(Icons.language_rounded, color: AppColors.primary, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        loc.get('change_language'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  RadioListTile<String>(
                    title: const Text('English', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('English interface & recommendations'),
                    value: 'en',
                    groupValue: _currentLang,
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      if (val != null) _changeLanguage(val);
                    },
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  RadioListTile<String>(
                    title: const Text('தமிழ் (Tamil)', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('தமிழ் இடைமுகம் மற்றும் இயற்கை பரிந்துரைகள்'),
                    value: 'ta',
                    groupValue: _currentLang,
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      if (val != null) _changeLanguage(val);
                    },
                  ),
                ],
              ),
            ),
          ),

          // About Card
          Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.border, width: 1.2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.spa_rounded, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'VayalNalam (வயல் நலம்)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _currentLang == 'ta'
                        ? 'வயல் நலம் என்பது தமிழ்நாட்டு சிறு மற்றும் குறு விவசாயிகளுக்காக உருவாக்கப்பட்ட எளிய வேளாண் ஆலோசனை செயலியாகும். பயிரில் காணப்படும் அறிகுறிகளைத் தேர்ந்தெடுப்பதன் மூலம் நோய்களைக் கண்டறிந்து, இரசாயனங்களுக்கு மாற்றான இயற்கை உயிரி மருந்துகள் மற்றும் உயிரி உரப் பரிந்துரைகளை வழங்குகிறது.'
                        : 'VayalNalam is a dedicated agricultural advisory mobile application designed for farmers in Tamil Nadu. It enables crop disease identification based on visible symptoms without requiring technical disease names, and recommends verified TNAU organic biopesticide and biofertilizer alternatives to replace chemical inputs.',
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    label: _currentLang == 'ta' ? 'அங்கீகரிக்கப்பட்ட தரவுதளம்' : 'Approved Dataset',
                    value: 'TNAU Madurai Agricultural Dataset v4',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    label: _currentLang == 'ta' ? 'செயல்பாடு' : 'Operation',
                    value: '100% Offline (Local SQLite)',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    label: _currentLang == 'ta' ? 'பதிப்பு' : 'Version',
                    value: '1.0.0 (Android)',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
