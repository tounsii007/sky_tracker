import 'package:flutter/material.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/l10n/ui_text.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';
import 'package:sky_tracker/core/widgets/neon_text.dart';
import 'package:sky_tracker/features/flight_details/data/models/flight_history_models.dart';
import 'package:sky_tracker/features/flight_details/data/services/flight_history_service.dart';
import 'package:sky_tracker/features/map/data/datasources/flight_info_datasource.dart';
import 'package:sky_tracker/features/flight_details/presentation/widgets/flight_history_body.dart';
import 'package:sky_tracker/features/flight_details/presentation/widgets/flight_history_info_header.dart';
import 'package:sky_tracker/features/flight_details/presentation/widgets/flight_history_search_bar.dart';
import 'package:sky_tracker/features/flight_details/presentation/widgets/flight_history_summary.dart';

/// Shows the last 7 days of flights for a specific callsign,
/// including delays, scheduled vs actual times, aircraft info, and full airport names.
class FlightHistoryScreen extends StatefulWidget {
  final String? initialCallsign;

  const FlightHistoryScreen({super.key, this.initialCallsign});

  @override
  State<FlightHistoryScreen> createState() => _FlightHistoryScreenState();
}

class _FlightHistoryScreenState extends State<FlightHistoryScreen> {
  final _controller = TextEditingController();
  final _service = FlightHistoryService();

  List<HistoryFlight> _flights = [];
  AircraftMetadata? _aircraftMeta;
  AirlineInfo? _airline;
  bool _isLoading = false;
  String? _error;
  String _searchedCallsign = '';
  int _loadProgress = 0;
  int _loadTotal = 0;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialCallsign;
    if (initial != null) {
      _controller.text = initial;
      _search(initial);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String callsign) async {
    final cs = callsign.trim().toUpperCase();
    if (cs.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _flights = [];
      _aircraftMeta = null;
      _searchedCallsign = cs;
      _loadProgress = 0;
      _loadTotal = 0;
    });

    try {
      final result = await _service.search(
        cs,
        onProgress: (progress) {
          if (!mounted) return;
          setState(() {
            _loadTotal = progress.total;
            _loadProgress = progress.step;
            _flights = progress.flights;
          });
        },
      );

      if (!mounted) return;
      setState(() {
        _flights = result.flights;
        _aircraftMeta = result.aircraftMeta;
        _airline = result.airline;
        _isLoading = false;
        if (result.flights.isEmpty) {
          _error = '${context.tr('no_flights_found')} "$cs".\n'
              '${context.tr('search_callsign_hint')}';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primary : UiConstants.lightPrimary;
    final hasHeader = _airline != null || _aircraftMeta != null;
    final hasSummary = _searchedCallsign.isNotEmpty && !_isLoading && _flights.isNotEmpty;

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : UiConstants.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: NeonText(
          text: context.s.flightHistory,
          fontSize: 16,
          color: primary,
          glowRadius: isDark ? 8 : 0,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            FlightHistorySearchBar(
              controller: _controller,
              isDark: isDark,
              primary: primary,
              onSubmit: _search,
            ),
            if (hasHeader)
              FlightHistoryInfoHeader(
                airline: _airline,
                aircraftMeta: _aircraftMeta,
                isDark: isDark,
                primary: primary,
              ),
            if (hasSummary)
              FlightHistorySummary(
                flights: _flights,
                isDark: isDark,
                primary: primary,
              ),
            const SizedBox(height: 4),
            Expanded(
              child: FlightHistoryBody(
                isLoading: _isLoading,
                error: _error,
                flights: _flights,
                airline: _airline,
                aircraftMeta: _aircraftMeta,
                loadProgress: _loadProgress,
                loadTotal: _loadTotal,
                isDark: isDark,
                primary: primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
