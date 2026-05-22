import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/l10n/app_strings.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';
import 'package:sky_tracker/core/widgets/neon_text.dart';
import 'package:sky_tracker/features/settings/presentation/sections/about_section.dart';
import 'package:sky_tracker/features/settings/presentation/sections/appearance_section.dart';
import 'package:sky_tracker/features/settings/presentation/sections/data_source_section.dart';
import 'package:sky_tracker/features/settings/presentation/sections/language_section.dart';
import 'package:sky_tracker/features/settings/presentation/sections/map_options_section.dart';
import 'package:sky_tracker/features/settings/presentation/sections/map_theme_section.dart';
import 'package:sky_tracker/features/settings/presentation/sections/units_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primary : UiConstants.lightPrimary;
    final currentLang = ref.watch(languageProvider);
    final s = S.of(currentLang);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.background : UiConstants.lightBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            NeonText(
              text: s.settings,
              fontSize: UiConstants.searchHeaderFontSize,
              color: primary,
              glowRadius: isDark ? 10 : 0,
            ),
            const SizedBox(height: 20),
            AppearanceSection(isDark: isDark, s: s),
            const SizedBox(height: 20),
            MapThemeSection(isDark: isDark, primary: primary, s: s),
            const SizedBox(height: 20),
            UnitsSection(isDark: isDark, primary: primary, s: s),
            const SizedBox(height: 20),
            MapOptionsSection(isDark: isDark, primary: primary, s: s),
            const SizedBox(height: 20),
            LanguageSection(isDark: isDark, primary: primary, s: s),
            const SizedBox(height: 20),
            DataSourceSection(isDark: isDark, primary: primary, s: s),
            const SizedBox(height: 20),
            AboutSection(isDark: isDark, primary: primary, s: s),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
