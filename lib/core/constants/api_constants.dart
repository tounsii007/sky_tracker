class ApiConstants {
  // OpenSky Network API
  static const String openSkyBaseUrl = 'https://opensky-network.org/api';
  static const String openSkyStatesAll = '$openSkyBaseUrl/states/all';
  static const String openSkyFlightsAll = '$openSkyBaseUrl/flights/all';
  static const String openSkyFlightsByAircraft = '$openSkyBaseUrl/flights/aircraft';
  static const String openSkyTrack = '$openSkyBaseUrl/tracks/all';

  // AviationStack API
  static const String aviationStackBaseUrl = 'http://api.aviationstack.com/v1';
  static const String aviationStackFlights = '$aviationStackBaseUrl/flights';
  static const String aviationStackAirports = '$aviationStackBaseUrl/airports';
  static const String aviationStackAirlines = '$aviationStackBaseUrl/airlines';

  // Update intervals
  static const int realtimeUpdateIntervalMs = 5000;
  static const int positionInterpolationMs = 1000;
  static const int trailRetentionSeconds = 60;
  static const int maxAircraftOnScreen = 20000;

  // Map defaults
  static const double defaultLatitude = 48.8566;
  static const double defaultLongitude = 2.3522;
  static const double defaultZoom = 5.0;
  static const double minZoom = 2.0;
  static const double maxZoom = 18.0;

  // Clustering
  static const int clusterMaxZoom = 10;
  static const int clusterRadius = 80;
}
