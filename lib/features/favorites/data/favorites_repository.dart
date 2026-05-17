import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FavoriteType { flight, airline, airport }

class FavoriteItem {
  final String id; // callsign, airline ICAO, or airport ICAO
  final FavoriteType type;
  final String label;
  final String? subtitle;
  final DateTime addedAt;

  FavoriteItem({
    required this.id,
    required this.type,
    required this.label,
    this.subtitle,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.index,
        'label': label,
        'subtitle': subtitle,
        'addedAt': addedAt.toIso8601String(),
      };

  factory FavoriteItem.fromJson(Map<String, dynamic> json) => FavoriteItem(
        id: json['id'] as String,
        type: FavoriteType.values[json['type'] as int],
        label: json['label'] as String,
        subtitle: json['subtitle'] as String?,
        addedAt: DateTime.parse(json['addedAt'] as String),
      );
}

class FavoritesNotifier extends Notifier<List<FavoriteItem>> {
  static const _key = 'favorites_v1';

  @override
  List<FavoriteItem> build() {
    _load();
    return [];
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      final list = (jsonDecode(raw) as List)
          .map((e) => FavoriteItem.fromJson(e as Map<String, dynamic>))
          .toList();
      state = list;
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state.map((e) => e.toJson()).toList()));
  }

  bool isFavorite(String id) => state.any((f) => f.id == id);

  void toggle(FavoriteItem item) {
    if (isFavorite(item.id)) {
      state = state.where((f) => f.id != item.id).toList();
    } else {
      state = [...state, item];
    }
    _save();
  }

  void remove(String id) {
    state = state.where((f) => f.id != id).toList();
    _save();
  }

  List<FavoriteItem> byType(FavoriteType type) =>
      state.where((f) => f.type == type).toList();
}

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, List<FavoriteItem>>(
        FavoritesNotifier.new);
