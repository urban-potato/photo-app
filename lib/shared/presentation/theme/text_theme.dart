import 'package:flutter/material.dart';

import '../providers/responsive_size/index.dart' show ResponsiveSizeCubit;

class AppTextTheme {
  AppTextTheme._();

  static TextTheme light(
    ResponsiveSizeCubit responsive,
    ColorScheme colorScheme,
  ) {
    final base = Typography.material2021().black;

    return base.copyWith(
      bodySmall: base.bodySmall?.copyWith(
        fontSize: responsive.textS,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: responsive.textM,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: responsive.textL,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
    );
  }

  static TextTheme dark(
    ResponsiveSizeCubit responsive,
    ColorScheme colorScheme,
  ) {
    final base = Typography.material2021().white;

    return base.copyWith(
      bodySmall: base.bodySmall?.copyWith(
        fontSize: responsive.textS,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: responsive.textM,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: responsive.textL,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
    );
  }
}
