import 'dart:io';

void main() {
  final file = File(r'C:\projects\sky_tracker\lib\core\constants\airline_database.dart');
  final content = file.readAsStringSync();
  final regex = RegExp(r"'([A-Z0-9]{3})': AirlineInfo\(icao: '[^']*', iata: '([^']*)', name: '([^']*)', country: '([^']*)'\)");
  final matches = regex.allMatches(content);
  var total = 0;
  var withIata = 0;
  var differentCode = 0;
  final samples = <String>[];
  for (final m in matches) {
    total++;
    final icao = m.group(1)!;
    final iata = m.group(2)!;
    final name = m.group(3)!;
    final country = m.group(4)!;
    if (iata.isNotEmpty) {
      withIata++;
      if (iata != icao) {
        differentCode++;
        if (samples.length < 40) {
          samples.add('$iata <-> $icao | $name | $country');
        }
      }
    }
  }
  print('total=$total');
  print('with_iata=$withIata');
  print('different_iata_vs_icao=$differentCode');
  print('samples:');
  for (final s in samples) {
    print(s);
  }
}
