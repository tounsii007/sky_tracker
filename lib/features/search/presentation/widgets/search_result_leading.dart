import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sky_tracker/core/constants/country_database.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';
import 'package:sky_tracker/core/utils/aircraft_icons.dart';
import 'package:sky_tracker/features/map/data/datasources/flight_info_datasource.dart';
import 'package:sky_tracker/features/search/data/models/search_models.dart';

const _kAirlineSize = 44.0;
const _kDefaultSize = 36.0;

class SearchResultLeading extends StatelessWidget {
  final SearchResultItem result;
  final bool isDark;
  final Color primary;

  const SearchResultLeading({
    super.key,
    required this.result,
    required this.isDark,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, iconColor) = _iconFor(result);

    if (result.type == SearchResultType.airline) {
      return SizedBox(
        width: _kAirlineSize,
        height: _kAirlineSize,
        child: _AirlineLogo(iata: result.airlineIata, fallbackColor: iconColor),
      );
    }

    return Container(
      width: _kDefaultSize,
      height: _kDefaultSize,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: switch (result.type) {
        SearchResultType.country =>
          _CountryFlag(countryCode: result.countryCode, fallbackColor: iconColor),
        _ => Icon(icon, size: 18, color: iconColor),
      },
    );
  }

  (IconData, Color) _iconFor(SearchResultItem r) {
    return switch (r.type) {
      SearchResultType.liveAircraft => (
          Icons.flight_rounded,
          r.altitude != null
              ? AircraftIconPainter.getAltitudeColor(r.altitude)
              : AppColors.success,
        ),
      SearchResultType.airline       => (Icons.airlines_rounded, AppColors.accent),
      SearchResultType.apiResult     => (Icons.flight_takeoff_rounded, primary),
      SearchResultType.airlineFlight => (Icons.flight_rounded, primary),
      SearchResultType.country       => (Icons.flag_rounded, AppColors.altitudeLow),
    };
  }
}

class _CountryFlag extends StatelessWidget {
  final String? countryCode;
  final Color fallbackColor;
  const _CountryFlag({required this.countryCode, required this.fallbackColor});

  @override
  Widget build(BuildContext context) {
    final assetPath = CountryDatabase.flagAssetPathOf(countryCode);
    if (assetPath == null) {
      return Icon(Icons.flag_rounded, size: 18, color: fallbackColor);
    }
    return Padding(
      padding: const EdgeInsets.all(7),
      child: SvgPicture.asset(assetPath, fit: BoxFit.cover),
    );
  }
}

class _AirlineLogo extends StatelessWidget {
  final String? iata;
  final Color fallbackColor;
  const _AirlineLogo({required this.iata, required this.fallbackColor});

  @override
  Widget build(BuildContext context) {
    final logoUrl = FlightInfoDatasource.getAirlineLogoUrl(iata);
    if (logoUrl == null) {
      return Icon(Icons.airlines_rounded, size: 22, color: fallbackColor);
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: CachedNetworkImage(
          imageUrl: logoUrl,
          fit: BoxFit.contain,
          errorWidget: (_, error, stack) =>
              Icon(Icons.airlines_rounded, size: 22, color: fallbackColor),
          placeholder: (_, url) =>
              Icon(Icons.airlines_rounded, size: 22, color: fallbackColor),
        ),
      ),
    );
  }
}
