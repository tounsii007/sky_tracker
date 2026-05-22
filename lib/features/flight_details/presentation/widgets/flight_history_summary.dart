import 'package:flutter/material.dart';
import 'package:sky_tracker/core/constants/airport_database.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/l10n/ui_text.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';
import 'package:sky_tracker/features/flight_details/data/models/flight_history_models.dart';
import 'package:sky_tracker/features/flight_details/presentation/utils/flight_history_stats.dart';
import 'package:sky_tracker/features/flight_details/presentation/widgets/flight_history_stat_chip.dart';

class FlightHistorySummary extends StatelessWidget {
  final List<HistoryFlight> flights;
  final bool isDark;
  final Color primary;

  const FlightHistorySummary({
    super.key,
    required this.flights,
    required this.isDark,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    final stats = FlightHistoryStats.from(flights);
    final dep = flights.isNotEmpty ? flights.first.effectiveDep : null;
    final arr = flights.isNotEmpty ? flights.first.effectiveArr : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (dep != null || arr != null) _RouteHeader(dep: dep, arr: arr, primary: primary),
          Row(
            children: [
              FlightHistoryStatChip(
                label: '${flights.length}',
                subtitle: context.tr('flights_count'),
                color: primary,
                isDark: isDark,
              ),
              const SizedBox(width: 6),
              FlightHistoryStatChip(
                label: '${stats.onTime}',
                subtitle: context.tr('on_time'),
                color: AppColors.success,
                isDark: isDark,
              ),
              const SizedBox(width: 6),
              FlightHistoryStatChip(
                label: '${stats.delayed}',
                subtitle: context.tr('delayed'),
                color: stats.delayed > 0 ? AppColors.error : AppColors.success,
                isDark: isDark,
              ),
              if (stats.delayed > 0) ...[
                const SizedBox(width: 6),
                FlightHistoryStatChip(
                  label: '~${stats.averageDelayMinutes}m',
                  subtitle: context.tr('avg_delay'),
                  color: AppColors.warning,
                  isDark: isDark,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _RouteHeader extends StatelessWidget {
  final String? dep;
  final String? arr;
  final Color primary;

  const _RouteHeader({
    required this.dep,
    required this.arr,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AirportDatabase.fullDisplay(dep),
            style: TextStyle(
              fontFamily: UiConstants.bodyFont,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.success,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.arrow_forward_rounded, size: 14, color: primary),
          ),
          Text(
            AirportDatabase.fullDisplay(arr),
            style: TextStyle(
              fontFamily: UiConstants.bodyFont,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
