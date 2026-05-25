# Changelog

All notable changes to AirWatch (sky_tracker) are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Full project README replacing the default Flutter template
- CONTRIBUTING.md with branch naming, commit conventions, and PR checklist
- CHANGELOG.md tracking releases

### Changed
- `analysis_options.yaml` hardened with stricter lint rules (unawaited_futures,
  use_build_context_synchronously, always_declare_return_types, cancel_subscriptions,
  close_sinks, prefer_const_*, and more)
- Generated files (*.g.dart, *.freezed.dart) excluded from analysis

## [2.0.0] - 2026

### Added
- Real-time flight tracking for 7,000+ aircraft worldwide
- Interactive radar-style map with marker clustering and animations
- Flight detail screen with airline, aircraft, gate, terminal, delay info
- Airport detail screen with live weather and departure/arrival boards
- Smart search with autocomplete (flight number, airline, registration)
- 7-day flight history with delay analysis
- Favorites for flights, airlines, and airports
- Dark, light, and satellite map themes
- Configurable units (feet/meters, knots/km/h/mph)
- Localization in English, German, and French
- AR mode using camera + sensors to identify aircraft overhead
- Home screen widgets for quick flight status
- Local notifications for tracked flights
- Global error handlers preventing crashes from unhandled exceptions
