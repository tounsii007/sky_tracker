import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sky_tracker/core/constants/settings_provider.dart';
import 'package:sky_tracker/core/l10n/strings_base.dart';
import 'package:sky_tracker/core/l10n/ui_text.dart';
import 'package:sky_tracker/core/widgets/glass_panel.dart';
import 'package:sky_tracker/features/settings/presentation/widgets/settings_tiles.dart';

class MapOptionsSection extends ConsumerWidget {
  final bool isDark;
  final Color primary;
  final AppStrings s;

  const MapOptionsSection({
    super.key,
    required this.isDark,
    required this.primary,
    required this.s,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsSectionTitle(s.mapOptions, isDark),
        const SizedBox(height: 8),
        GlassPanel(
          borderRadius: 14,
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              SettingsToggleTile(
                title: context.tr('aircraft_trails'),
                subtitle: context.tr('flight_path'),
                icon: Icons.timeline_rounded,
                value: settings.showAircraftTrails,
                color: primary,
                isDark: isDark,
                onChanged: (v) => ref
                    .read(settingsProvider.notifier)
                    .update((cur) => cur.copyWith(showAircraftTrails: v)),
              ),
              SettingsDivider(isDark),
              SettingsToggleTile(
                title: context.tr('aircraft_labels'),
                subtitle: context.tr('callsign_label'),
                icon: Icons.label_rounded,
                value: settings.showAircraftLabels,
                color: primary,
                isDark: isDark,
                onChanged: (v) => ref
                    .read(settingsProvider.notifier)
                    .update((cur) => cur.copyWith(showAircraftLabels: v)),
              ),
              SettingsDivider(isDark),
              SettingsToggleTile(
                title: context.tr('airport_labels'),
                subtitle: context.tr('iata_codes'),
                icon: Icons.location_city_rounded,
                value: settings.showAirportLabels,
                color: primary,
                isDark: isDark,
                onChanged: (v) => ref
                    .read(settingsProvider.notifier)
                    .update((cur) => cur.copyWith(showAirportLabels: v)),
              ),
              SettingsDivider(isDark),
              SettingsToggleTile(
                title: context.tr('density_heatmap'),
                subtitle: context.tr('overlay'),
                icon: Icons.blur_on_rounded,
                value: settings.showHeatmap,
                color: primary,
                isDark: isDark,
                onChanged: (v) => ref
                    .read(settingsProvider.notifier)
                    .update((cur) => cur.copyWith(showHeatmap: v)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
