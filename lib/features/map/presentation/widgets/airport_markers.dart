import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sky_tracker/core/constants/airport_full_database.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';
import 'package:sky_tracker/features/airport/presentation/screens/airport_detail_screen.dart';

/// World airports as blue glowing dots. ~150 airports total.
class AirportMarkersLayer extends StatelessWidget {
  final double zoom;
  const AirportMarkersLayer({super.key, required this.zoom});

  @override
  Widget build(BuildContext context) {
    if (zoom < 3) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    List<_A> apts;
    if (zoom < 4) {
      apts = _tier1;
    } else if (zoom < 6) {
      apts = _tier2;
    } else if (zoom < 8) {
      apts = _tier3;
    } else {
      // Zoom 8+: Show ALL airports from the full 20k+ database in viewport
      final camera = MapCamera.maybeOf(context);
      if (camera != null) {
        final bounds = camera.visibleBounds;
        apts = airportFullDatabase.values
            .where((a) => a.iata.isNotEmpty &&
                a.lat >= bounds.south - 0.5 && a.lat <= bounds.north + 0.5 &&
                a.lon >= bounds.west - 0.5 && a.lon <= bounds.east + 0.5)
            .map((a) => _A(a.iata, a.lat, a.lon))
            .toList();
      } else {
        apts = _tier3;
      }
    }

    final showLabel = zoom >= 6;
    final dot = zoom < 5 ? 5.0 : 7.0;

    void openAirport(BuildContext ctx, String iata) {
      Navigator.of(ctx).push(MaterialPageRoute(
        builder: (_) => AirportDetailScreen(iataCode: iata),
      ));
    }

    return MarkerLayer(
      markers: apts.map((a) => Marker(
        point: LatLng(a.la, a.lo),
        width: showLabel ? 80 : dot * 2 + 4,
        height: showLabel ? 22 : dot * 2 + 4,
        child: GestureDetector(
          onTap: () => openAirport(context, a.c),
          child: showLabel
              ? _Lbl(iata: a.c, isDark: isDark)
              : _Dot(size: dot, isDark: isDark),
        ),
      )).toList(),
    );
  }
}

class _Dot extends StatelessWidget {
  final double size; final bool isDark;
  const _Dot({required this.size, required this.isDark});
  @override
  Widget build(BuildContext context) {
    const c = UiConstants.lightPrimary;
    return Center(child: Container(width: size, height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: c.withValues(alpha: 0.8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 0.5),
        boxShadow: isDark ? [
          BoxShadow(color: c.withValues(alpha: 0.5), blurRadius: 6, spreadRadius: 1),
          BoxShadow(color: c.withValues(alpha: 0.2), blurRadius: 12, spreadRadius: 2),
        ] : [BoxShadow(color: c.withValues(alpha: 0.3), blurRadius: 4)])));
  }
}

class _Lbl extends StatelessWidget {
  final String iata; final bool isDark;
  const _Lbl({required this.iata, required this.isDark});
  @override
  Widget build(BuildContext context) {
    const c = UiConstants.lightPrimary;
    return Center(child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface.withValues(alpha: 0.85) : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: c.withValues(alpha: 0.4), width: 0.5),
        boxShadow: isDark ? [BoxShadow(color: c.withValues(alpha: 0.2), blurRadius: 4)] : []),
      child: Text(iata, style: TextStyle(fontFamily: UiConstants.headingFont, fontSize: 7,
          fontWeight: FontWeight.w700, color: c, letterSpacing: 0.5))));
  }
}

class _A { final String c; final double la, lo; const _A(this.c, this.la, this.lo); }

// ═══ TIER 1: Top 30 mega-hubs (zoom 3+) ═══
const _tier1 = <_A>[
  // Americas
  _A('ATL', 33.637, -84.428), _A('DFW', 32.897, -97.038), _A('DEN', 39.862, -104.673),
  _A('ORD', 41.978, -87.905), _A('LAX', 33.943, -118.408), _A('JFK', 40.640, -73.779),
  _A('MIA', 25.796, -80.287), _A('SFO', 37.615, -122.390), _A('GRU', -23.432, -46.470),
  _A('MEX', 19.436, -99.072), _A('YYZ', 43.677, -79.631),
  // Europe
  _A('LHR', 51.470, -0.454), _A('CDG', 49.010, 2.548), _A('FRA', 50.033, 8.571),
  _A('AMS', 52.309, 4.764), _A('IST', 41.262, 28.742), _A('MAD', 40.472, -3.561),
  _A('FCO', 41.800, 12.239), _A('MUC', 48.354, 11.786), _A('BCN', 41.297, 2.079),
  // Middle East / Africa
  _A('DXB', 25.253, 55.366), _A('DOH', 25.261, 51.565), _A('AUH', 24.433, 54.651),
  _A('JED', 21.680, 39.157), _A('CAI', 30.122, 31.406),
  // Asia-Pacific
  _A('PEK', 40.080, 116.584), _A('HND', 35.553, 139.780), _A('SIN', 1.350, 103.994),
  _A('ICN', 37.463, 126.441), _A('BKK', 13.681, 100.747),
];

