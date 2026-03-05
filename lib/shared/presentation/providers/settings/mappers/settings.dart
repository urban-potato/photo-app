import 'package:flutter/material.dart' show ThemeMode;

import '../../../../domain/enums/index.dart' show ThemeType;
import '../../../../domain/models/index.dart' show SettingsModelDomain;
import '../models/settings.dart' show SettingsModelUI;

extension AppSettingsDomainExtension on SettingsModelDomain {
  SettingsModelUI toModelUI() {
    return SettingsModelUI(themeMode: themeType.toThemeMode());
  }
}

extension ThemeTypeExtension on ThemeType {
  ThemeMode toThemeMode() {
    return switch (this) {
      ThemeType.system => ThemeMode.system,
      ThemeType.light => ThemeMode.light,
      ThemeType.dark => ThemeMode.dark,
    };
  }
}

extension ThemeModeExtension on ThemeMode {
  ThemeType toThemeType() {
    return switch (this) {
      ThemeMode.system => ThemeType.system,
      ThemeMode.light => ThemeType.light,
      ThemeMode.dark => ThemeType.dark,
    };
  }
}
