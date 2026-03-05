import '../../../domain/enums/index.dart' show ThemeType;
import '../../../domain/models/index.dart' show SettingsModelDomain;
import '../../adapters/descriptor.dart';
import '../../constants/settings_storage_keys.dart';

abstract class SettingsDescriptors {
  static final themeType = Descriptor<ThemeType>(
    storageKey: SettingsStorageKey.themeType.value,
    defaultValue: SettingsModelDomain.defaultThemeType,
    fromStorage: (String tag) {
      final themeType = ThemeType.fromTag(tag);
      if (themeType == null) {
        throw Exception('Unknown ThemeType from storage');
      }
      return themeType;
    },
    toStorage: (ThemeType type) => type.tag,
  );
}
