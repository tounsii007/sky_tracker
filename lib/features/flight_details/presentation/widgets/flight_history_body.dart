import 'package:flutter/material.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/l10n/ui_text.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';
import 'package:sky_tracker/features/flight_details/data/models/flight_history_models.dart';
import 'package:sky_tracker/features/flight_details/presentation/widgets/flight_history_tile.dart';
import 'package:sky_tracker/features/map/data/datasources/flight_info_datasource.dart';

class FlightHistoryBody extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final List<HistoryFlight> flights;
  final AirlineInfo? airline;
  final AircraftMetadata? aircraftMeta;
  final int loadProgress;
  final int loadTotal;
  final bool isDark;
  final Color primary;

  const FlightHistoryBody({
    super.key,
    required this.isLoading,
    required this.error,
    required this.flights,
    required this.airline,
    required this.aircraftMeta,
    required this.loadProgress,
    required this.loadTotal,
    required this.isDark,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && flights.isNotEmpty) return _liveResults(context);
    if (isLoading && flights.isEmpty)   return _pureLoading(context);
    if (error != null)                   return _errorState(context);
    if (flights.isEmpty)                 return _emptyState(context);
    return _resultsList();
  }

  Widget _resultsList() => ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: flights.length,
        itemBuilder: (_, i) => FlightHistoryTile(
          flight: flights[i],
          isDark: isDark,
          primary: primary,
          airline: airline,
          aircraftMeta: aircraftMeta,
        ),
      );

  Widget _liveResults(BuildContext context) {
    final progressRatio = loadTotal > 0
        ? loadProgress / loadTotal.clamp(1, 999)
        : 0.0;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2, color: primary),
              ),
              const SizedBox(width: 8),
              Text(
                '${context.tr('searching')} ${flights.length} ${context.tr('found')}',
                style: TextStyle(
                  fontFamily: UiConstants.bodyFont,
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textSecondary
                      : UiConstants.lightTextSecondary,
                ),
              ),
              const Spacer(),
              if (loadTotal > 0)
                Text(
                  '$loadProgress/$loadTotal',
                  style: TextStyle(
                    fontFamily: UiConstants.headingFont,
                    fontSize: 9,
                    color: isDark
                        ? AppColors.textMuted
                        : UiConstants.lightTextMuted,
                  ),
                ),
            ],
          ),
        ),
        if (loadTotal > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LinearProgressIndicator(
              value: progressRatio,
              color: primary,
              backgroundColor: primary.withValues(alpha: 0.1),
              minHeight: 2,
            ),
          ),
        const SizedBox(height: 4),
        Expanded(child: _resultsList()),
      ],
    );
  }

  Widget _pureLoading(BuildContext context) {
    final progressRatio = loadTotal > 0
        ? loadProgress / loadTotal.clamp(1, 999)
        : 0.0;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: primary),
          const SizedBox(height: 16),
          Text(
            context.s.searchingDays,
            style: TextStyle(
              fontFamily: UiConstants.bodyFont,
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondary
                  : UiConstants.lightTextSecondary,
            ),
          ),
          if (loadTotal > 0) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                value: progressRatio,
                color: primary,
                backgroundColor: primary.withValues(alpha: 0.15),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$loadProgress / $loadTotal ${context.tr('time_windows')}',
              style: TextStyle(
                fontFamily: UiConstants.bodyFont,
                fontSize: 11,
                color: isDark
                    ? AppColors.textMuted
                    : UiConstants.lightTextMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _errorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          error ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: UiConstants.bodyFont,
            fontSize: 14,
            color: isDark
                ? AppColors.textSecondary
                : UiConstants.lightTextSecondary,
          ),
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 48,
            color: isDark ? AppColors.textMuted : UiConstants.lightDisabled,
          ),
          const SizedBox(height: 12),
          Text(
            context.tr('search_callsign_prompt'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: UiConstants.bodyFont,
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondary
                  : UiConstants.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
