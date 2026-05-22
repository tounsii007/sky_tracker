import 'package:flutter/material.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/l10n/ui_text.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';

class FlightHistorySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final Color primary;
  final ValueChanged<String> onSubmit;

  const FlightHistorySearchBar({
    super.key,
    required this.controller,
    required this.isDark,
    required this.primary,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Expanded(child: _buildField(context)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => onSubmit(controller.text),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primary.withValues(alpha: 0.3)),
              ),
              child: Icon(Icons.search_rounded, color: primary, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : UiConstants.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.glassBorder : UiConstants.lightBorder,
        ),
      ),
      child: TextField(
        controller: controller,
        textCapitalization: TextCapitalization.characters,
        style: TextStyle(
          fontFamily: UiConstants.headingFont,
          fontSize: 14,
          color: isDark ? AppColors.textPrimary : UiConstants.lightTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: context.tr('search_callsign_hint'),
          hintStyle: TextStyle(
            fontFamily: UiConstants.bodyFont,
            fontSize: 14,
            color: isDark ? AppColors.textMuted : UiConstants.lightHintText,
          ),
          prefixIcon: Icon(Icons.history_rounded, color: primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(12),
        ),
        onSubmitted: onSubmit,
      ),
    );
  }
}
