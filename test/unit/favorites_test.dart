import 'package:flutter_test/flutter_test.dart';
import 'package:sky_tracker/features/favorites/data/favorites_repository.dart';

void main() {
  group('FavoriteItem', () {
    test('toJson and fromJson roundtrip', () {
      final item = FavoriteItem(
        id: 'DLH123',
        type: FavoriteType.flight,
        label: 'DLH123',
        subtitle: 'Lufthansa',
      );

      final json = item.toJson();
      final restored = FavoriteItem.fromJson(json);

      expect(restored.id, 'DLH123');
      expect(restored.type, FavoriteType.flight);
      expect(restored.label, 'DLH123');
      expect(restored.subtitle, 'Lufthansa');
    });

    test('FavoriteType enum values', () {
      expect(FavoriteType.values.length, 3);
      expect(FavoriteType.flight.index, 0);
      expect(FavoriteType.airline.index, 1);
      expect(FavoriteType.airport.index, 2);
    });

    test('addedAt defaults to now', () {
      final item = FavoriteItem(id: 'test', type: FavoriteType.flight, label: 'test');
      expect(item.addedAt.difference(DateTime.now()).inSeconds.abs(), lessThan(2));
    });
  });
}
