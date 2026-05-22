import 'package:flutter/material.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/l10n/ui_text.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';
import 'package:sky_tracker/features/search/data/models/search_models.dart';
import 'package:sky_tracker/features/search/presentation/widgets/search_filter_chip.dart';

class SearchFilterBar extends StatelessWidget {
  final List<SearchResultItem> suggestions;
  final SearchFilter activeFilter;
  final bool isDark;
  final Color primary;
  final ValueChanged<SearchFilter> onSelected;

  const SearchFilterBar({
    super.key,
    required this.suggestions,
    required this.activeFilter,
    required this.isDark,
    required this.primary,
    required this.onSelected,
  });

  int _countOf(SearchResultType type) =>
      suggestions.where((r) => r.type == type).length;

  @override
  Widget build(BuildContext context) {
    final hasSuggestions = suggestions.isNotEmpty;

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: UiConstants.screenPadding,
        children: [
          SearchFilterChip(
            label: context.tr('all'),
            count: hasSuggestions ? suggestions.length : null,
            isActive: activeFilter == SearchFilter.all,
            color: primary,
            isDark: isDark,
            onTap: () => onSelected(SearchFilter.all),
          ),
          SearchFilterChip(
            label: context.tr('live'),
            count: hasSuggestions ? _countOf(SearchResultType.liveAircraft) : null,
            isActive: activeFilter == SearchFilter.live,
            color: AppColors.success,
            isDark: isDark,
            onTap: () => onSelected(SearchFilter.live),
          ),
          SearchFilterChip(
            label: context.tr('airlines'),
            count: hasSuggestions ? _countOf(SearchResultType.airline) : null,
            isActive: activeFilter == SearchFilter.airlines,
            color: AppColors.accent,
            isDark: isDark,
            onTap: () => onSelected(SearchFilter.airlines),
          ),
          SearchFilterChip(
            label: context.tr('flights_upper'),
            count: hasSuggestions
                ? _countOf(SearchResultType.apiResult) +
                    _countOf(SearchResultType.airlineFlight)
                : null,
            isActive: activeFilter == SearchFilter.flights,
            color: primary,
            isDark: isDark,
            onTap: () => onSelected(SearchFilter.flights),
          ),
        ],
      ),
    );
  }
}
