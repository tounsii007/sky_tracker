import 'package:flutter/material.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';

class SearchFilterChip extends StatelessWidget {
  final String label;
  final int? count;
  final bool isActive;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const SearchFilterChip({
    super.key,
    required this.label,
    this.count,
    required this.isActive,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive
              ? color.withValues(alpha: isDark ? 0.2 : 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? color.withValues(alpha: 0.5)
                : (isDark ? AppColors.glassBorder : UiConstants.lightBorder),
          ),
        ),
        child: Center(
          child: Text(
            count != null ? '$label ($count)' : label,
            style: TextStyle(
              fontFamily: UiConstants.headingFont,
              fontSize: UiConstants.tinyFontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: isActive
                  ? color
                  : (isDark
                      ? AppColors.textSecondary
                      : UiConstants.lightTextSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
