import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show ThemeMode;

import '../../../../domain/models/index.dart' show SettingsModelDomain;
import '../mappers/settings.dart';

class SettingsModelUI extends Equatable {
  static final defaultThemeMode = SettingsModelDomain.defaultThemeType
      .toThemeMode();

  final ThemeMode themeMode;

  const SettingsModelUI({required this.themeMode});

  @override
  List<Object?> get props => [themeMode];

  SettingsModelUI copyWith({ThemeMode? themeMode}) {
    return SettingsModelUI(themeMode: themeMode ?? this.themeMode);
  }
}
