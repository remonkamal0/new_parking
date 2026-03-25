import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test888/core/theme/app_theme.dart';

class AppThemeProvider extends ChangeNotifier {
  static const _prefsSecondaryKey = 'theme_secondary';
  static const _prefsBackgroundKey = 'theme_background';
  static const _prefsTextKey = 'theme_text';
  static const _prefsIsDarkKey = 'theme_is_dark';
  static const Color defaultSecondary = Color(0xFF2EC4B6);
  static const Color defaultBackgroundLight = Color(0xFFF9F9F9);
  static const Color defaultBackgroundDark = Color(0xFF1E1E1E);

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  Color get primaryColor => AppTheme.primaryColor;

  Color _secondaryColor = defaultSecondary;
  Color get secondaryColor => _secondaryColor;

  Color _backgroundColorLight = defaultBackgroundLight;
  Color get backgroundColorLight => _backgroundColorLight;

  Color _backgroundColorDark = defaultBackgroundDark;
  Color get backgroundColorDark => _backgroundColorDark;

  Color? _textColor;
  Color? get textColor => _textColor;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    _themeMode = (prefs.getBool(_prefsIsDarkKey) ?? false)
        ? ThemeMode.dark
        : ThemeMode.light;



    _secondaryColor =
        Color(prefs.getInt(_prefsSecondaryKey) ?? defaultSecondary.toARGB32());

    _backgroundColorLight = Color(
      prefs.getInt(_prefsBackgroundKey) ?? defaultBackgroundLight.toARGB32(),
    );

    _textColor =
        prefs.containsKey(_prefsTextKey) ? Color(prefs.getInt(_prefsTextKey)!) : null;

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) return;

    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsIsDarkKey, mode == ThemeMode.dark);
    notifyListeners();
  }

  Future<void> updateColors({
    Color? primary,
    Color? secondary,
    Color? background,
  }) async {
    final prefs = await SharedPreferences.getInstance();



    if (secondary != null) {
      _secondaryColor = secondary;
      await prefs.setInt(_prefsSecondaryKey, secondary.toARGB32());
    }

    if (background != null) {
      _backgroundColorLight = background;
      await prefs.setInt(_prefsBackgroundKey, background.toARGB32());
    }

    notifyListeners();
  }

  Future<void> setTextColor(Color? text) async {
    if (_textColor?.value == text?.value) return;

    _textColor = text;
    final prefs = await SharedPreferences.getInstance();

    if (text == null) {
      await prefs.remove(_prefsTextKey);
    } else {
      await prefs.setInt(_prefsTextKey, text.toARGB32());
    }

    notifyListeners();
  }

  Future<void> resetToDefaults() async {
    _themeMode = ThemeMode.light;
    _secondaryColor = defaultSecondary;
    _backgroundColorLight = defaultBackgroundLight;
    _textColor = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsIsDarkKey);
    await prefs.remove(_prefsSecondaryKey);
    await prefs.remove(_prefsBackgroundKey);
    await prefs.remove(_prefsTextKey);

    notifyListeners();
  }

  ThemeData buildLightTheme(ThemeData base) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppTheme.primaryColor,
      primary: AppTheme.primaryColor,
      secondary: _secondaryColor,
      brightness: Brightness.light,
    );

    return base.copyWith(
      useMaterial3: true,
      primaryColor: AppTheme.primaryColor,
      scaffoldBackgroundColor: _backgroundColorLight,
      colorScheme: scheme,
      textTheme: _textColor == null
          ? base.textTheme
          : base.textTheme.apply(bodyColor: _textColor, displayColor: _textColor),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: _backgroundColorLight,
      ),
    );
  }

  ThemeData buildDarkTheme(ThemeData base) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppTheme.primaryColor,
      primary: AppTheme.primaryColor,
      secondary: _secondaryColor,
      brightness: Brightness.dark,
    );

    return base.copyWith(
      useMaterial3: true,
      primaryColor: AppTheme.primaryColor,
      scaffoldBackgroundColor: _backgroundColorLight,
      colorScheme: scheme,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: _backgroundColorLight,
      ),
    );
  }
}

extension on Color {
  int toARGB32() => value;
}