// ═══ TIER 2: 80 major airports (zoom 4-5) ═══
const _tier2 = <_A>[
  ..._tier1,
  // Americas
  _A('EWR', 40.693, -74.169), _A('BOS', 42.365, -71.010), _A('SEA', 47.449, -122.309),
  _A('IAD', 38.944, -77.456), _A('MSP', 44.882, -93.222), _A('DTW', 42.212, -83.353),
  _A('PHL', 39.872, -75.241), _A('CLT', 35.214, -80.943), _A('LAS', 36.080, -115.152),
  _A('PHX', 33.437, -112.008), _A('MCO', 28.429, -81.309), _A('IAH', 29.984, -95.342),
  _A('YUL', 45.470, -73.741), _A('YVR', 49.195, -123.179), _A('BOG', 4.702, -74.147),
  _A('EZE', -34.822, -58.536), _A('SCL', -33.393, -70.786), _A('LIM', -12.022, -77.114),
  _A('CUN', 21.037, -86.877), _A('PTY', 9.071, -79.384),
  // Europe
  _A('ZRH', 47.458, 8.548), _A('VIE', 48.110, 16.570), _A('CPH', 55.618, 12.656),
  _A('OSL', 60.194, 11.100), _A('ARN', 59.652, 17.919), _A('HEL', 60.317, 24.963),
  _A('DUB', 53.421, -6.270), _A('LIS', 38.774, -9.134), _A('ATH', 37.936, 23.944),
  _A('WAW', 52.166, 20.967), _A('BER', 52.362, 13.509), _A('BRU', 50.902, 4.485),
  _A('GVA', 46.238, 6.109), _A('SVO', 55.973, 37.414),
  // Middle East / Africa
  _A('TLV', 32.011, 34.887), _A('RUH', 24.958, 46.699), _A('ADD', 8.978, 38.799),
  _A('JNB', -26.134, 28.242), _A('NBO', -1.319, 36.928), _A('CMN', 33.367, -7.590),
  _A('ALG', 36.691, 3.215), _A('TUN', 36.851, 10.227), _A('LOS', 6.577, 3.321),
  _A('ACC', 5.605, -0.167), _A('DAR', -6.878, 39.203),
  // Asia-Pacific
  _A('HKG', 22.309, 113.915), _A('PVG', 31.143, 121.805), _A('CAN', 23.392, 113.299),
  _A('NRT', 35.765, 140.386), _A('DEL', 28.556, 77.100), _A('BOM', 19.089, 72.868),
  _A('KUL', 2.746, 101.710), _A('CGK', -6.126, 106.656), _A('SYD', -33.947, 151.177),
  _A('MEL', -37.669, 144.843), _A('AKL', -37.008, 174.792), _A('TPE', 25.077, 121.233),
  _A('MNL', 14.508, 121.020), _A('BLR', 13.199, 77.706), _A('CCU', 22.654, 88.447),
];

