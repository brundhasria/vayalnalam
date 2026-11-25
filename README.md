# VayalNalam (வயல் நலம்)

**Agricultural Advisory Mobile Application for Sustainable Crop Protection & Biofertilizers**

> **Theme:** Future Directions in Biofertilizers for Sustainable Agriculture – An Organic Replacement for Chemical Ones.

---

## 🌾 Overview

**VayalNalam (வயல் நலம்)** is an offline-first Android mobile application built with Flutter and Dart, specifically designed for small and marginal farmers in Tamil Nadu.

Farmers frequently observe crop disease symptoms (spots, wilting, discoloration) in their fields without knowing the exact technical or pathological disease names. VayalNalam solves this by eliminating the need to type disease names:
1. **Select Crop** from 33 approved Tamil Nadu crops.
2. **Select Observed Symptoms** using clear checkboxes.
3. **View Possible Matching Diseases** ranked with matching percentages.
4. **Access Verified Organic / Biopesticide Alternatives (TNAU IPM)**.
5. **Access Biofertilizer Alternatives (TNAU)** for soil health and crop nutrition.

---

## 🚀 Key Features

- **100% Offline Capability:** Operates entirely without internet access using a local pre-populated SQLite database.
- **Bilingual Interface (English & தமிழ்):** Seamless instant language switching with persistent preference storage via `shared_preferences`.
- **Approved TNAU Agricultural Dataset:** Backed by the official Madurai Agricultural Crop-Disease-Pesticide-Fertilizer dataset (83 disease records, 321 mapped symptoms across 33 crops).
- **Symptom-Matching Algorithm:** Compares observed signs against pathological records and computes match percentages.
- **Organic First:** Prioritizes organic biocontrol (e.g., *Pseudomonas fluorescens*, *Trichoderma viride*, neem oil) and biofertilizers (*Azospirillum*, *Phosphobacteria*), presenting chemical products only as background reference.
- **Material 3 Design:** Farmer-friendly, high-contrast, clean green aesthetic with large touch targets and proper Tamil font rendering.

---

## 📱 Application Workflow

```
Splash Screen (VayalNalam / வயல் நலம்)
  ↓
Home Screen (Language Selector English / தமிழ், Theme Intro)
  ↓
Crop Selection (Search & Select from 33 Crops)
  ↓
Symptom Selection (Multi-select observed symptoms, Select All / Clear All)
  ↓
Possible Disease Results (Ranked matches, confidence score, advisory disclaimer)
  ↓
Disease Details & Recommendations (Organic biopesticides, biofertilizers & soil health support)
```

---

## 🛠️ Technology Stack

- **Framework:** Flutter 3.50+ (Channel stable)
- **Language:** Dart 3.14+
- **Local Database:** SQLite via `sqflite`
- **Preferences:** `shared_preferences`
- **UI Architecture:** Flutter Material 3
- **Platform:** Android (Min SDK 21, Target SDK 35)

---

## 📂 Project Structure

```
lib/
├── main.dart                      # Entry point & system UI setup
├── app.dart                       # MaterialApp & bilingual localization setup
├── models/
│   ├── crop_disease.dart          # Crop disease data model
│   ├── symptom.dart               # Individual symptom model
│   └── disease_match_result.dart  # Matching score & result model
├── database/
│   ├── database_helper.dart       # SQLite database manager & queries
│   └── database_importer.dart     # JSON asset importer & verification
├── services/
│   ├── crop_service.dart          # Crop filtering & search
│   ├── symptom_service.dart       # Symptom retrieval
│   ├── disease_matching_service.dart # Symptom matching algorithm
│   └── recommendation_service.dart   # Advisory recommendations
├── screens/
│   ├── splash_screen.dart         # Animated splash screen
│   ├── home_screen.dart           # Home screen & language toggle
│   ├── crop_selection_screen.dart # Crop search & selection
│   ├── symptom_selection_screen.dart # Checkbox symptom selection
│   ├── disease_results_screen.dart   # Ranked possible diseases
│   ├── disease_details_screen.dart   # Organic recommendations
│   └── settings_screen.dart       # Settings & dataset info
├── widgets/
│   ├── crop_card.dart             # Crop list item card
│   ├── symptom_card.dart          # Checkbox symptom card
│   └── recommendation_card.dart   # Styled recommendation cards
├── localization/
│   └── app_localizations.dart     # English & Tamil translations
└── utils/
    ├── app_theme.dart             # Material 3 agricultural theme
    └── constants.dart             # App constants
assets/
└── database/
    ├── vayalnalam.db              # Pre-populated SQLite database
    └── vayalnalam_dataset.json    # Dataset backup & seeding asset
test/
├── matching_and_dataset_test.dart # Dataset integrity & matching tests
└── widget_test.dart               # Widget smoke tests
```

---

## 🧪 Testing

Run automated tests:
```bash
flutter test
```
*All 9 unit and widget tests pass, verifying dataset completeness, bilingual queries, and matching algorithms.*

---

## 📦 Building the APK

### Debug APK:
```bash
flutter build apk --debug
```
Output: `build/app/outputs/flutter-apk/app-debug.apk`

### Release APK:
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`
