import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sky_tracker/core/constants/settings_provider.dart';
import 'package:sky_tracker/core/l10n/strings_base.dart';
import 'package:sky_tracker/core/l10n/ui_text.dart';
import 'package:sky_tracker/core/widgets/glass_panel.dart';
import 'package:sky_tracker/features/settings/presentation/widgets/settings_tiles.dart';

class MapThemeSection extends ConsumerWidget {
  final bool isDark;
  final Color primary;
  final AppStrings s;

  const MapThemeSection({
    super.key,
    required this.isDark,
    required this.primary,
    required this.s,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    void setTheme(MapTheme theme) => ref
        .read(settingsProvider.notifier)
        .update((current) => current.copyWith(mapTheme: theme));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsSectionTitle(s.mapStyle, isDark),
        const SizedBox(height: 8),
        GlassPanel(
          borderRadius: 14,
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              SettingsRadioTile(
                title: context.tr('dark_radar'),
                subtitle: context.tr('cartodb_dark'),
                icon: Icons.map_rounded,
                selected: settings.mapTheme == MapTheme.darkRadar,
                color: primary,
                isDark: isDark,
                onTap: () => setTheme(MapTheme.darkRadar),
              ),
              SettingsDivider(isDark),
              SettingsRadioTile(
                title: context.tr('light_aviation'),
                subtitle: context.tr('cartodb_light'),
                icon: Icons.map_outlined,
                selected: settings.mapTheme == MapTheme.lightAviation,
                color: primary,
                isDark: isDark,
                onTap: () => setTheme(MapTheme.lightAviation),
              ),
              SettingsDivider(isDark),
              SettingsRadioTile(
                title: context.tr('satellite'),
                subtitle: context.tr('arcgis_imagery'),
                icon: Icons.satellite_alt_rounded,
                selected: settings.mapTheme == MapTheme.satellite,
                color: primary,
                isDark: isDark,
                onTap: () => setTheme(MapTheme.satellite),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
