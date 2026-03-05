enum ThemeType {
  system('system'),
  light('light'),
  dark('dark');

  static ThemeType? fromTag(String tag) {
    final ThemeType? themeType = ThemeType.values
        .where((type) => type.tag == tag)
        .cast<ThemeType?>()
        .firstOrNull;

    return themeType;
  }

  final String tag;
  const ThemeType(this.tag);
}
