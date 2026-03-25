import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:test888/core/providers/app_theme_provider.dart';
import 'package:test888/generated/l10n/app_localizations.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  static const List<Color> _presetColors = [
    Color(0xFFFF9F1C),
    Color(0xFF2EC4B6),
    Color(0xFF007AFF),
    Color(0xFF34C759),
    Color(0xFFFF3B30),
    Color(0xFFAF52DE),
    Color(0xFF111111),
    Color(0xFFF9F9F9),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.themeSettings),
        centerTitle: true,
      ),
      body: Consumer<AppThemeProvider>(
        builder: (context, themeProvider, _) {
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            children: [
              _ColorSettingTile(
                title: l10n.primaryColor,
                current: themeProvider.primaryColor,
                onSelect: (c) => themeProvider.updateColors(primary: c),
              ),
              SizedBox(height: 12.h),
              _ColorSettingTile(
                title: l10n.secondaryColor,
                current: themeProvider.secondaryColor,
                onSelect: (c) => themeProvider.updateColors(secondary: c),
              ),
              SizedBox(height: 12.h),
              _ColorSettingTile(
                title: l10n.backgroundColor,
                current: themeProvider.backgroundColorLight,
                onSelect: (c) => themeProvider.updateColors(background: c),
              ),
              SizedBox(height: 12.h),
              _NullableColorSettingTile(
                title: l10n.textColorOptional,
                current: themeProvider.textColor,
                onClear: () => themeProvider.setTextColor(null),
                onSelect: (c) => themeProvider.setTextColor(c),
              ),
              SizedBox(height: 16.h),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (isDark) => themeProvider.setThemeMode(
                  isDark ? ThemeMode.dark : ThemeMode.light,
                ),
                title: Text(l10n.darkMode),
              ),
              SizedBox(height: 16.h),
              OutlinedButton(
                onPressed: () => themeProvider.resetToDefaults(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: theme.colorScheme.error),
                  foregroundColor: theme.colorScheme.error,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(l10n.resetToDefault),
              ),

              // Theme values are persisted inside AppThemeProvider using SharedPreferences.
              // Add/adjust translations in lib/l10n/arb/app_en.arb and lib/l10n/arb/app_ar.arb.
            ],
          );
        },
      ),
    );
  }
}

class _ColorSettingTile extends StatelessWidget {
  const _ColorSettingTile({
    required this.title,
    required this.current,
    required this.onSelect,
  });

  final String title;
  final Color current;
  final ValueChanged<Color> onSelect;

  static const List<Color> _colors = ThemeSettingsScreen._presetColors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _ColorDot(color: current),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: _colors
                .map(
                  (c) => InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () => onSelect(c),
                    child: _ColorDot(
                      color: c,
                      selected: c.value == current.value,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _NullableColorSettingTile extends StatelessWidget {
  const _NullableColorSettingTile({
    required this.title,
    required this.current,
    required this.onSelect,
    required this.onClear,
  });

  final String title;
  final Color? current;
  final ValueChanged<Color> onSelect;
  final VoidCallback onClear;

  static const List<Color> _colors = ThemeSettingsScreen._presetColors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (current != null) _ColorDot(color: current!),
              if (current == null)
                Text(
                  '-',
                  style: theme.textTheme.titleMedium,
                ),
              SizedBox(width: 8.w),
              TextButton(
                onPressed: () => onClear(),
                child: Text(AppLocalizations.of(context)!.clear),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: _colors
                .map(
                  (c) => InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () => onSelect(c),
                    child: _ColorDot(
                      color: c,
                      selected: current != null && c.value == current!.value,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color, this.selected = false});

  final Color color;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 26.w,
      height: 26.w,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? theme.colorScheme.primary : theme.dividerColor,
          width: selected ? 2 : 1,
        ),
      ),
    );
  }
}
