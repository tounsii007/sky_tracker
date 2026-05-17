import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sky_tracker/core/constants/settings_provider.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/l10n/app_strings.dart';
import 'package:sky_tracker/core/l10n/ui_text.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';
import 'package:sky_tracker/core/theme/theme_provider.dart';
import 'package:sky_tracker/core/widgets/glass_panel.dart';
import 'package:sky_tracker/core/widgets/neon_text.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primary : UiConstants.lightPrimary;
    final themeMode = ref.watch(themeProvider);
    final settings = ref.watch(settingsProvider);
    final currentLang = ref.watch(languageProvider);
    final s = S.of(currentLang);

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : UiConstants.lightBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            NeonText(text: s.settings, fontSize: UiConstants.searchHeaderFontSize, color: primary,
                glowRadius: isDark ? 10 : 0),
            const SizedBox(height: 20),

            // ═══ APPEARANCE ═══
            _Sec(s.appearance, isDark),
            const SizedBox(height: 8),
            GlassPanel(borderRadius: 14, padding: const EdgeInsets.all(4), child: Column(children: [
              _Radio(context.tr('dark_radar'), context.tr('neon_theme'), Icons.dark_mode_rounded,
                  themeMode == AppThemeMode.dark, AppColors.primary, isDark,
                  () => ref.read(themeProvider.notifier).setTheme(AppThemeMode.dark)),
              _Div(isDark),
              _Radio(context.tr('light_aviation'), context.tr('clean_theme'), Icons.light_mode_rounded,
                  themeMode == AppThemeMode.light, UiConstants.lightPrimary, isDark,
                  () => ref.read(themeProvider.notifier).setTheme(AppThemeMode.light)),
              _Div(isDark),
              _Radio(context.tr('system'), context.tr('follow_os'), Icons.settings_brightness_rounded,
                  themeMode == AppThemeMode.system, AppColors.accent, isDark,
                  () => ref.read(themeProvider.notifier).setTheme(AppThemeMode.system)),
            ])),

            const SizedBox(height: 20),

            // ═══ MAP THEME ═══
            _Sec(s.mapStyle, isDark),
            const SizedBox(height: 8),
            GlassPanel(borderRadius: 14, padding: const EdgeInsets.all(4), child: Column(children: [
              _Radio(context.tr('dark_radar'), context.tr('cartodb_dark'), Icons.map_rounded,
                  settings.mapTheme == MapTheme.darkRadar, primary, isDark,
                  () => ref.read(settingsProvider.notifier).update((s) => s.copyWith(mapTheme: MapTheme.darkRadar))),
              _Div(isDark),
              _Radio(context.tr('light_aviation'), context.tr('cartodb_light'), Icons.map_outlined,
                  settings.mapTheme == MapTheme.lightAviation, primary, isDark,
                  () => ref.read(settingsProvider.notifier).update((s) => s.copyWith(mapTheme: MapTheme.lightAviation))),
              _Div(isDark),
              _Radio(context.tr('satellite'), context.tr('arcgis_imagery'), Icons.satellite_alt_rounded,
                  settings.mapTheme == MapTheme.satellite, primary, isDark,
                  () => ref.read(settingsProvider.notifier).update((s) => s.copyWith(mapTheme: MapTheme.satellite))),
            ])),

            const SizedBox(height: 20),

            // ═══ UNITS ═══
            _Sec(s.units, isDark),
            const SizedBox(height: 8),
            GlassPanel(borderRadius: 14, padding: const EdgeInsets.all(4), child: Column(children: [
              _Seg(context.tr('altitude_short'), Icons.height_rounded, [context.tr('feet'), context.tr('meters')],
                  settings.altitudeUnit.index, primary, isDark,
                  (i) => ref.read(settingsProvider.notifier).update((s) => s.copyWith(altitudeUnit: AltitudeUnit.values[i]))),
              _Div(isDark),
              _Seg(context.tr('speed_short'), Icons.speed_rounded, [context.tr('knots'), 'km/h', 'mph'],
                  settings.speedUnit.index, primary, isDark,
                  (i) => ref.read(settingsProvider.notifier).update((s) => s.copyWith(speedUnit: SpeedUnit.values[i]))),
            ])),

            const SizedBox(height: 20),

            // ═══ MAP OPTIONS ═══
            _Sec(s.mapOptions, isDark),
            const SizedBox(height: 8),
            GlassPanel(borderRadius: 14, padding: const EdgeInsets.all(4), child: Column(children: [
              _Tog(context.tr('aircraft_trails'), context.tr('flight_path'), Icons.timeline_rounded,
                  settings.showAircraftTrails, primary, isDark,
                  (v) => ref.read(settingsProvider.notifier).update((s) => s.copyWith(showAircraftTrails: v))),
              _Div(isDark),
              _Tog(context.tr('aircraft_labels'), context.tr('callsign_label'), Icons.label_rounded,
                  settings.showAircraftLabels, primary, isDark,
                  (v) => ref.read(settingsProvider.notifier).update((s) => s.copyWith(showAircraftLabels: v))),
              _Div(isDark),
              _Tog(context.tr('airport_labels'), context.tr('iata_codes'), Icons.location_city_rounded,
                  settings.showAirportLabels, primary, isDark,
                  (v) => ref.read(settingsProvider.notifier).update((s) => s.copyWith(showAirportLabels: v))),
              _Div(isDark),
              _Tog(context.tr('density_heatmap'), context.tr('overlay'), Icons.blur_on_rounded,
                  settings.showHeatmap, primary, isDark,
                  (v) => ref.read(settingsProvider.notifier).update((s) => s.copyWith(showHeatmap: v))),
            ])),

            const SizedBox(height: 20),

            // ═══ LANGUAGE ═══
            _Sec(s.language, isDark),
            const SizedBox(height: 8),
            GlassPanel(borderRadius: 14, padding: const EdgeInsets.all(4), child: Column(children: [
              _LangTile(
                flag: '🇬🇧', label: 'English', subtitle: 'Englisch',
                isSelected: currentLang == AppLanguage.en,
                color: primary, isDark: isDark,
                onTap: () => ref.read(languageProvider.notifier).set(AppLanguage.en),
              ),
              _Div(isDark),
              _LangTile(
                flag: '🇩🇪', label: 'Deutsch', subtitle: 'German',
                isSelected: currentLang == AppLanguage.de,
                color: primary, isDark: isDark,
                onTap: () => ref.read(languageProvider.notifier).set(AppLanguage.de),
              ),
              _Div(isDark),
              _LangTile(
                flag: '🇫🇷', label: 'Français', subtitle: 'French',
                isSelected: currentLang == AppLanguage.fr,
                color: primary, isDark: isDark,
                onTap: () => ref.read(languageProvider.notifier).set(AppLanguage.fr),
              ),
            ])),

            const SizedBox(height: 20),

            // ═══ DATA SOURCE + REFRESH INTERVAL ═══
            _Sec(s.dataSource, isDark),
            const SizedBox(height: 8),
            GlassPanel(borderRadius: 14, padding: const EdgeInsets.all(4), child: Column(children: [
              _Info(context.tr('provider'), 'Airlabs.co', Icons.cloud_rounded, AppColors.success, isDark),
              _Div(isDark),
              // Refresh interval selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.timer_rounded, size: 16, color: primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.tr('refresh'),
                        style: TextStyle(
                          fontFamily: UiConstants.bodyFont,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimary : UiConstants.lightTextPrimary,
                        ),
                      ),
                    ),
                    ...[5, 10, 30, 60, 300].map((sec) {
                      final isActive = settings.updateIntervalSec == sec;
                      final label = sec < 60 ? '${sec}s' : '${sec ~/ 60}m';
                      return Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: GestureDetector(
                          onTap: () => ref
                              .read(settingsProvider.notifier)
                              .update((s) => s.copyWith(updateIntervalSec: sec)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? primary.withValues(alpha: isDark ? 0.2 : 0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isActive
                                    ? primary.withValues(alpha: 0.4)
                                    : (isDark
                                        ? AppColors.glassBorder
                                        : UiConstants.lightBorder),
                              ),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                fontFamily: UiConstants.headingFont,
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: isActive
                                    ? primary
                                    : (isDark
                                        ? AppColors.textMuted
                                        : UiConstants.lightTextMuted),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ])),

            const SizedBox(height: 20),

            // ═══ ABOUT ═══
            // ═══ ABOUT ═══
            GlassPanel(
              borderRadius: 14,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  NeonText(text: 'AIRWATCH', fontSize: 16, color: primary, glowRadius: isDark ? 6 : 0),
                  const SizedBox(height: 4),
                  Text(
                    'v2.0.0 — ${s.tagline}',
                    style: TextStyle(
                      fontFamily: UiConstants.bodyFont,
                      fontSize: 13,
                      color: isDark ? AppColors.textMuted : UiConstants.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// Compact helper widgets
class _Sec extends StatelessWidget {
  final String t; final bool d;
  const _Sec(this.t, this.d);
  @override
  Widget build(BuildContext context) => Text(t, style: TextStyle(fontFamily: UiConstants.headingFont,
      fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 2,
      color: d ? AppColors.textSecondary : UiConstants.lightTextSecondary));
}

class _Div extends StatelessWidget {
  final bool d;
  const _Div(this.d);
  @override
  Widget build(BuildContext context) => Divider(height: 1,
      color: d ? AppColors.glassBorder : UiConstants.lightBorder);
}

class _Radio extends StatelessWidget {
  final String t, s; final IconData i; final bool sel;
  final Color c; final bool d; final VoidCallback onTap;
  const _Radio(this.t, this.s, this.i, this.sel, this.c, this.d, this.onTap);
  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    onTap: onTap,
    leading: Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: sel ? c.withValues(alpha: d ? 0.2 : 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        i,
        size: 16,
        color: sel ? c : (d ? AppColors.textMuted : UiConstants.lightHintText),
      ),
    ),
    title: Text(
      t,
      style: TextStyle(
        fontFamily: UiConstants.bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: d ? AppColors.textPrimary : UiConstants.lightTextPrimary,
      ),
    ),
    subtitle: Text(
      s,
      style: TextStyle(
        fontFamily: UiConstants.bodyFont,
        fontSize: 11,
        color: d ? AppColors.textSecondary : UiConstants.lightTextSecondary,
      ),
    ),
    trailing: sel ? Icon(Icons.check_circle_rounded, size: 18, color: c) : null,
  );
}

class _Tog extends StatelessWidget {
  final String t, s; final IconData i; final bool v;
  final Color c; final bool d; final ValueChanged<bool> on;
  const _Tog(this.t, this.s, this.i, this.v, this.c, this.d, this.on);
  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    leading: Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: v ? c.withValues(alpha: d ? 0.2 : 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        i,
        size: 16,
        color: v ? c : (d ? AppColors.textMuted : UiConstants.lightHintText),
      ),
    ),
    title: Text(
      t,
      style: TextStyle(
        fontFamily: UiConstants.bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: d ? AppColors.textPrimary : UiConstants.lightTextPrimary,
      ),
    ),
    subtitle: Text(
      s,
      style: TextStyle(
        fontFamily: UiConstants.bodyFont,
        fontSize: 11,
        color: d ? AppColors.textSecondary : UiConstants.lightTextSecondary,
      ),
    ),
    trailing: Switch(
      value: v,
      onChanged: on,
      activeThumbColor: c,
      activeTrackColor: c.withValues(alpha: 0.3),
    ),
  );
}

class _Seg extends StatelessWidget {
  final String t; final IconData i; final List<String> opts;
  final int sel; final Color c; final bool d; final ValueChanged<int> on;
  const _Seg(this.t, this.i, this.opts, this.sel, this.c, this.d, this.on);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Icon(i, size: 16, color: c),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                t,
                style: TextStyle(
                  fontFamily: UiConstants.bodyFont,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: d ? AppColors.textPrimary : UiConstants.lightTextPrimary,
                ),
              ),
            ),
            ...List.generate(
              opts.length,
              (j) => Padding(
                padding: EdgeInsets.only(left: j > 0 ? 4 : 0),
                child: GestureDetector(
                  onTap: () => on(j),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: sel == j ? c.withValues(alpha: d ? 0.2 : 0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: sel == j
                            ? c.withValues(alpha: 0.4)
                            : (d ? AppColors.glassBorder : const Color(0xFFE2E8F0)),
                      ),
                    ),
                    child: Text(
                      opts[j],
                      style: TextStyle(
                        fontFamily: UiConstants.headingFont,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: sel == j
                            ? c
                            : (d ? AppColors.textMuted : UiConstants.lightTextMuted),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _Info extends StatelessWidget {
  final String t, v; final IconData i; final Color c; final bool d;
  const _Info(this.t, this.v, this.i, this.c, this.d);
  @override
  Widget build(BuildContext context) => ListTile(
        dense: true,
        leading: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: c.withValues(alpha: d ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(i, size: 16, color: c),
        ),
        title: Text(
          t,
          style: TextStyle(
            fontFamily: UiConstants.bodyFont,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: d ? AppColors.textPrimary : UiConstants.lightTextPrimary,
          ),
        ),
        trailing: Text(
          v,
          style: TextStyle(
            fontFamily: UiConstants.headingFont,
            fontSize: 8,
            fontWeight: FontWeight.w700,
            color: c,
          ),
        ),
      );
}

class _LangTile extends StatelessWidget {
  final String flag, label, subtitle;
  final bool isSelected;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;
  const _LangTile({required this.flag, required this.label, required this.subtitle,
      required this.isSelected, required this.color, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true, onTap: onTap,
      leading: Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: isDark ? 0.2 : 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: Text(flag, style: const TextStyle(fontSize: 20))),
      ),
      title: Text(label, style: TextStyle(fontFamily: UiConstants.bodyFont, fontSize: 14,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.textPrimary : UiConstants.lightTextPrimary)),
      subtitle: Text(subtitle, style: TextStyle(fontFamily: UiConstants.bodyFont, fontSize: 11,
          color: isDark ? AppColors.textSecondary : UiConstants.lightTextSecondary)),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, size: 18, color: color)
          : null,
    );
  }
}

