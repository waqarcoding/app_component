import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // -------------------------------------------------
  // GRAYSCALE
  // -------------------------------------------------
  static const gray50 = Color(0xFFFAFAFA);
  static const gray100 = Color(0xFFF5F5F5);
  static const gray200 = Color(0xFFE5E5E5);
  static const gray300 = Color(0xFFD4D4D4);
  static const gray400 = Color(0xFFA3A3A3);
  static const gray500 = Color(0xFF737373);
  static const gray600 = Color(0xFF525252);
  static const gray700 = Color(0xFF404040);
  static const gray800 = Color(0xFF262626);
  static const gray900 = Color(0xFF1A1A1A);

  static final ThemeData light = FlexThemeData.light(
    scheme: FlexScheme.deepBlue,
    primary: Colors.blue,
    surface: Colors.white,
    onSurface: gray600,
    secondary: Colors.white,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 15,
    tabBarStyle: FlexTabBarStyle.forBackground,
    useMaterial3: true,
  );

  static final ThemeData dark = FlexThemeData.dark(
    scheme: FlexScheme.deepBlue,
    primary: Colors.blue.shade300, // slightly lighter for dark theme
    surface: Color(0xFF1F1F1F), // dark surface
    onSurface: gray300, // light gray text on dark background
    secondary: Colors.blueGrey.shade700, // secondary accent
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 15,
    tabBarStyle: FlexTabBarStyle.forBackground,
    useMaterial3: true,
  );
}
