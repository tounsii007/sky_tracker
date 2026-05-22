import 'package:flutter/material.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/l10n/ui_text.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final bool isDark;
  final Color primary;
  final ValueChanged<String> onChanged;

  const SearchField({
    super.key,
    required this.controller,
    required this.query,
    required this.isDark,
    required this.primary,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : UiConstants.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.glassBorder : UiConstants.lightBorder,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textCapitalization: TextCapitalization.characters,
        style: TextStyle(
          fontFamily: UiConstants.headingFont,
          fontSize: UiConstants.bodyFontSize,
          color: isDark
              ? AppColors.textPrimary
              : UiConstants.lightTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: context.tr('search_flights_hint'),
          hintStyle: TextStyle(
            fontFamily: UiConstants.bodyFont,
            fontSize: UiConstants.bodyFontSize,
            color: isDark ? AppColors.textMuted : UiConstants.lightHintText,
          ),
          prefixIcon: Icon(Icons.search_rounded, color: primary),
          suffixIcon: query.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    controller.clear();
                    onChanged('');
                  },
                  child: Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: isDark
                        ? AppColors.textMuted
                        : UiConstants.lightTextMuted,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    );
  }
}
