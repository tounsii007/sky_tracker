import 'package:sky_tracker/features/flight_details/data/models/flight_history_models.dart';

/// Delay threshold in minutes — flights within ±this are considered on-time.
const _onTimeThresholdMinutes = 15;

class FlightHistoryStats {
  final int onTime;
  final int delayed;
  final int totalDelayMinutes;

  const FlightHistoryStats({
    required this.onTime,
    required this.delayed,
    required this.totalDelayMinutes,
  });

  /// Average delay in minutes for delayed flights (0 if none).
  int get averageDelayMinutes =>
      delayed == 0 ? 0 : (totalDelayMinutes / delayed).round();

  static FlightHistoryStats from(Iterable<HistoryFlight> flights) {
    var onTime = 0;
    var delayed = 0;
    var total = 0;
    for (final f in flights) {
      final delay = f.departureDelayMinutes;
      if (delay == null) continue;
      if (delay.abs() <= _onTimeThresholdMinutes) {
        onTime++;
      } else {
        delayed++;
        total += delay;
      }
    }
    return FlightHistoryStats(
      onTime: onTime,
      delayed: delayed,
      totalDelayMinutes: total,
    );
  }
}
