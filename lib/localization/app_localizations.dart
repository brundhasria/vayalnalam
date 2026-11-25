import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'app_name': 'VayalNalam',
      'app_tagline': 'Sustainable Agriculture & Crop Health Advisory',
      'theme_sub': 'Future Directions in Biofertilizers – Organic Replacement for Chemical Ones',
      'get_started': 'Get Started',
      'select_language': 'Select Language',
      'english': 'English',
      'tamil': 'தமிழ்',
      'select_crop': 'Select Your Crop',
      'select_crop_hint': 'Choose the crop you are cultivating',
      'search_crop': 'Search crop by name...',
      'no_crops_found': 'No matching crops found',
      'diseases_recorded': 'diseases recorded',
      'select_symptoms': 'Select Observed Symptoms',
      'select_symptoms_sub': 'Select the symptoms you observe on your crop. Multiple selections allowed.',
      'clear_all': 'Clear All',
      'selected_count': 'selected',
      'identify_disease': 'Identify Possible Diseases',
      'please_select_symptom': 'Please select at least one symptom to continue.',
      'no_symptoms_for_crop': 'No symptoms available for this crop.',
      'possible_diseases': 'Possible Diseases',
      'results_for': 'Results for',
      'match': 'Match',
      'matched_symptoms': 'Matched Symptoms',
      'out_of': 'out of',
      'view_recommendations': 'View Organic Recommendations',
      'no_match_found': 'No matching disease found',
      'no_match_desc': 'The symptoms you selected did not match known disease patterns sufficiently. Please review your observed symptoms and try again.',
      'review_symptoms': 'Review Symptoms',
      'disclaimer': 'Advisory Note: Symptom matching provides advisory guidance based on observed signs. It is not a laboratory diagnosis.',
      'disease_details': 'Disease Details & Recommendations',
      'crop_label': 'Crop',
      'disease_label': 'Possible Disease',
      'symptoms_label': 'Recorded Symptoms',
      'organic_pesticide_title': 'Organic / Biopesticide Alternative (TNAU IPM)',
      'organic_pesticide_desc': 'Approved organic and biocontrol alternative to replace chemical pesticides.',
      'biofertilizer_title': 'Biofertilizer Alternative (TNAU)',
      'biofertilizer_desc': 'Crop nutrition and soil health support. Enhances natural immunity and nutrient availability.',
      'chemical_ref_pesticide': 'Chemical Pesticide (For Reference Only)',
      'chemical_ref_fertilizer': 'Chemical Fertilizer (For Reference Only)',
      'info_not_available': 'Information not available',
      'source_ref': 'TNAU Agritech Portal Reference',
      'open_source': 'Open Official Page',
      'settings': 'Settings',
      'change_language': 'Change Language',
      'soil_health_note': 'Biofertilizers provide soil health and nutrient enhancement, supporting natural plant resilience.',
    },
    'ta': {
      'app_name': 'வயல் நலம்',
      'app_tagline': 'இயற்கை வேளாண்மை மற்றும் பயிர் பாதுகாப்பு வழிகாட்டி',
      'theme_sub': 'நிலையான விவசாயத்திற்கான உயிரி உரங்கள் – இரசாயன உரங்களுக்கு மாற்றாக இயற்கை தீர்வு',
      'get_started': 'தொடங்குங்கள்',
      'select_language': 'மொழியைத் தேர்ந்தெடுக்கவும்',
      'english': 'English',
      'tamil': 'தமிழ்',
      'select_crop': 'உங்கள் பயிரைத் தேர்ந்தெடுக்கவும்',
      'select_crop_hint': 'நீங்கள் பயிரிடும் பயிரைத் தேர்வு செய்யவும்',
      'search_crop': 'பயிரின் பெயரைத் தேடுங்கள்...',
      'no_crops_found': 'பொருந்தும் பயிர்கள் எதுவும் கிடைக்கவில்லை',
      'diseases_recorded': 'பதிவு செய்யப்பட்ட நோய்கள்',
      'select_symptoms': 'கண்டறிந்த அறிகுறிகளைத் தேர்ந்தெடுக்கவும்',
      'select_symptoms_sub': 'பயிரில் நீங்கள் காணும் அறிகுறிகளைத் தேர்வு செய்யவும். ஒன்றுக்கு மேற்பட்ட அறிகுறிகளையும் தேர்வு செய்யலாம்.',
      'clear_all': 'அனைத்தையும் நீக்கு',
      'selected_count': 'தேர்வு செய்யப்பட்டுள்ளது',
      'identify_disease': 'சாத்தியமான நோய்களைக் கண்டறியவும்',
      'please_select_symptom': 'தொடர குறைந்தபட்சம் ஒரு அறிகுறியைத் தேர்ந்தெடுக்கவும்.',
      'no_symptoms_for_crop': 'இந்தப் பயிருக்கு அறிகுறிகள் எதுவும் கிடைக்கவில்லை.',
      'possible_diseases': 'சாத்தியமான நோய்கள்',
      'results_for': 'முடிவுகள்',
      'match': 'பொருத்தம்',
      'matched_symptoms': 'பொருந்திய அறிகுறிகள்',
      'out_of': '/',
      'view_recommendations': 'இயற்கை பரிந்துரைகளைக் காண்க',
      'no_match_found': 'பொருந்தும் நோய் எதுவும் கண்டறியப்படவில்லை',
      'no_match_desc': 'நீங்கள் தேர்வு செய்த அறிகுறிகள் எந்த நோயுடனும் போதுமான அளவு பொருந்தவில்லை. தயவுசெய்து அறிகுறிகளை மீண்டும் சரிபார்த்து முயற்சிக்கவும்.',
      'review_symptoms': 'அறிகுறிகளை மறுபரிசீலனை செய்க',
      'disclaimer': 'வழிகாட்டல் குறிப்பு: அறிகுறிகளின் அடிப்படையில் சாத்தியமான நோய்கள் வழிகாட்டலாகவே காட்டப்படுகின்றன. இது ஆய்வக உறுதிப்படுத்தல் அல்ல.',
      'disease_details': 'நோய் விவரம் மற்றும் பரிந்துரைகள்',
      'crop_label': 'பயிர்',
      'disease_label': 'சாத்தியமான நோய்',
      'symptoms_label': 'அங்கீகரிக்கப்பட்ட அறிகுறிகள்',
      'organic_pesticide_title': 'இயற்கை / உயிரி மாற்று மருந்து (TNAU IPM)',
      'organic_pesticide_desc': 'இரசாயன பூச்சிக்கொல்லிகளுக்கு மாற்றான அங்கீகரிக்கப்பட்ட இயற்கை மற்றும் உயிரியல் கட்டுப்பாடு.',
      'biofertilizer_title': 'உயிரி உர மாற்று (TNAU)',
      'biofertilizer_desc': 'பயிர் ஊட்டச்சத்து மற்றும் மண் வள மேம்பாடு. பயிரின் இயற்கை நோய் எதிர்ப்பு சக்தியையும் சத்து உறிஞ்சுதலையும் அதிகரிக்கும்.',
      'chemical_ref_pesticide': 'இரசாயன பூச்சிக்கொல்லி (குறிப்புக்கு மட்டும்)',
      'chemical_ref_fertilizer': 'இரசாயன உரம் (குறிப்புக்கு மட்டும்)',
      'info_not_available': 'தகவல் கிடைக்கவில்லை',
      'source_ref': 'TNAU வேளாண் தகவல் மையம்',
      'open_source': 'அதிகாரப்பூர்வ பக்கத்தைப் பார்',
      'settings': 'அமைப்புகள்',
      'change_language': 'மொழியை மாற்றவும்',
      'soil_health_note': 'உயிரி உரங்கள் மண்ணின் வளத்தையும் ஊட்டச்சத்தையும் பெருக்கி, பயிரின் ஆரோக்கியத்தை இயற்கையாகக் காக்கின்றன.',
    },
  };

  String get(String key) {
    final langCode = locale.languageCode == 'ta' ? 'ta' : 'en';
    return _localizedValues[langCode]?[key] ?? _localizedValues['en']?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ta'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
