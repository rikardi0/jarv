import 'package:flutter/material.dart';

class CustomThemeData {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2E5CAB),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD8E2FF),
    onPrimaryContainer: Color(0xFF001A42),
    secondary: Color(0xFFA53B2A),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFDAD4),
    onSecondaryContainer: Color(0xFF400200),
    tertiary: Color(0xFF4D6700),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFCAF16C),
    onTertiaryContainer: Color(0xFF151F00),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFF3F3F3),
    onBackground: Color(0xFF1B1B1F),
    surface: Color(0xFFFEFBFF),
    onSurface: Color(0xFF1B1B1F),
    surfaceVariant: Color(0xFFE1E2EC),
    onSurfaceVariant: Color(0xFF44474F),
    outline: Color(0xFF75777F),
    onInverseSurface: Color(0xFFF2F0F4),
    inverseSurface: Color(0xFF303034),
    inversePrimary: Color(0xFFAEC6FF),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF2E5CAB),
    outlineVariant: Color(0xFFC5C6D0),
    scrim: Color(0xFF000000),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFAEC6FF),
    onPrimary: Color(0xFF002E6A),
    primaryContainer: Color(0xFF084492),
    onPrimaryContainer: Color(0xFFD8E2FF),
    secondary: Color(0xFFFFB4A7),
    onSecondary: Color(0xFF650B03),
    secondaryContainer: Color(0xFF852315),
    onSecondaryContainer: Color(0xFFFFDAD4),
    tertiary: Color(0xFFAED453),
    onTertiary: Color(0xFF273500),
    tertiaryContainer: Color(0xFF394D00),
    onTertiaryContainer: Color(0xFFCAF16C),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF1B1B1F),
    onBackground: Color(0xFFE3E2E6),
    surface: Color(0xFF1B1B1F),
    onSurface: Color(0xFFE3E2E6),
    surfaceVariant: Color(0xFF44474F),
    onSurfaceVariant: Color(0xFFC5C6D0),
    outline: Color(0xFF8E9099),
    onInverseSurface: Color(0xFF1B1B1F),
    inverseSurface: Color(0xFFE3E2E6),
    inversePrimary: Color(0xFF2E5CAB),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFAEC6FF),
    outlineVariant: Color(0xFF44474F),
    scrim: Color(0xFF000000),
  );
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: lightColorScheme.background,
        ),
        colorScheme: lightColorScheme,
        datePickerTheme: DatePickerThemeData(
            rangePickerHeaderBackgroundColor: lightColorScheme.primary,
            rangePickerHeaderForegroundColor: lightColorScheme.onPrimary),
        cardColor: lightColorScheme.background,
        listTileTheme: ListTileThemeData(
          selectedColor: lightColorScheme.onPrimary,
        ));
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: darkColorScheme.background,
        ),
        datePickerTheme: DatePickerThemeData(
            rangePickerHeaderBackgroundColor: darkColorScheme.primary,
            rangePickerHeaderForegroundColor: darkColorScheme.onPrimary),
        listTileTheme: ListTileThemeData(
          selectedColor: darkColorScheme.onPrimary,
        ));
  }
}
