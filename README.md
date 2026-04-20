# IrisFlow

AI-powered eye health and focus timer application built with Flutter.

## Overview

IrisFlow combines productivity timer functionality with AI-driven eye health monitoring. The app implements the Pomodoro Technique for focus management while actively tracking and analyzing user eye strain patterns to prevent digital eye fatigue.

## Features

### Focus Timer
- Customizable focus and break intervals
- Ready-to-work preparation phase
- Auto-cycle mode for continuous sessions
- Multiple focus presets (Development 20/20, Design Work 50/5, Email & Admin 15/5)
- Visual circular progress indicator

### Eye Strain Analysis
- Real-time eye aspect ratio (EAR) detection using Google ML Kit
- AI-powered fatigue analysis via Google Gemini
- Per-user calibration system
- Adaptive UI that adjusts when strain is detected

### Analytics & Tracking
- Daily focus hours tracking
- Session completion counters
- Streak day monitoring
- Weekly analytics charts

### Customization
- Three dark themes: Sage Green, Ocean Blue, Sunset
- Focus preset management
- User profile configuration

## Technical Architecture

### Tech Stack
- **Frontend**: Flutter (Dart)
- **State Management**: Riverpod
- **Database**: Drift (SQLite)
- **Routing**: GoRouter
- **AI/ML**: Google ML Kit Face Detection, Google Generative AI (Gemini)
- **Notifications**: flutter_local_notifications

### Project Structure
```
lib/
├── app/
│   ├── routes/          # GoRouter configuration
│   └── theme/           # Theme definitions
├── features/
│   ├── home/            # Timer screen
│   ├── analytics/       # Analytics dashboard
│   ├── modes/           # Focus presets
│   ├── profile/        # User profile
│   ├── settings/        # App settings
│   └── eye_strain/     # Eye strain detection
└── shared/
    ├── services/        # Database, notifications
    └── widgets/         # Reusable components
```

### Database Schema
- **AppSettings**: User preferences (durations, alerts, theme)
- **UserProfiles**: User information and eye health score
- **FocusPresets**: Timer configurations
- **FocusStats**: Aggregate statistics
- **AnalyticsEntries**: Daily focus records

## How It Works

### Focus Timer Flow
1. User selects a focus preset (e.g., 25/5 Pomodoro)
2. Optional 10-minute ready phase before focus
3. Focus timer counts down while tracking sessions
4. Break timer activates after focus complete
5. Auto-cycle continues if enabled
6. Statistics update in real-time

### Eye Strain Detection Pipeline
1. **Camera Capture**: On-device camera captures face data
2. **EAR Extraction**: ML Kit calculates Eye Aspect Ratio
3. **Buffer Collection**: 60-second rolling window of blink rate + EAR stability
4. **AI Analysis**: Gemini interprets patterns (focusing vs. fatigue)
5. **Adaptive UI**: Theme adjusts based on strain level

## Running the Project

```bash
# Install dependencies
flutter pub get

# Run development server
flutter run

# Run static analysis
flutter analyze

# Format code
dart format .

# Run tests
flutter test

# Generate Drift database code
flutter pub run build_runner build
```

## Build Targets

```bash
# iOS
flutter build ios

# Android APK
flutter build apk

# macOS
flutter build macos
```

## Future Scope

### Phase 1: Enhanced Eye Tracking
- Implement real-time EAR detection with ML Kit
- Connect Genkit flows for periodic strain analysis
- Build adaptive theme engine that reacts to strain levels

### Phase 2: Advanced Features
- Cloud sync for cross-device data
- Health app integration (Apple Health, Google Fit)
- Widget support for home screen
- Notifications with actionable intents

### Phase 3: AI Improvements
- Personalized break recommendations based on session history
- Predictive fatigue warnings before strain occurs
- Natural language insights about focus patterns

### Phase 4: Platform Expansion
- Wear OS companion app
- Desktop application (macOS/Windows)
- Browser extension for web productivity

## License

This project is proprietary software. All rights reserved.