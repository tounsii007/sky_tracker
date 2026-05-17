/// Base class defining all translatable strings.
/// Each language implements this with its own translations.
abstract class AppStrings {
  String get appName => 'AirWatch';

  // Navigation
  String get map;
  String get search;
  String get airport;
  String get favs;
  String get settings;

  // Map
  String get live => 'LIVE';
  String get flights;
  String get aircraft;

  // Flight Details
  String get altitude;
  String get speed;
  String get heading;
  String get verticalSpeed => 'V/S';
  String get departure;
  String get arrival;
  String get operatedBy;
  String get track;
  String get replay;
  String get history;
  String get favorite;
  String get share;

  // Status
  String get enRoute;
  String get landed;
  String get scheduled;
  String get delayed;
  String get onTime;
  String get onGround;
  String get airborne;

  // Search
  String get searchHint;
  String get noResults;

  // Settings
  String get appearance;
  String get mapStyle;
  String get units;
  String get mapOptions;
  String get dataSource;
  String get language;

  // Flight History
  String get flightHistory;
  String get searchingDays;

  // Airport
  String get airportRadar;
  String get departures;
  String get arrivals;

  // Splash
  String get tagline;

  // Share
  String get shareText;

  // Favorites
  String get noFavorites;

  // AR
  String get arMode;
  String get pointSkyUp;
}
