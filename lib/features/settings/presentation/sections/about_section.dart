import 'package:flutter/material.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/l10n/strings_base.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';
import 'package:sky_tracker/core/widgets/glass_panel.dart';
import 'package:sky_tracker/core/widgets/neon_text.dart';

class AboutSection extends StatelessWidget {
  final bool isDark;
  final Color primary;
  final AppStrings s;

  const AboutSection({
    super.key,
    required this.isDark,
    required this.primary,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      borderRadius: 14,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          NeonText(
            text: 'AIRWATCH',
            fontSize: 16,
            color: primary,
            glowRadius: isDark ? 6 : 0,
          ),
          const SizedBox(height: 4),
          Text(
            'v2.0.0 — ${s.tagline}',
            style: TextStyle(
              fontFamily: UiConstants.bodyFont,
              fontSize: 13,
              color: isDark
                  ? AppColors.textMuted
                  : UiConstants.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}
