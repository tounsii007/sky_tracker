import 'package:flutter/material.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/features/search/data/models/search_models.dart';
import 'package:sky_tracker/features/search/presentation/widgets/search_grouping.dart';
import 'package:sky_tracker/features/search/presentation/widgets/search_result_tile.dart';
import 'package:sky_tracker/features/search/presentation/widgets/search_section_header.dart';

class SearchResultsList extends StatelessWidget {
  final List<SearchResultItem> results;
  final String query;
  final bool isDark;
  final Color primary;
  final void Function(SearchResultItem) onTap;

  const SearchResultsList({
    super.key,
    required this.results,
    required this.query,
    required this.isDark,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: UiConstants.searchResultsPadding,
      itemCount: results.length,
      itemBuilder: (_, i) => SearchResultTile(
        result: results[i],
        isDark: isDark,
        primary: primary,
        query: query,
        onTap: () => onTap(results[i]),
      ),
    );
  }
}

class GroupedSearchResultsList extends StatelessWidget {
  final List<SearchResultItem> results;
  final String query;
  final bool isDark;
  final Color primary;
  final void Function(SearchResultItem) onTap;

  const GroupedSearchResultsList({
    super.key,
    required this.results,
    required this.query,
    required this.isDark,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final groups = groupSearchResults(results);
    final children = <Widget>[];

    for (final type in searchGroupOrder) {
      final items = groups[type];
      if (items == null || items.isEmpty) continue;

      children.add(SearchSectionHeader(
        title: searchGroupLabel(context, type),
        count: items.length,
        color: searchGroupColor(type, primary),
        isDark: isDark,
      ));

      for (final item in items) {
        children.add(SearchResultTile(
          result: item,
          isDark: isDark,
          primary: primary,
          query: query,
          onTap: () => onTap(item),
        ));
      }
    }

    return ListView(
      padding: UiConstants.searchResultsPadding,
      children: children,
    );
  }
}
