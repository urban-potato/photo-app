import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../domain/data_states/data_state.dart';
import '../../../domain/repositories/index.dart' show SettingsRepositoryI;
import 'mappers/settings.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required Talker talker,
    required SettingsRepositoryI settingsRepo,
  }) : _talker = talker,
       _settingsRepo = settingsRepo,
       super(SettingsInitial()) {
    loadSettings();
  }
  final Talker _talker;
  final SettingsRepositoryI _settingsRepo;

  Future<void> loadSettings() async {
    try {
      final currentSettings = state.settings;
      emit(SettingsLoading(currentSettings));

      final dataState = await _settingsRepo.getSettings();

      switch (dataState) {
        case (DataSuccess _):
          {
            final loadedSettings = dataState.data!.toModelUI();

            emit(SettingsLoaded(loadedSettings));
            return;
          }
        case (DataFailed _):
          {
            final error = dataState.error!;
            _talker.error('SettingsCubit loadSettings Failure: $error');

            emit(SettingsFailure(currentSettings));
            return;
          }
      }
    } catch (e) {
      _talker.error('SettingsCubit loadThemeMode Failure: $e');

      final currentSettings = state.settings;
      emit(SettingsFailure(currentSettings));
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      final currentSettings = state.settings;
      emit(SettingsLoading(currentSettings));

      final dataState = await _settingsRepo.setThemeType(
        themeMode.toThemeType(),
      );

      switch (dataState) {
        case (DataSuccess _):
          {
            final newSettings = dataState.data!.toModelUI();
            emit(SettingsLoaded(newSettings));
            return;
          }
        case (DataFailed _):
          {
            final error = dataState.error!;
            _talker.error('SettingsCubit setThemeMode Failure: $error');

            emit(SettingsFailure(currentSettings));
            return;
          }
      }
    } catch (e) {
      _talker.error('SettingsCubit setThemeMode Failure: $e');

      final currentSettings = state.settings;
      emit(SettingsFailure(currentSettings));
    }
  }
}
