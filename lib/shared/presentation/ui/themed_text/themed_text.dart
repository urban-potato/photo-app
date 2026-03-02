import 'package:flutter/material.dart';

enum AppTextStyle {
  bodyLarge,
  bodyMedium,
  bodySmall,
  // labelLarge,
  // labelMedium,
  // titleMedium,
  // headlineMedium,
}

class ThemedText extends StatelessWidget {
  const ThemedText({
    super.key,
    required this.text,
    required this.styleType,
    this.textAlign,
    this.fontSize,
    this.fontWeight,
    this.overflow,
    this.height,
    this.color,
  });

  final String text;
  final AppTextStyle styleType;
  final TextAlign? textAlign;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    TextStyle? style;

    switch (styleType) {
      case AppTextStyle.bodyLarge:
        style = textTheme.bodyLarge;
        break;
      case AppTextStyle.bodyMedium:
        style = textTheme.bodyMedium;
        break;
      case AppTextStyle.bodySmall:
        style = textTheme.bodySmall;
        break;
      // case AppTextStyle.labelLarge:
      //   style = textTheme.labelLarge;
      //   break;
      // case AppTextStyle.labelMedium:
      //   style = textTheme.labelMedium;
      //   break;
      // case AppTextStyle.titleMedium:
      //   style = textTheme.titleMedium;
      //   break;
      // case AppTextStyle.headlineMedium:
      //   style = textTheme.headlineMedium;
      //   break;
    }

    style = style?.copyWith(
      fontSize: fontSize ?? style.fontSize,
      fontWeight: fontWeight,
      height: height,
      color: color,
    );

    return Text(text, style: style, textAlign: textAlign, overflow: overflow);
  }
}
