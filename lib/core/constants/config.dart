import 'package:flutter/foundation.dart' show kIsWeb;

/// Centralized configuration — no hardcoded values scattered across the codebase.
class AppConfig {
  // ═══ Proxy / API URLs ═══
  static const int proxyPort = int.fromEnvironment('PROXY_PORT', defaultValue: 8080);
  static const String proxyHost = String.fromEnvironment(
    'PROXY_HOST',
    defaultValue: 'localhost',
  );
  static const String proxyScheme = String.fromEnvironment(
    'PROXY_SCHEME',
    defaultValue: 'http',
  );
  static String get proxyBaseUrl => '$proxyScheme://$proxyHost:$proxyPort';

  /// Base URL for Airlabs API (proxied on web, direct on mobile)
  static String get airlabsUrl =>
      kIsWeb ? '$proxyBaseUrl/airlabs' : 'https://airlabs.co/api/v9';

  /// Base URL for OpenSky API (proxied on web)
  static String get openSkyUrl =>
      kIsWeb ? proxyBaseUrl : 'https://opensky-network.org';

  /// Base URL for hexdb aircraft lookup
  static String get hexdbUrl =>
      kIsWeb ? '$proxyBaseUrl/hexdb' : 'https://hexdb.io/api/v1/aircraft';

  /// Base URL for hexdb airport lookup
  static String get airportLookupUrl =>
      kIsWeb ? '$proxyBaseUrl/airport' : 'https://hexdb.io/api/v1/airport/icao';

  /// Planespotters photo API (always proxied on web for CORS)
  static String get photoApiUrl =>
      kIsWeb ? '$proxyBaseUrl/photo' : 'https://api.planespotters.net/pub/photos/hex';

  /// Weather API (Open-Meteo, free)
  static String weatherUrl(double lat, double lon) =>
      kIsWeb
          ? '$proxyBaseUrl/weather/${lat.toStringAsFixed(2)}/${lon.toStringAsFixed(2)}'
          : 'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon'
              '&current=temperature_2m,relative_humidity_2m,wind_speed_10m,'
              'wind_direction_10m,weather_code,cloud_cover,is_day&timezone=auto';

  /// Image proxy (CORS bypass for planespotters images)
  static String imageProxyUrl(String originalUrl) =>
      kIsWeb ? '$proxyBaseUrl/img/${Uri.encodeComponent(originalUrl)}' : originalUrl;

  /// Planespotters photo API lookup by hex code
  static String photoLookupUrl(String hex) =>
      kIsWeb ? '$proxyBaseUrl/photo/$hex' : '$photoApiUrl/$hex';

  /// Aggregated lookup endpoint
  static String lookupUrl(String icao24, String callsign, String airlineIata) =>
      '$proxyBaseUrl/lookup?icao24=$icao24&callsign=$callsign&airline_iata=$airlineIata';

  /// Airlabs flight details URL
  static String flightUrl({String? flightIcao, String? flightIata}) {
    final query = flightIcao != null && flightIcao.isNotEmpty
        ? 'flight_icao=$flightIcao'
        : 'flight_iata=${flightIata ?? ""}';
    return '$airlabsUrl/flight?$query';
  }

  /// Airlabs routes URL
  static String routesUrl({String? flightIcao, String? flightIata}) {
    final query = flightIcao != null && flightIcao.isNotEmpty
        ? 'flight_icao=$flightIcao'
        : 'flight_iata=${flightIata ?? ""}';
    return '$airlabsUrl/routes?$query';
  }

  /// Airlabs flights URL
  static String flightsUrl([String query = '']) =>
      query.isEmpty ? '$airlabsUrl/flights' : '$airlabsUrl/flights?$query';

  /// Airport details URL
  static String airportUrl(String iataCode) =>
      '$airlabsUrl/airports?iata_code=$iataCode';

  /// Airport schedules URL (by airport IATA)
  static String schedulesUrl(String iataCode, {bool departures = true}) =>
      '$airlabsUrl/schedules?${departures ? "dep_iata" : "arr_iata"}=$iataCode';

  /// Flight schedule lookup by flight number.
  /// Returns today's schedule for a specific flight (works for landed flights too).
  /// NOTE: Free Plan limited to 50 results per call, 1000 calls/month total.
  /// Upgrade to Starter (9.90 USD) for 10,000 calls or Developer (49 USD) for 25,000.
  static String scheduleByFlightUrl({String? flightIcao, String? flightIata}) {
    if (flightIata != null && flightIata.isNotEmpty) {
      return '$airlabsUrl/schedules?flight_iata=$flightIata';
    }
    return '$airlabsUrl/schedules?flight_icao=${flightIcao ?? ''}';
  }

  /// Airline schedule lookup — all flights for an airline today.
  /// NOTE: Free Plan limited to 50 results. Paid plans return up to 200.
  static String scheduleByAirlineUrl({String? airlineIcao, String? airlineIata}) {
    if (airlineIata != null && airlineIata.isNotEmpty) {
      return '$airlabsUrl/schedules?airline_iata=$airlineIata';
    }
    return '$airlabsUrl/schedules?airline_icao=${airlineIcao ?? ''}';
  }

  // ═══ Tile Map URLs ═══
  static const String darkTileUrl =
      'https://basemaps.cartocdn.com/dark_all/{z}/{x}/{y}@2x.png';
  static const String lightTileUrl =
      'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}@2x.png';
  static const String satelliteTileUrl =
      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

