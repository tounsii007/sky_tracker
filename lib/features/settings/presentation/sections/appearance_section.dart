import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/l10n/strings_base.dart';
import 'package:sky_tracker/core/l10n/ui_text.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';
import 'package:sky_tracker/core/theme/theme_provider.dart';
import 'package:sky_tracker/core/widgets/glass_panel.dart';
import 'package:sky_tracker/features/settings/presentation/widgets/settings_tiles.dart';

class AppearanceSection extends ConsumerWidget {
  final bool isDark;
  final AppStrings s;
  const AppearanceSection({super.key, required this.isDark, required this.s});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    void setTheme(AppThemeMode mode) =>
        ref.read(themeProvider.notifier).setTheme(mode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsSectionTitle(s.appearance, isDark),
        const SizedBox(height: 8),
        GlassPanel(
          borderRadius: 14,
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              SettingsRadioTile(
                title: context.tr('dark_radar'),
                subtitle: context.tr('neon_theme'),
                icon: Icons.dark_mode_rounded,
                selected: themeMode == AppThemeMode.dark,
                color: AppColors.primary,
                isDark: isDark,
                onTap: () => setTheme(AppThemeMode.dark),
              ),
              SettingsDivider(isDark),
              SettingsRadioTile(
                title: context.tr('light_aviation'),
                subtitle: context.tr('clean_theme'),
                icon: Icons.light_mode_rounded,
                selected: themeMode == AppThemeMode.light,
                color: UiConstants.lightPrimary,
                isDark: isDark,
                onTap: () => setTheme(AppThemeMode.light),
              ),
              SettingsDivider(isDark),
              SettingsRadioTile(
                title: context.tr('system'),
                subtitle: context.tr('follow_os'),
                icon: Icons.settings_brightness_rounded,
                selected: themeMode == AppThemeMode.system,
                color: AppColors.accent,
                isDark: isDark,
                onTap: () => setTheme(AppThemeMode.system),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
