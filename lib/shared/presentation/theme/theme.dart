import 'package:flutter/material.dart';

import '../providers/responsive_size/index.dart' show ResponsiveSizeCubit;
import 'text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light(ResponsiveSizeCubit responsive) {
    const seed = Color(0xFF2563EB);

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ).copyWith(
          surface: const Color(0xFFF8FAFC),
          surfaceContainer: const Color(0xFFFFFFFF),
          primary: const Color(0xFF2563EB),
          onPrimary: Colors.white,
          secondary: const Color(0xFF3B82F6),
          onSurface: const Color(0xFF111827),
          outline: const Color(0xFFE2E8F0),
          onSurfaceVariant: const Color(0xFF6B7280),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: colorScheme.surface,

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),

      textTheme: AppTextTheme.light(responsive, colorScheme),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: AppTextTheme.light(responsive, colorScheme).bodySmall
              ?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: responsive.textM,
              ),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          padding: EdgeInsets.symmetric(
            horizontal: responsive.paddingXL,
            vertical: responsive.paddingS,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsive.radiusXL),
          ),
        ),
      ),
    );
  }

  static ThemeData dark(ResponsiveSizeCubit responsive) {
    const seed = Color(0xFF2563EB);

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ).copyWith(
          surface: const Color(0xFF141414),
          surfaceContainer: const Color(0xFF1F1F1F),
          primary: const Color(0xFF3B82F6),
          onPrimary: Colors.white,
          secondary: const Color(0xFF2563EB),
          onSurface: Colors.white,
          outline: const Color(0xFF3A3A3A),
          onSurfaceVariant: const Color.fromARGB(255, 235, 235, 235),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: colorScheme.surface,

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),

      textTheme: AppTextTheme.dark(responsive, colorScheme),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: AppTextTheme.dark(responsive, colorScheme).bodySmall
              ?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: responsive.textM,
              ),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          padding: EdgeInsets.symmetric(
            horizontal: responsive.paddingXL,
            vertical: responsive.paddingS,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsive.radiusXL),
          ),
        ),
      ),
    );
  }
}
