import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sky_tracker/core/constants/config.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/l10n/ui_text.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';
import 'package:sky_tracker/core/widgets/neon_text.dart';
import 'package:sky_tracker/features/airline/presentation/screens/airline_detail_screen.dart';
import 'package:sky_tracker/features/map/data/models/aircraft_state.dart';
import 'package:sky_tracker/features/map/presentation/providers/flight_providers.dart';
import 'package:sky_tracker/features/search/data/models/search_models.dart';
import 'package:sky_tracker/features/search/data/services/search_service.dart';
import 'package:sky_tracker/features/search/presentation/widgets/search_empty_states.dart';
import 'package:sky_tracker/features/search/presentation/widgets/search_field.dart';
import 'package:sky_tracker/features/search/presentation/widgets/search_filter_bar.dart';
import 'package:sky_tracker/features/search/presentation/widgets/search_results_list.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final void Function(AircraftState aircraft) onFlightSelected;

  const SearchScreen({super.key, required this.onFlightSelected});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _service = SearchService();

  String _query = '';
  Timer? _debounce;
  List<SearchResultItem> _suggestions = [];
  bool _isSearching = false;
  SearchFilter _activeFilter = SearchFilter.all;
  int _searchGeneration = 0;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _query = value;
    _debounce?.cancel();
    _debounce = Timer(AppConfig.searchDebounce, () => _performSearch(value));
  }

  Map<String, AircraftState> _liveAircraftSnapshot() {
    return ref.read(aircraftStreamProvider).when(
          data: (data) => data,
          loading: () => <String, AircraftState>{},
          error: (error, stackTrace) => <String, AircraftState>{},
        );
  }

  Future<void> _performSearch(String query) async {
    final generation = ++_searchGeneration;
    final q = query.trim().toUpperCase();
    if (q.isEmpty) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    final results = await _service.search(q, liveAircraft: _liveAircraftSnapshot());

    if (!mounted || generation != _searchGeneration) return;
    setState(() {
      _suggestions = results;
      _isSearching = false;
    });
  }

  void _onResultTap(SearchResultItem result) {
    switch (result.type) {
      case SearchResultType.liveAircraft:
        final selected = _service.resolveSelectedAircraft(
              result,
              liveAircraft: _liveAircraftSnapshot(),
            ) ??
            result.aircraft;
        if (selected != null) widget.onFlightSelected(selected);
      case SearchResultType.country:
        _controller.text = result.title;
        _controller.selection =
            TextSelection.collapsed(offset: result.title.length);
        _onQueryChanged(result.title);
      case SearchResultType.airline:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => AirlineDetailScreen(
            icao: result.airlineIcao ?? '',
            iata: result.airlineIata,
            name: result.title,
            country: result.subtitle.split(' - ').lastOrNull,
          ),
        ));
      case SearchResultType.apiResult:
      case SearchResultType.airlineFlight:
        final selected = _service.resolveSelectedAircraft(
          result,
          liveAircraft: _liveAircraftSnapshot(),
        );
        if (selected != null) widget.onFlightSelected(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primary : UiConstants.lightPrimary;
    final filtered = _service.filterResults(_suggestions, _activeFilter);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.background : UiConstants.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(primary, isDark),
            const SizedBox(height: 12),
            Padding(
              padding: UiConstants.screenPadding,
              child: SearchField(
                controller: _controller,
                query: _query,
                isDark: isDark,
                primary: primary,
                onChanged: _onQueryChanged,
              ),
            ),
            const SizedBox(height: 8),
            SearchFilterBar(
              suggestions: _suggestions,
              activeFilter: _activeFilter,
              isDark: isDark,
              primary: primary,
              onSelected: (f) => setState(() => _activeFilter = f),
            ),
            const SizedBox(height: 4),
            if (_isSearching)
              Padding(
                padding: UiConstants.screenPadding,
                child: LinearProgressIndicator(
                  color: primary,
                  backgroundColor: primary.withValues(alpha: 0.1),
                  minHeight: 2,
                ),
              ),
            Expanded(child: _buildBody(filtered, isDark, primary)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color primary, bool isDark) {
    return Padding(
      padding: UiConstants.searchHeaderPadding,
      child: Center(
        child: NeonText(
          text: context.s.search,
          fontSize: UiConstants.searchHeaderFontSize,
          color: primary,
          glowRadius: isDark ? 10 : 0,
        ),
      ),
    );
  }

  Widget _buildBody(
    List<SearchResultItem> filtered,
    bool isDark,
    Color primary,
  ) {
    if (_query.isEmpty) return SearchEmptyState(isDark: isDark);
    if (filtered.isEmpty && !_isSearching) return SearchNoResults(isDark: isDark);

    if (_activeFilter == SearchFilter.all) {
      return GroupedSearchResultsList(
        results: filtered,
        query: _query,
        isDark: isDark,
        primary: primary,
        onTap: _onResultTap,
      );
    }
    return SearchResultsList(
      results: filtered,
      query: _query,
      isDark: isDark,
      primary: primary,
      onTap: _onResultTap,
    );
  }
}
