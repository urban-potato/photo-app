import 'package:flutter/material.dart';

enum AppTextStyle { bodyLarge, bodyMedium, bodySmall }

extension AppTextStyleExtension on AppTextStyle {
  TextStyle? style(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return switch (this) {
      AppTextStyle.bodyLarge => textTheme.bodyLarge,
      AppTextStyle.bodyMedium => textTheme.bodyMedium,
      AppTextStyle.bodySmall => textTheme.bodySmall,
    };
  }
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
    final defaultTextColor = DefaultTextStyle.of(context).style.color;
    var style = styleType
        .style(context)
        ?.copyWith(color: color ?? defaultTextColor);

    style = style?.copyWith(
      fontSize: fontSize ?? style.fontSize,
      fontWeight: fontWeight,
      height: height,
      color: color,
    );

    return Text(text, style: style, textAlign: textAlign, overflow: overflow);
  }
}
