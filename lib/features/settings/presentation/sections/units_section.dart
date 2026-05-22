import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sky_tracker/core/constants/settings_provider.dart';
import 'package:sky_tracker/core/l10n/strings_base.dart';
import 'package:sky_tracker/core/l10n/ui_text.dart';
import 'package:sky_tracker/core/widgets/glass_panel.dart';
import 'package:sky_tracker/features/settings/presentation/widgets/settings_tiles.dart';

class UnitsSection extends ConsumerWidget {
  final bool isDark;
  final Color primary;
  final AppStrings s;

  const UnitsSection({
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
        SettingsSectionTitle(s.units, isDark),
        const SizedBox(height: 8),
        GlassPanel(
          borderRadius: 14,
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              SettingsSegmentedRow(
                title: context.tr('altitude_short'),
                icon: Icons.height_rounded,
                options: [context.tr('feet'), context.tr('meters')],
                selectedIndex: settings.altitudeUnit.index,
                color: primary,
                isDark: isDark,
                onSelected: (i) => ref
                    .read(settingsProvider.notifier)
                    .update((cur) => cur.copyWith(altitudeUnit: AltitudeUnit.values[i])),
              ),
              SettingsDivider(isDark),
              SettingsSegmentedRow(
                title: context.tr('speed_short'),
                icon: Icons.speed_rounded,
                options: [context.tr('knots'), 'km/h', 'mph'],
                selectedIndex: settings.speedUnit.index,
                color: primary,
                isDark: isDark,
                onSelected: (i) => ref
                    .read(settingsProvider.notifier)
                    .update((cur) => cur.copyWith(speedUnit: SpeedUnit.values[i])),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
