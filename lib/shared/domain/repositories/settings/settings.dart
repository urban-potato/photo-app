import '../../data_states/data_state.dart';
import '../../enums/index.dart' show ThemeType;
import '../../models/index.dart' show SettingsModelDomain;

abstract interface class SettingsRepositoryI {
  Future<DataState<SettingsModelDomain>> getSettings();
  Future<DataState<SettingsModelDomain>> setThemeType(ThemeType themeType);
}