  /// Airline logo URL
  static String airlineLogoUrl(String iataCode) =>
      'https://pics.avs.io/200/80/${iataCode.toUpperCase()}.png';

  // ═══ Timeouts ═══
  static const Duration apiTimeout = Duration(seconds: 15);
  static const Duration shortTimeout = Duration(seconds: 5);
  static const Duration longTimeout = Duration(seconds: 30);

  // ═══ Update Intervals ═══
  static const Duration flightUpdateInterval = Duration(minutes: 5);
  static const Duration historySearchDelay = Duration(milliseconds: 150);
  static const Duration searchDebounce = Duration(milliseconds: 300);

  // ═══ Cache ═══
  static const Duration staleCacheThreshold = Duration(seconds: 180);
  static const int maxTrailPoints = 50;

  // ═══ Map Defaults ═══
  static const double defaultLat = 48.5;  // Central Europe
  static const double defaultLon = 9.0;
  static const double defaultZoom = 5.5;
  static const double minZoom = 2.0;
  static const double maxZoom = 18.0;

  // ═══ UI Constants ═══
  static const double panelBorderRadius = 20.0;
  static const double cardBorderRadius = 14.0;
  static const double buttonBorderRadius = 22.0;
  static const double glassBlur = 14.0;
  static const double glassOpacity = 0.22;

  // ═══ Font Families ═══
  static const String fontHeading = 'Orbitron';
  static const String fontBody = 'Rajdhani';

  // ═══ Light Theme Colors (used alongside AppColors for light mode) ═══
  static const int lightPrimary = 0xFF4A6B8A;
  static const int lightBackground = 0xFFF0F4F8;
  static const int lightSurface = 0xFFFFFFFF;
  static const int lightText = 0xFF1A1A2E;
  static const int lightTextSecondary = 0xFF6B7280;
  static const int lightTextMuted = 0xFF9CA3AF;
  static const int lightBorder = 0xFFE2E8F0;

  // ═══ Altitude Thresholds (feet) ═══
  static const double altitudeLowMax = 10000;
  static const double altitudeMedMax = 30000;
  static const double altitudeGroundMax = 100;

  // ═══ Aircraft Colors ═══
  static const int groundColor = 0xFF6B7280;
  static const int selectedColor = 0xFFE0F0FF;

  // ═══ Airport Marker Colors ═══
  static const int airportDotColor = 0xFF4A90D9;

  // ═══ Map Clustering ═══
  static const double clusterZoomThreshold = 5.0;
  static const int clusterMinCount = 500;
  static const int maxVisibleMarkers = 800;
  static const double maxMarkersSamplingZoom = 7.0;
  static const int maxMarkersSamplingTarget = 600;
  static const double viewportMarginBase = 20.0;
  static const double viewportMarginMin = 0.5;
  static const double viewportMarginMax = 5.0;
  static const double clusterCellSizeBase = 8.0;
  static const double clusterCellSizeMin = 1.0;
  static const double clusterCellSizeMax = 6.0;
  static const int clusterSmallThreshold = 3;

  // ═══ Marker Sizing ═══
  static const double markerZoomScaleDivisor = 6.0;
  static const double markerZoomScaleMin = 0.6;
  static const double markerZoomScaleMax = 2.0;
  static const double selectedMarkerSize = 48.0;
  static const double markerSizeMin = 14.0;
  static const double markerSizeMax = 40.0;
  static const double selectedMarkerOverflowWidth = 100.0;
  static const double selectedMarkerExtraHeight = 30.0;
  static const Map<int, double> categoryMarkerSizes = {
    6: 34.0, 5: 32.0, 4: 30.0, 7: 28.0, 3: 24.0,
    8: 22.0, 2: 18.0, 9: 16.0, 10: 14.0, 14: 14.0,
  };
  static const double categoryMarkerSizeDefault = 26.0;

  // ═══ Marker Animation ═══
  static const Duration markerPulseDuration = Duration(milliseconds: 1500);
  static const double markerPulseScale = 0.15;
  static const double markerOverflowMaxHeight = 80.0;
  static const double markerOverflowMaxWidth = 100.0;

  // ═══ Panel Layout ═══
  static const double panelMaxHeightRatio = 0.65;
  static const double panelTopOffset = 56.0;
  static const double panelGlassBlurDark = 15.0;
  static const double panelGlassOpacityDark = 0.25;
  static const double panelGlassOpacityLight = 0.92;

  // ═══ BorderRadius ═══
  static const double chipBorderRadius = 8.0;
  static const double tagBorderRadius = 6.0;
  static const double inputBorderRadius = 12.0;
  static const double tileBorderRadius = 10.0;
  static const double filterChipBorderRadius = 20.0;

  // ═══ Aircraft Categories ═══
  static const int categoryNoInfo = 0;
  static const int categoryLight = 1;
  static const int categorySmall = 2;
  static const int categoryLarge = 3;
  static const int categoryHighVortex = 4;
  static const int categoryHeavy = 5;
  static const int categoryHighPerf = 6;
  static const int categoryRotorcraft = 7;
  static const int categoryHelicopter = 8;
  static const int categorySurface = 9;

  // ═══ Trail Settings ═══
  static const double trailWidth = 2.0;

  // ═══ Animation Durations ═══
  static const Duration markerAnimDuration = Duration(milliseconds: 800);
  static const Duration panelAnimDuration = Duration(milliseconds: 400);
  static const Duration radarSweepDuration = Duration(seconds: 4);

  // ═══ Search ═══
  static const int maxSearchResults = 50;
}
