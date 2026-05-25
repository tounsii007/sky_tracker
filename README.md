# AirWatch — Sky Tracker

> Real-time flight tracking with a radar-inspired UI. Track thousands of aircraft worldwide on an interactive map with live aviation data.

[![CI](https://github.com/tounsii007/sky_tracker/actions/workflows/ci.yml/badge.svg)](https://github.com/tounsii007/sky_tracker/actions/workflows/ci.yml)
[![Flutter](https://img.shields.io/badge/Flutter-3.41+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart)](https://dart.dev)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20Android%20%7C%20Web-blue)](https://flutter.dev)

---

## Features

- **Live Flight Tracking** — 7,000+ aircraft worldwide in real time, with route, altitude, speed, and heading.
- **Detailed Flight Info** — airline, flight number, aircraft type, gates, terminals, baggage, delay times.
- **Smart Search** — by flight number, airline, or registration with autocomplete and category filters.
- **Airports Map** — 150+ major airports with live weather, departures, and arrivals.
- **7-Day Flight History** — performance tracking and delay analysis across multiple data sources.
- **Personalization** — favorite flights/airlines/airports, dark/light/satellite themes, configurable units.
- **AR Mode** — point your camera at the sky to identify aircraft overhead.
- **i18n** — English, German, French.
- **Home Widgets** — quick-glance flight status on your home screen.

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.41, Dart 3.11 |
| State | Riverpod 3 (with code-gen) |
| Network | dio, web_socket_channel |
| Map | flutter_map 8, marker clustering, animations |
| UI | Material 3, glassmorphism, flutter_animate, shimmer |
| Models | freezed, json_serializable, equatable |
| Camera/AR | camera, sensors_plus |
| Storage | shared_preferences |
| Localization | flutter_localizations + intl |

## Project Structure

```
lib/
├── main.dart              # Entry point + global error handlers
├── app.dart               # Root widget (theme, routing, locale)
├── core/                  # Shared infrastructure (api, models, theme, l10n)
└── features/              # Feature-first modules
    ├── radar/             # Live map + aircraft layer
    ├── flight_detail/     # Flight info screen
    ├── airport/           # Airport detail + weather + boards
    ├── search/            # Search & autocomplete
    ├── history/           # 7-day flight history
    ├── favorites/         # Saved flights/airlines/airports
    ├── ar/                # AR aircraft spotter
    └── settings/          # Theme, units, language
```

## Getting Started

### Prerequisites

- Flutter SDK 3.41.5+
- Dart SDK 3.11.3+
- Android Studio / Xcode for device builds

### Run

```bash
flutter pub get
flutter run                 # default device
flutter run -d chrome       # web
flutter run -d macos        # macOS desktop (if supported)
```

### Build

```bash
flutter build apk --release         # Android APK
flutter build appbundle --release   # Android Play Store
flutter build ios --release         # iOS
flutter build web --release         # Web
```

### Code Generation

Run after editing freezed/Riverpod annotations:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Testing

```bash
flutter analyze
flutter test                    # all
flutter test test/unit/         # unit
flutter test test/widget/       # widget
flutter test integration_test/  # integration
```

CI runs on every push and PR to `main` — analyze, unit tests, and builds for Web, Android APK, and iOS.

## Data Coverage

- 6,244 airlines worldwide
- 20,845 airports worldwide
- Multiple aviation data sources cross-referenced for accuracy

## Roadmap

- [ ] Push notifications for tracked flights
- [ ] Apple Watch / Wear OS companions
- [ ] Offline mode with cached recent flights
- [ ] CarPlay / Android Auto
- [ ] Additional locales (ES, IT, PT, AR)

## Contributing

Pull requests are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md) for the workflow and style guide.

## Security

Found a security issue? Please review [SECURITY.md](SECURITY.md) and report privately.

## License

Proprietary software. All rights reserved.
© 2026 Ridha Abderrahmen
