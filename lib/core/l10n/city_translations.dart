/// Localized city names for major airports.
/// Maps English city name → {locale: localizedName}.
const Map<String, Map<String, String>> cityTranslations = {
  // German cities
  'Munich': {'de': 'München', 'fr': 'Munich'},
  'Cologne': {'de': 'Köln', 'fr': 'Cologne'},
  'Nuremberg': {'de': 'Nürnberg', 'fr': 'Nuremberg'},
  'Dusseldorf': {'de': 'Düsseldorf', 'fr': 'Düsseldorf'},
  'Hanover': {'de': 'Hannover', 'fr': 'Hanovre'},
  'Vienna': {'de': 'Wien', 'fr': 'Vienne'},
  'Zurich': {'de': 'Zürich', 'fr': 'Zurich'},
  'Z\u00fcrich': {'de': 'Zürich', 'fr': 'Zurich'},
  'Geneva': {'de': 'Genf', 'fr': 'Genève'},
  'Berne': {'de': 'Bern', 'fr': 'Berne'},
  'Brussels': {'de': 'Brüssel', 'fr': 'Bruxelles'},
  'Copenhagen': {'de': 'Kopenhagen', 'fr': 'Copenhague'},
  'Prague': {'de': 'Prag', 'fr': 'Prague'},
  'Warsaw': {'de': 'Warschau', 'fr': 'Varsovie'},
  'Budapest': {'de': 'Budapest', 'fr': 'Budapest'},
  'Bucharest': {'de': 'Bukarest', 'fr': 'Bucarest'},
  'Athens': {'de': 'Athen', 'fr': 'Athènes'},
  'Lisbon': {'de': 'Lissabon', 'fr': 'Lisbonne'},
  'Moscow': {'de': 'Moskau', 'fr': 'Moscou'},

  // French cities (DE localization)
  'Paris': {'de': 'Paris', 'fr': 'Paris'},
  'Nice': {'de': 'Nizza', 'fr': 'Nice'},
  'Marseille': {'de': 'Marseille', 'fr': 'Marseille'},
  'Lyon': {'de': 'Lyon', 'fr': 'Lyon'},
  'Strasbourg': {'de': 'Straßburg', 'fr': 'Strasbourg'},
  'Bordeaux': {'de': 'Bordeaux', 'fr': 'Bordeaux'},
  'Toulouse': {'de': 'Toulouse', 'fr': 'Toulouse'},

  // Italian cities
  'Rome': {'de': 'Rom', 'fr': 'Rome'},
  'Milan': {'de': 'Mailand', 'fr': 'Milan'},
  'Venice': {'de': 'Venedig', 'fr': 'Venise'},
  'Florence': {'de': 'Florenz', 'fr': 'Florence'},
  'Naples': {'de': 'Neapel', 'fr': 'Naples'},
  'Genoa': {'de': 'Genua', 'fr': 'Gênes'},
  'Turin': {'de': 'Turin', 'fr': 'Turin'},

  // Spanish cities
  'Seville': {'de': 'Sevilla', 'fr': 'Séville'},
  'Majorca': {'de': 'Mallorca', 'fr': 'Majorque'},

  // UK / Americas
  'London': {'de': 'London', 'fr': 'Londres'},
  'Edinburgh': {'de': 'Edinburgh', 'fr': 'Édimbourg'},
  'New York': {'de': 'New York', 'fr': 'New York'},

  // Middle East / Africa
  'Cairo': {'de': 'Kairo', 'fr': 'Le Caire'},
  'Algiers': {'de': 'Algier', 'fr': 'Alger'},
  'Tunis': {'de': 'Tunis', 'fr': 'Tunis'},
  'Casablanca': {'de': 'Casablanca', 'fr': 'Casablanca'},
  'Marrakech': {'de': 'Marrakesch', 'fr': 'Marrakech'},
  'Jeddah': {'de': 'Dschidda', 'fr': 'Djeddah'},
  'Riyadh': {'de': 'Riad', 'fr': 'Riyad'},

  // Asia
  'Beijing': {'de': 'Peking', 'fr': 'Pékin'},
  'Tokyo': {'de': 'Tokio', 'fr': 'Tokyo'},
  'Seoul': {'de': 'Seoul', 'fr': 'Séoul'},
  'Bangkok': {'de': 'Bangkok', 'fr': 'Bangkok'},
  'Delhi': {'de': 'Delhi', 'fr': 'Delhi'},
  'Singapore': {'de': 'Singapur', 'fr': 'Singapour'},
};

/// Returns the localized city name for the given locale.
/// Falls back to the original name if no translation exists.
String localizeCity(String city, String locale) {
  final translations = cityTranslations[city];
  if (translations == null) return city;
  return translations[locale] ?? city;
}
