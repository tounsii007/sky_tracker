import 'package:flutter/material.dart';
import 'package:sky_tracker/core/l10n/ui_text.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';
import 'package:sky_tracker/features/search/data/models/search_models.dart';

const searchGroupOrder = <SearchResultType>[
  SearchResultType.liveAircraft,
  SearchResultType.airline,
  SearchResultType.apiResult,
  SearchResultType.airlineFlight,
  SearchResultType.country,
];

const _groupColors = <SearchResultType, Color?>{
  SearchResultType.liveAircraft: AppColors.success,
  SearchResultType.airline: AppColors.accent,
  SearchResultType.apiResult: null,      // falls back to primary
  SearchResultType.airlineFlight: null,  // falls back to primary
  SearchResultType.country: AppColors.altitudeLow,
};

Color searchGroupColor(SearchResultType type, Color primary) =>
    _groupColors[type] ?? primary;

String searchGroupLabel(BuildContext context, SearchResultType type) =>
    switch (type) {
      SearchResultType.liveAircraft  => context.tr('live'),
      SearchResultType.airline        => context.tr('airlines'),
      SearchResultType.apiResult      => context.tr('flights_upper'),
      SearchResultType.airlineFlight  => context.tr('flights_upper'),
      SearchResultType.country        => context.tr('countries'),
    };

Map<SearchResultType, List<SearchResultItem>> groupSearchResults(
  List<SearchResultItem> results,
) {
  final groups = <SearchResultType, List<SearchResultItem>>{};
  for (final r in results) {
    (groups[r.type] ??= []).add(r);
  }
  return groups;
}
