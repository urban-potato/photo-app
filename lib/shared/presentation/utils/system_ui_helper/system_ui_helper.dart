import 'dart:ui' show Brightness;

import 'package:flutter/material.dart' show ColorScheme;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

SystemUiOverlayStyle getUpdatedSystemUiStyle(
  Brightness brightness,
  ColorScheme colorScheme,
) {
  final isDarkTheme = brightness == Brightness.dark;
  final iconBrightness = isDarkTheme ? Brightness.light : Brightness.dark;
  final barColor = colorScheme.surface;

  return SystemUiOverlayStyle(
    statusBarColor: barColor,
    systemNavigationBarColor: barColor,
    systemNavigationBarDividerColor: barColor,

    systemStatusBarContrastEnforced: false,
    systemNavigationBarContrastEnforced: false,

    statusBarBrightness: iconBrightness,
    statusBarIconBrightness: iconBrightness,
    systemNavigationBarIconBrightness: iconBrightness,
  );
}
