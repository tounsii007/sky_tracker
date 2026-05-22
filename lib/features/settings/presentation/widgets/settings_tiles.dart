import 'package:flutter/material.dart';
import 'package:sky_tracker/core/constants/ui_constants.dart';
import 'package:sky_tracker/core/theme/app_colors.dart';

/// Small section header used between [GlassPanel] groups.
class SettingsSectionTitle extends StatelessWidget {
  final String text;
  final bool isDark;
  const SettingsSectionTitle(this.text, this.isDark, {super.key});

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          fontFamily: UiConstants.headingFont,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
          color: isDark
              ? AppColors.textSecondary
              : UiConstants.lightTextSecondary,
        ),
      );
}

class SettingsDivider extends StatelessWidget {
  final bool isDark;
  const SettingsDivider(this.isDark, {super.key});

  @override
  Widget build(BuildContext context) => Divider(
        height: 1,
        color: isDark ? AppColors.glassBorder : UiConstants.lightBorder,
      );
}

class SettingsRadioTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const SettingsRadioTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        dense: true,
        onTap: onTap,
        leading: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: selected
                ? color.withValues(alpha: isDark ? 0.2 : 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: selected
                ? color
                : (isDark ? AppColors.textMuted : UiConstants.lightHintText),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: UiConstants.bodyFont,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.textPrimary
                : UiConstants.lightTextPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontFamily: UiConstants.bodyFont,
            fontSize: 11,
            color: isDark
                ? AppColors.textSecondary
                : UiConstants.lightTextSecondary,
          ),
        ),
        trailing:
            selected ? Icon(Icons.check_circle_rounded, size: 18, color: color) : null,
      );
}

class SettingsToggleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final Color color;
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const SettingsToggleTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.color,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        dense: true,
        leading: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: value
                ? color.withValues(alpha: isDark ? 0.2 : 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: value
                ? color
                : (isDark ? AppColors.textMuted : UiConstants.lightHintText),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: UiConstants.bodyFont,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.textPrimary
                : UiConstants.lightTextPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontFamily: UiConstants.bodyFont,
            fontSize: 11,
            color: isDark
                ? AppColors.textSecondary
                : UiConstants.lightTextSecondary,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: color,
          activeTrackColor: color.withValues(alpha: 0.3),
        ),
      );
}

class SettingsSegmentedRow extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> options;
  final int selectedIndex;
  final Color color;
  final bool isDark;
  final ValueChanged<int> onSelected;

  const SettingsSegmentedRow({
    super.key,
    required this.title,
    required this.icon,
    required this.options,
    required this.selectedIndex,
    required this.color,
    required this.isDark,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
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
            ...List.generate(
              options.length,
              (j) => Padding(
                padding: EdgeInsets.only(left: j > 0 ? 4 : 0),
                child: _SegmentChip(
                  label: options[j],
                  isActive: selectedIndex == j,
                  color: color,
                  isDark: isDark,
                  onTap: () => onSelected(j),
                ),
              ),
            ),
          ],
        ),
      );
}

class _SegmentChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _SegmentChip({
    required this.label,
    required this.isActive,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isActive
                ? color.withValues(alpha: isDark ? 0.2 : 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isActive
                  ? color.withValues(alpha: 0.4)
                  : (isDark
                      ? AppColors.glassBorder
                      : UiConstants.lightBorder),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: UiConstants.headingFont,
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: isActive
                  ? color
                  : (isDark
                      ? AppColors.textMuted
                      : UiConstants.lightTextMuted),
            ),
          ),
        ),
      );
}

class SettingsInfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const SettingsInfoTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        dense: true,
        leading: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: UiConstants.bodyFont,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.textPrimary
                : UiConstants.lightTextPrimary,
          ),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            fontFamily: UiConstants.headingFont,
            fontSize: 8,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      );
}

class SettingsLanguageTile extends StatelessWidget {
  final String flag;
  final String label;
  final String subtitle;
  final bool isSelected;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const SettingsLanguageTile({
    super.key,
    required this.flag,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        dense: true,
        onTap: onTap,
        leading: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: isDark ? 0.2 : 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(flag, style: const TextStyle(fontSize: 20)),
          ),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontFamily: UiConstants.bodyFont,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.textPrimary
                : UiConstants.lightTextPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontFamily: UiConstants.bodyFont,
            fontSize: 11,
            color: isDark
                ? AppColors.textSecondary
                : UiConstants.lightTextSecondary,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle_rounded, size: 18, color: color)
            : null,
      );
}