// ═══ TIER 3: 150+ airports (zoom 6+) ═══
const _tier3 = <_A>[
  ..._tier2,
  // Europe regional
  _A('DUS', 51.290, 6.767), _A('HAM', 53.630, 9.988), _A('STR', 48.690, 9.222),
  _A('CGN', 50.866, 7.143), _A('NUE', 49.499, 11.078), _A('LEJ', 51.432, 12.242),
  _A('MAN', 53.354, -2.275), _A('EDI', 55.950, -3.373), _A('LGW', 51.148, -0.190),
  _A('STN', 51.885, 0.235), _A('LTN', 51.875, -0.368), _A('BHX', 52.454, -1.748),
  _A('ORY', 48.723, 2.379), _A('LYS', 45.726, 5.091), _A('MRS', 43.436, 5.215),
  _A('TLS', 43.629, 1.364), _A('NCE', 43.658, 7.216), _A('BOD', 44.828, -0.715),
  _A('MXP', 45.630, 8.723), _A('BGY', 45.669, 9.704), _A('NAP', 40.886, 14.291),
  _A('VCE', 45.505, 12.352), _A('PMI', 39.552, 2.739), _A('AGP', 36.675, -4.499),
  _A('ALC', 38.282, -0.558), _A('SVQ', 37.418, -5.893), _A('OPO', 41.248, -8.681),
  _A('AYT', 36.899, 30.800), _A('SAW', 40.899, 29.309), _A('ESB', 40.128, 32.995),
  _A('BUD', 47.439, 19.262), _A('PRG', 50.101, 14.260), _A('OTP', 44.572, 26.085),
  _A('BEG', 44.819, 20.309), _A('SOF', 42.696, 23.411), _A('ZAG', 45.743, 16.069),
  _A('KEF', 63.985, -22.606), _A('KRK', 50.078, 19.785), _A('GDN', 54.378, 18.466),
  // Tunisia (all)
  _A('MIR', 35.758, 10.755), _A('NBE', 36.076, 10.438), _A('DJE', 33.875, 10.775),
  _A('TOE', 33.940, 8.111), _A('SFA', 34.718, 10.691), _A('GAF', 34.422, 8.822),
  _A('GAE', 33.877, 10.103), _A('TBJ', 36.978, 8.877),
  // Morocco (all)
  _A('RAK', 31.607, -8.036), _A('FEZ', 33.927, -4.978), _A('TNG', 35.727, -5.917),
  _A('AGA', 30.325, -9.413), _A('NDR', 34.989, -3.028), _A('OJD', 34.787, -1.924),
  _A('RBA', 34.051, -6.751), _A('ESU', 31.398, -9.682),
  // Popular vacation / hub airports
  _A('HRG', 27.178, 33.799),  // Hurghada
  _A('SSH', 27.977, 34.395),  // Sharm El Sheikh
  _A('MLE', 4.192, 73.529),   // Maldives
  _A('MRU', -20.430, 57.684), // Mauritius
  _A('DPS', -8.748, 115.167), // Bali
  _A('HNL', 21.319, -157.922),// Honolulu
  _A('PUJ', 18.567, -68.364), // Punta Cana
  _A('MBJ', 18.504, -77.913), // Montego Bay
  _A('NAS', 25.039, -77.466), // Nassau Bahamas
  _A('SJO', 9.994, -84.209),  // San José Costa Rica
  _A('GIG', -22.810, -43.251),// Rio de Janeiro
  _A('CPT', -33.965, 18.602), // Cape Town
  _A('DSS', 14.670, -17.073), // Dakar
  _A('CMB', 7.181, 79.884),   // Colombo
  _A('KTM', 27.697, 85.359),  // Kathmandu
  _A('PNH', 11.547, 104.844), // Phnom Penh
  _A('SGN', 10.819, 106.652), // Ho Chi Minh
  _A('HAN', 21.221, 105.807), // Hanoi
  _A('RGN', 16.907, 96.133),  // Yangon
  _A('DAD', 16.044, 108.199), // Da Nang
  _A('REP', 13.411, 103.813), // Siem Reap
  _A('CEB', 10.307, 123.979), // Cebu
  _A('DMK', 13.913, 100.607), // Bangkok Don Mueang
  _A('USM', 9.548, 100.062),  // Koh Samui
  _A('HKT', 8.112, 98.317),   // Phuket
  _A('DPS', -8.748, 115.167), // Bali Denpasar
  _A('AER', 43.450, 39.956),  // Sochi
  _A('TFS', 28.045, -16.572), // Tenerife South
  _A('LPA', 27.932, -15.387), // Gran Canaria
  _A('FUE', 28.453, -13.864), // Fuerteventura
  _A('IBZ', 38.873, 1.373),   // Ibiza
  _A('CFU', 39.602, 19.912),  // Corfu
  _A('RHO', 36.405, 28.086),  // Rhodes
  _A('HER', 35.340, 25.180),  // Heraklion Crete
  _A('SKG', 40.519, 22.971),  // Thessaloniki
  _A('SPU', 43.539, 16.298),  // Split
  _A('DBV', 42.561, 18.268),  // Dubrovnik
  _A('TIA', 41.415, 19.720),  // Tirana
  _A('SKP', 41.962, 21.621),  // Skopje
  _A('SJJ', 43.825, 18.331),  // Sarajevo
];
