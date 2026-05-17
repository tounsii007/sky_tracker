import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sky_tracker/core/constants/airport_database.dart';
import 'package:sky_tracker/core/constants/country_database.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/l10n/ui_text.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';
import 'package:sky_tracker/features/map/data/datasources/flight_info_datasource.dart';

import 'panel_widgets.dart';

/// Route section: DEP ----plane---- ARR with city names and country flags.
class PanelRouteSection extends StatelessWidget {
  final FlightRouteInfo? route;
  final bool isLoading;
  final bool isDark;
  final Color primary;

  const PanelRouteSection({
    super.key,
    required this.route,
    required this.isLoading,
    required this.isDark,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    final depRaw = route?.departureAirport ?? '';
    final arrRaw = route?.arrivalAirport ?? '';
    final hasDep = depRaw.isNotEmpty && depRaw != UiConstants.unknownValue;
    final hasArr = arrRaw.isNotEmpty && arrRaw != UiConstants.unknownValue;
    if (route == null && !isLoading) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(
          color: isDark ? AppColors.glassBorder : UiConstants.lightBorder,
        )),
      ),
      child: (isLoading && route == null)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 12, height: 12,
                    child: CircularProgressIndicator(strokeWidth: 1.5, color: primary)),
                const SizedBox(width: 8),
                Text(context.tr('loading_route'), style: TextStyle(
                  fontFamily: UiConstants.bodyFont, fontSize: UiConstants.captionFontSize,
                  color: isDark ? AppColors.textMuted : UiConstants.lightTextMuted,
                )),
              ],
            )
          : Row(
              children: [
                // Departure
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Text(hasDep ? AirportDatabase.displayCode(route!.departureAirport) : UiConstants.missingCode,
                    style: TextStyle(fontFamily: UiConstants.headingFont, fontSize: UiConstants.bodyFontSize,
                        fontWeight: FontWeight.w700,
                        color: hasDep ? AppColors.success : AppColors.textMuted)),
                  if (hasDep) ...[
                    // City name (only if not empty)
                    Builder(builder: (_) {
                      final city = route!.depCity ?? AirportDatabase.getCity(route!.departureAirport);
                      if (city.isEmpty) return const SizedBox.shrink();
                      return Text(city, style: TextStyle(fontFamily: UiConstants.bodyFont, fontSize: UiConstants.microFontSize,
                          color: isDark ? AppColors.textSecondary : UiConstants.lightTextSecondary),
                        textAlign: TextAlign.center, overflow: TextOverflow.ellipsis);
                    }),
                    // Country + flag
                    Builder(builder: (_) {
                      final country = AirportDatabase.getCountry(route!.departureAirport);
                      if (country.isEmpty) return const SizedBox.shrink();
                      final displayCountry = CountryDatabase.displayName(country);
                      return FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _countryFlagWidget(country),
                            const SizedBox(width: 4),
                            Text(
                              displayCountry,
                              style: TextStyle(
                                fontFamily: UiConstants.bodyFont,
                                fontSize: UiConstants.tinyFontSize,
                                color: isDark ? AppColors.textMuted : UiConstants.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ])),
                // Route line with plane
                Expanded(
                  flex: 2,
                  child: SizedBox(height: 20, child: CustomPaint(
                    painter: RouteLinePainter(color: primary),
                  )),
                ),
                // Arrival
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Text(hasArr ? AirportDatabase.displayCode(route!.arrivalAirport) : UiConstants.missingCode,
                    style: TextStyle(fontFamily: UiConstants.headingFont, fontSize: UiConstants.bodyFontSize,
                        fontWeight: FontWeight.w700,
                        color: hasArr ? AppColors.accent : AppColors.textMuted)),
                  if (hasArr) ...[
                    Builder(builder: (_) {
                      final city = route!.arrCity ?? AirportDatabase.getCity(route!.arrivalAirport);
                      if (city.isEmpty) return const SizedBox.shrink();
                      return Text(city, style: TextStyle(fontFamily: UiConstants.bodyFont, fontSize: UiConstants.microFontSize,
                          color: isDark ? AppColors.textSecondary : UiConstants.lightTextSecondary),
                        textAlign: TextAlign.center, overflow: TextOverflow.ellipsis);
                    }),
                    Builder(builder: (_) {
                      final country = AirportDatabase.getCountry(route!.arrivalAirport);
                      if (country.isEmpty) return const SizedBox.shrink();
                      final displayCountry = CountryDatabase.displayName(country);
                      return FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _countryFlagWidget(country),
                            const SizedBox(width: 4),
                            Text(
                              displayCountry,
                              style: TextStyle(
                                fontFamily: UiConstants.bodyFont,
                                fontSize: UiConstants.tinyFontSize,
                                color: isDark ? AppColors.textMuted : UiConstants.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ])),
              ],
            ),
    );
  }

  /// Country flag from the local country database.
  Widget _countryFlagWidget(String code) {
    final assetPath = CountryDatabase.flagAssetPathOf(code);
    final fallback = CountryDatabase.flagEmojiOf(code);
    if (assetPath == null) return const SizedBox.shrink();

    return SvgPicture.asset(
      assetPath,
      width: 16,
      height: 12,
      fit: BoxFit.cover,
      placeholderBuilder: (_) => fallback.isEmpty
          ? const SizedBox(width: 16, height: 12)
          : Center(child: Text(fallback, style: const TextStyle(fontSize: 13))),
    );
  }
}
