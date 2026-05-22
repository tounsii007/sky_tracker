import 'package:flutter/material.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/l10n/ui_text.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';

class SearchEmptyState extends StatelessWidget {
  final bool isDark;
  const SearchEmptyState({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flight_rounded,
            size: 48,
            color: isDark ? AppColors.textMuted : UiConstants.lightDisabled,
          ),
          const SizedBox(height: 12),
          Text(
            context.tr('search_flights_prompt'),
            style: TextStyle(
              fontFamily: UiConstants.bodyFont,
              fontSize: UiConstants.bodyFontSize,
              color: isDark
                  ? AppColors.textSecondary
                  : UiConstants.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr('search_examples'),
            style: TextStyle(
              fontFamily: UiConstants.bodyFont,
              fontSize: UiConstants.captionFontSize,
              color: isDark ? AppColors.textMuted : UiConstants.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchNoResults extends StatelessWidget {
  final bool isDark;
  const SearchNoResults({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.tr('no_results'),
        style: TextStyle(
          fontFamily: UiConstants.bodyFont,
          fontSize: UiConstants.bodyFontSize,
          color: isDark
              ? AppColors.textSecondary
              : UiConstants.lightTextSecondary,
        ),
      ),
    );
  }
}
