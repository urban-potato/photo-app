import 'package:flutter/material.dart';

import '../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;
import 'text_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme(ResponsiveSizeCubit responsive) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.orange,
        brightness: Brightness.light,
      ),
      primaryColor: Colors.orange,
      scaffoldBackgroundColor: Colors.white,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: TTextTheme.lightTextTheme(responsive),
    );
  }
}
