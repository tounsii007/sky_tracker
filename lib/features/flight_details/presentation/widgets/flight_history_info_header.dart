import 'package:flutter/material.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';
import 'package:sky_tracker/core/widgets/glass_panel.dart';
import 'package:sky_tracker/features/map/data/datasources/flight_info_datasource.dart';

class FlightHistoryInfoHeader extends StatelessWidget {
  final AirlineInfo? airline;
  final AircraftMetadata? aircraftMeta;
  final bool isDark;
  final Color primary;

  const FlightHistoryInfoHeader({
    super.key,
    required this.airline,
    required this.aircraftMeta,
    required this.isDark,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    final logoUrl = airline != null
        ? FlightInfoDatasource.getAirlineLogoUrl(airline?.iata ?? '')
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: GlassPanel(
        padding: const EdgeInsets.all(10),
        borderRadius: 12,
        child: Row(
          children: [
            if (logoUrl != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Image.network(
                  logoUrl,
                  width: 50,
                  height: 24,
                  fit: BoxFit.contain,
                  errorBuilder: (_, error, stack) =>
                      Icon(Icons.airlines_rounded, color: primary, size: 22),
                ),
              ),
            Expanded(child: _buildText()),
            if (aircraftMeta?.typecode != null) _buildTypecodeBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (airline != null)
          Text(
            airline?.name ?? '',
            style: TextStyle(
              fontFamily: UiConstants.bodyFont,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimary
                  : UiConstants.lightTextPrimary,
            ),
          ),
        if (aircraftMeta != null)
          Text(
            '${aircraftMeta?.displayType ?? ''} • ${aircraftMeta?.registration ?? ''}',
            style: TextStyle(
              fontFamily: UiConstants.bodyFont,
              fontSize: 12,
              color: isDark
                  ? AppColors.textSecondary
                  : UiConstants.lightTextSecondary,
            ),
          ),
      ],
    );
  }

  Widget _buildTypecodeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: primary.withValues(alpha: 0.2)),
      ),
      child: Text(
        aircraftMeta?.typecode ?? '',
        style: TextStyle(
          fontFamily: UiConstants.headingFont,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: primary,
        ),
      ),
    );
  }
}
