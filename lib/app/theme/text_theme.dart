import 'package:flutter/material.dart';

import '../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;

class TTextTheme {
  TTextTheme._();

  static TextTheme lightTextTheme(ResponsiveSizeCubit responsiveSizeCubit) {
    final bodyLargeFontSize = responsiveSizeCubit.textL;
    final bodyMediumFontSize = responsiveSizeCubit.textM;
    final bodySmallFontSize = responsiveSizeCubit.textS;

    return TextTheme(
      bodySmall: const TextStyle().copyWith(
        fontSize: bodySmallFontSize,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      bodyMedium: const TextStyle().copyWith(
        fontSize: bodyMediumFontSize,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      bodyLarge: const TextStyle().copyWith(
        fontSize: bodyLargeFontSize,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    );
  }
}
