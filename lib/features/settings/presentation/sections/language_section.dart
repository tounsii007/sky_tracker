import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sky_tracker/core/l10n/app_strings.dart';
import 'package:sky_tracker/core/l10n/strings_base.dart';
import 'package:sky_tracker/core/widgets/glass_panel.dart';
import 'package:sky_tracker/features/settings/presentation/widgets/settings_tiles.dart';

class _LangOption {
  final AppLanguage lang;
  final String flag;
  final String label;
  final String subtitle;
  const _LangOption(this.lang, this.flag, this.label, this.subtitle);
}

const _options = <_LangOption>[
  _LangOption(AppLanguage.en, '🇬🇧', 'English',  'Englisch'),
  _LangOption(AppLanguage.de, '🇩🇪', 'Deutsch',  'German'),
  _LangOption(AppLanguage.fr, '🇫🇷', 'Français', 'French'),
];

class LanguageSection extends ConsumerWidget {
  final bool isDark;
  final Color primary;
  final AppStrings s;

  const LanguageSection({
    super.key,
    required this.isDark,
    required this.primary,
    required this.s,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(languageProvider);

    final tiles = <Widget>[];
    for (var i = 0; i < _options.length; i++) {
      final o = _options[i];
      tiles.add(SettingsLanguageTile(
        flag: o.flag,
        label: o.label,
        subtitle: o.subtitle,
        isSelected: currentLang == o.lang,
        color: primary,
        isDark: isDark,
        onTap: () => ref.read(languageProvider.notifier).set(o.lang),
      ));
      if (i < _options.length - 1) tiles.add(SettingsDivider(isDark));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsSectionTitle(s.language, isDark),
        const SizedBox(height: 8),
        GlassPanel(
          borderRadius: 14,
          padding: const EdgeInsets.all(4),
          child: Column(children: tiles),
        ),
      ],
    );
  }
}
