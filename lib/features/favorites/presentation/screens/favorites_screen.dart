import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/l10n/ui_text.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';
import 'package:sky_tracker/core/widgets/glass_panel.dart';
import 'package:sky_tracker/core/widgets/neon_text.dart';
import 'package:sky_tracker/features/favorites/data/favorites_repository.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  final Function(String callsign)? onFlightTap;
  const FavoritesScreen({super.key, this.onFlightTap});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  // Snapshot of favorites when screen was entered — items stay visible
  // until user leaves the screen, even if unfavorited
  List<FavoriteItem> _snapshot = [];
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primary : UiConstants.lightPrimary;
    final liveFavorites = ref.watch(favoritesProvider);

    // Take snapshot on first build or when new items are added
    if (!_initialized || liveFavorites.length > _snapshot.length) {
      _snapshot = List.from(liveFavorites);
      _initialized = true;
    }

    // Show snapshot items (keeps removed ones visible)
    final flights = _snapshot.where((f) => f.type == FavoriteType.flight).toList();
    final airlines = _snapshot.where((f) => f.type == FavoriteType.airline).toList();
    final airports = _snapshot.where((f) => f.type == FavoriteType.airport).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : UiConstants.lightBackground,
      body: SafeArea(
        child: _snapshot.isEmpty
            ? _emptyState(isDark, primary)
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  NeonText(text: context.tr('favorites'), fontSize: UiConstants.searchHeaderFontSize, color: primary,
                      glowRadius: isDark ? 10 : 0),
                  const SizedBox(height: 16),

                  // Stats (show LIVE count, not snapshot)
                  Row(children: [
                    _CountChip(count: liveFavorites.where((f) => f.type == FavoriteType.flight).length,
                        label: context.tr('flights_count'), icon: Icons.flight_rounded, color: primary, isDark: isDark),
                    const SizedBox(width: 8),
                    _CountChip(count: liveFavorites.where((f) => f.type == FavoriteType.airline).length,
                        label: context.tr('airlines_count'), icon: Icons.airlines_rounded, color: AppColors.accent, isDark: isDark),
                    const SizedBox(width: 8),
                    _CountChip(count: liveFavorites.where((f) => f.type == FavoriteType.airport).length,
                        label: context.tr('airports_count'), icon: Icons.location_city_rounded, color: AppColors.success, isDark: isDark),
                  ]),
                  const SizedBox(height: 20),

                  if (flights.isNotEmpty) ...[
                    _SectionTitle(title: context.tr('flights_upper'), isDark: isDark),
                    const SizedBox(height: 8),
                    ...flights.map((f) {
                      final isFav = ref.watch(favoritesProvider).any((fav) => fav.id == f.id);
                      return _FavoriteTile(
                        item: f, isDark: isDark, primary: primary,
                        icon: Icons.flight_rounded, color: primary,
                        isFavorite: isFav,
                        onTap: () => widget.onFlightTap?.call(f.id),
                        onToggle: () {
                          ref.read(favoritesProvider.notifier).toggle(f);
                          // Don't remove from snapshot — stays visible
                        },
                      );
                    }),
                    const SizedBox(height: 16),
                  ],

                  if (airlines.isNotEmpty) ...[
                    _SectionTitle(title: context.tr('airlines'), isDark: isDark),
                    const SizedBox(height: 8),
                    ...airlines.map((f) {
                      final isFav = ref.watch(favoritesProvider).any((fav) => fav.id == f.id);
                      return _FavoriteTile(
                        item: f, isDark: isDark, primary: primary,
                        icon: Icons.airlines_rounded, color: AppColors.accent,
                        isFavorite: isFav,
                        onToggle: () => ref.read(favoritesProvider.notifier).toggle(f),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],

                  if (airports.isNotEmpty) ...[
                    _SectionTitle(title: context.tr('airports_upper'), isDark: isDark),
                    const SizedBox(height: 8),
                    ...airports.map((f) {
                      final isFav = ref.watch(favoritesProvider).any((fav) => fav.id == f.id);
                      return _FavoriteTile(
                        item: f, isDark: isDark, primary: primary,
                        icon: Icons.location_city_rounded, color: AppColors.success,
                        isFavorite: isFav,
                        onToggle: () => ref.read(favoritesProvider.notifier).toggle(f),
                      );
                    }),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _emptyState(bool isDark, Color primary) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_border_rounded, size: 64,
              color: isDark ? AppColors.textMuted : UiConstants.lightDisabled),
          const SizedBox(height: 16),
          NeonText(text: context.s.noFavorites, fontSize: 16, color: primary,
              glowRadius: isDark ? 6 : 0),
          const SizedBox(height: 8),
          Text(context.tr('no_favorites_help'),
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: UiConstants.bodyFont, fontSize: 14,
                color: isDark ? AppColors.textSecondary : UiConstants.lightTextSecondary),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════ WIDGETS ═══════════════════

class _CountChip extends StatelessWidget {
  final int count; final String label; final IconData icon;
  final Color color; final bool isDark;
  const _CountChip({required this.count, required this.label,
      required this.icon, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassPanel(
        padding: const EdgeInsets.symmetric(vertical: 10), borderRadius: 10,
        child: Column(children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 4),
          Text('$count', style: TextStyle(fontFamily: UiConstants.headingFont, fontSize: 16,
              fontWeight: FontWeight.w700, color: color)),
          Text(label, style: TextStyle(fontFamily: UiConstants.bodyFont, fontSize: 10,
              color: isDark ? AppColors.textMuted : UiConstants.lightTextMuted)),
        ]),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title; final bool isDark;
  const _SectionTitle({required this.title, required this.isDark});
  @override
  Widget build(BuildContext context) => Text(title, style: TextStyle(
      fontFamily: UiConstants.headingFont, fontSize: 11, fontWeight: FontWeight.w700,
      letterSpacing: 2,
      color: isDark ? AppColors.textSecondary : UiConstants.lightTextSecondary));
}

class _FavoriteTile extends StatelessWidget {
  final FavoriteItem item;
  final bool isDark;
  final Color primary;
  final IconData icon;
  final Color color;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback onToggle;

  const _FavoriteTile({required this.item, required this.isDark,
      required this.primary, required this.icon, required this.color,
      required this.isFavorite, this.onTap, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Opacity(
          opacity: isFavorite ? 1.0 : 0.5,
          child: GlassPanel(
            padding: const EdgeInsets.all(12), borderRadius: 12,
            child: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isDark ? 0.15 : 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.label, style: TextStyle(
                      fontFamily: UiConstants.headingFont,
                      fontSize: 12, fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimary : UiConstants.lightTextPrimary)),
                  if (item.subtitle != null)
                    Text(item.subtitle!, style: TextStyle(fontFamily: UiConstants.bodyFont,
                        fontSize: 12, color: isDark ? AppColors.textSecondary : UiConstants.lightTextSecondary)),
                ],
              )),
              // Star toggle — yellow if favorite, grey if removed
              GestureDetector(
                onTap: onToggle,
                child: Icon(
                  isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 24,
                  color: isFavorite ? AppColors.warning : AppColors.textMuted,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
