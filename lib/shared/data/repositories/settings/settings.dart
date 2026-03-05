import 'package:photo_app/shared/domain/data_states/data_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart' show Talker;

import '../../../domain/enums/index.dart' show ThemeType;
import '../../../domain/models/index.dart' show SettingsModelDomain;
import '../../../domain/repositories/index.dart' show SettingsRepositoryI;
import '../../adapters/descriptor.dart';
import 'descriptors.dart';

class SettingsRepository implements SettingsRepositoryI {
  const SettingsRepository({required Talker talker, required prefs})
    : _talker = talker,
      _prefs = prefs;

  final Talker _talker;
  final SharedPreferencesAsync _prefs;

  Future<T> _readSetting<T>(Descriptor<T> descriptor) async {
    try {
      final raw = await _prefs.getString(descriptor.storageKey);
      if (raw == null) return descriptor.defaultValue;
      return descriptor.fromStorage(raw);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _writeSettingString<T>(Descriptor<T> descriptor, T value) async {
    try {
      final raw = descriptor.toStorage(value);
      await _prefs.setString(descriptor.storageKey, raw);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<DataState<SettingsModelDomain>> _updateSettings(
    SettingsModelDomain Function(SettingsModelDomain current) updater,
  ) async {
    try {
      final currentState = await getSettings();
      if (currentState is DataFailed) {
        return currentState as DataFailed<SettingsModelDomain>;
      }

      final current = currentState.data!;
      final updated = updater(current);

      if (updated.themeType != current.themeType) {
        await _writeSettingString(
          SettingsDescriptors.themeType,
          updated.themeType,
        );
      }

      return DataSuccess(data: updated);
    } catch (e) {
      _talker.error('SettingsRepository updateSettings failed: $e');
      final exception = e is Exception ? e : Exception(e.toString());
      return DataFailed(error: exception);
    }
  }

  @override
  Future<DataState<SettingsModelDomain>> getSettings() async {
    try {
      final themeMode = await _readSetting(SettingsDescriptors.themeType);

      final settings = SettingsModelDomain(themeType: themeMode);
      return DataSuccess(data: settings);
    } catch (e) {
      _talker.error('SettingsRepository getSettings failed: $e');

      final exception = e is Exception ? e : Exception(e.toString());
      return DataFailed(error: exception);
    }
  }

  @override
  Future<DataState<SettingsModelDomain>> setThemeType(ThemeType themeType) =>
      _updateSettings(
        (SettingsModelDomain current) => current.copyWith(themeType: themeType),
      );
}
