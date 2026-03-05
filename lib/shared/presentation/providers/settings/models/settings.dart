import 'package:flutter/material.dart' show ThemeMode;

import '../../../../domain/models/index.dart' show SettingsModelDomain;
import '../mappers/settings.dart';

class SettingsModelUI {
  static final defaultThemeMode = SettingsModelDomain.defaultThemeType
      .toThemeMode();

  final ThemeMode themeMode;

  const SettingsModelUI({required this.themeMode});

  SettingsModelUI copyWith({ThemeMode? themeMode}) {
    return SettingsModelUI(themeMode: themeMode ?? this.themeMode);
  }
}
