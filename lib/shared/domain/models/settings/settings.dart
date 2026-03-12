import 'package:equatable/equatable.dart';

import '../../enums/index.dart' show ThemeType;

class SettingsModelDomain extends Equatable {
  static const defaultThemeType = ThemeType.system;

  final ThemeType themeType;

  const SettingsModelDomain({this.themeType = defaultThemeType});

  @override
  List<Object?> get props => [themeType];

  SettingsModelDomain copyWith({ThemeType? themeType}) {
    return SettingsModelDomain(themeType: themeType ?? this.themeType);
  }
}
