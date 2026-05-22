import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sky_tracker/core/constants/settings_provider.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/l10n/strings_base.dart';
import 'package:sky_tracker/core/l10n/ui_text.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';
import 'package:sky_tracker/core/widgets/glass_panel.dart';
import 'package:sky_tracker/features/settings/presentation/widgets/settings_tiles.dart';

const _refreshIntervals = <int>[5, 10, 30, 60, 300];

String _formatInterval(int sec) =>
    sec < 60 ? '${sec}s' : '${sec ~/ 60}m';

class DataSourceSection extends ConsumerWidget {
  final bool isDark;
  final Color primary;
  final AppStrings s;

  const DataSourceSection({
    super.key,
    required this.isDark,
    required this.primary,
    required this.s,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsSectionTitle(s.dataSource, isDark),
        const SizedBox(height: 8),
        GlassPanel(
          borderRadius: 14,
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              SettingsInfoTile(
                title: context.tr('provider'),
                value: 'Airlabs.co',
                icon: Icons.cloud_rounded,
                color: AppColors.success,
                isDark: isDark,
              ),
              SettingsDivider(isDark),
              _RefreshIntervalRow(
                primary: primary,
                isDark: isDark,
                current: settings.updateIntervalSec,
                onChanged: (sec) => ref
                    .read(settingsProvider.notifier)
                    .update((cur) => cur.copyWith(updateIntervalSec: sec)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RefreshIntervalRow extends StatelessWidget {
  final Color primary;
  final bool isDark;
  final int current;
  final ValueChanged<int> onChanged;

  const _RefreshIntervalRow({
    required this.primary,
    required this.isDark,
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.timer_rounded, size: 16, color: primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              context.tr('refresh'),
              style: TextStyle(
                fontFamily: UiConstants.bodyFont,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textPrimary
                    : UiConstants.lightTextPrimary,
              ),
            ),
          ),
          ..._refreshIntervals.map((sec) {
            final isActive = current == sec;
            return Padding(
              padding: const EdgeInsets.only(left: 4),
              child: GestureDetector(
                onTap: () => onChanged(sec),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? primary.withValues(alpha: isDark ? 0.2 : 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isActive
                          ? primary.withValues(alpha: 0.4)
                          : (isDark
                              ? AppColors.glassBorder
                              : UiConstants.lightBorder),
                    ),
                  ),
                  child: Text(
                    _formatInterval(sec),
                    style: TextStyle(
                      fontFamily: UiConstants.headingFont,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? primary
                          : (isDark
                              ? AppColors.textMuted
                              : UiConstants.lightTextMuted),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
