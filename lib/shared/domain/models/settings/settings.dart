import '../../enums/index.dart' show ThemeType;

class SettingsModelDomain {
  static const defaultThemeType = ThemeType.system;

  final ThemeType themeType;

  const SettingsModelDomain({this.themeType = defaultThemeType});

  SettingsModelDomain copyWith({ThemeType? themeType}) {
    return SettingsModelDomain(themeType: themeType ?? this.themeType);
  }
}
