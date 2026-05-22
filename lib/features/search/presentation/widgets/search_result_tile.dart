import 'package:flutter/material.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';
import 'package:sky_tracker/core/utils/flight_status_utils.dart';
import 'package:sky_tracker/core/widgets/glass_panel.dart';
import 'package:sky_tracker/features/search/data/models/search_models.dart';
import 'package:sky_tracker/features/search/presentation/widgets/highlighted_text.dart';
import 'package:sky_tracker/features/search/presentation/widgets/search_result_leading.dart';

bool _typeShowsChevron(SearchResultType type) => switch (type) {
      SearchResultType.airline || SearchResultType.country => true,
      SearchResultType.liveAircraft ||
      SearchResultType.apiResult ||
      SearchResultType.airlineFlight => false,
    };

class SearchResultTile extends StatelessWidget {
  final SearchResultItem result;
  final bool isDark;
  final Color primary;
  final String query;
  final VoidCallback onTap;

  const SearchResultTile({
    super.key,
    required this.result,
    required this.isDark,
    required this.primary,
    this.query = '',
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = FlightStatusUtils.statusColor(result.status, primary: primary);
    final statusLabel = FlightStatusUtils.statusLabel(context, result.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        child: GlassPanel(
          padding: const EdgeInsets.all(12),
          borderRadius: 12,
          child: Row(
            children: [
              SearchResultLeading(
                result: result,
                isDark: isDark,
                primary: primary,
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildText()),
              if (statusLabel.isNotEmpty) _StatusBadge(label: statusLabel, color: statusColor),
              if (_typeShowsChevron(result.type))
                Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: isDark ? AppColors.textMuted : UiConstants.lightDisabled,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HighlightedText(
          text: result.title,
          query: query,
          baseStyle: TextStyle(
            fontFamily: UiConstants.headingFont,
            fontSize: UiConstants.captionFontSize,
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.textPrimary
                : UiConstants.lightTextPrimary,
          ),
          highlightColor: primary,
        ),
        if (result.subtitle.isNotEmpty)
          HighlightedText(
            text: result.subtitle,
            query: query,
            baseStyle: TextStyle(
              fontFamily: UiConstants.bodyFont,
              fontSize: UiConstants.captionFontSize,
              color: isDark
                  ? AppColors.textSecondary
                  : UiConstants.lightTextSecondary,
            ),
            highlightColor: primary,
          ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: UiConstants.headingFont,
          fontSize: 7,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
