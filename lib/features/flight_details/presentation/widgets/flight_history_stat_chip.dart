import 'package:flutter/material.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';

class FlightHistoryStatChip extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color color;
  final bool isDark;

  const FlightHistoryStatChip({
    super.key,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.1 : 0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: UiConstants.headingFont,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: UiConstants.bodyFont,
                fontSize: 9,
                color: isDark ? AppColors.textMuted : UiConstants.lightTextMuted,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
