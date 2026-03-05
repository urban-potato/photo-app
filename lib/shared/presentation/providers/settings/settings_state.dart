import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show ThemeMode;

import 'models/settings.dart';

sealed class SettingsState extends Equatable {
  final SettingsModelUI settings;
  bool get isDarkMode => settings.themeMode == ThemeMode.dark;

  const SettingsState(this.settings);

  @override
  List<Object?> get props => [settings];
}

final class SettingsInitial extends SettingsState {
  SettingsInitial()
    : super(SettingsModelUI(themeMode: SettingsModelUI.defaultThemeMode));
}

final class SettingsLoading extends SettingsState {
  const SettingsLoading(super.settings);
}

final class SettingsLoaded extends SettingsState {
  const SettingsLoaded(super.settings);
}

final class SettingsFailure extends SettingsState {
  const SettingsFailure(super.settings);
}
