import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferencesAsync;
import 'package:talker_flutter/talker_flutter.dart' show Talker;

import '../../shared/data_state/data_state.dart';
import '../../shared/repositories/photo_repository.dart';

class PhotoRepository implements PhotoRepositoryI {
  const PhotoRepository({
    required SharedPreferencesAsync preferencesAsync,
    required this.talker,
  }) : _prefs = preferencesAsync;

  static const storageKey = 'photoPaths';

  final Talker talker;
  final SharedPreferencesAsync _prefs;

  @override
  Future<DataState<List<String>>> getAllPhotoPaths() async {
    try {
      final photoPathsList = await _prefs.getStringList(storageKey) ?? [];
      return DataSuccess(data: photoPathsList);
    } catch (e) {
      talker.error('PhotoRepository Failed to getAllPhotoPaths: $e');

      final exeption = e is Exception ? e : Exception(e.toString());
      return DataFailed(error: exeption);
    }
  }

  @override
  Future<DataState<List<String>>> savePhotoPath(String path) async {
    try {
      final photoPathsList = await _prefs.getStringList(storageKey) ?? [];
      photoPathsList.add(path);
      await _prefs.setStringList(storageKey, photoPathsList);
      return DataSuccess(data: photoPathsList);
    } catch (e) {
      talker.error('PhotoRepository Failed to savePhotoPath: $e');

      final exeption = e is Exception ? e : Exception(e.toString());
      return DataFailed(error: exeption);
    }
  }

  @override
  Future<DataState<List<String>>> deletePhotoPath(String path) async {
    try {
      final photoPathsList = await _prefs.getStringList(storageKey) ?? [];
      final result = photoPathsList.remove(path);

      if (result) {
        await _prefs.setStringList(storageKey, photoPathsList);
        return DataSuccess(data: photoPathsList);
      } else {
        talker.warning(
          'PhotoRepository Failed to deletePhotoPath: Path not found',
        );
        return DataFailed(error: Exception('Path not found'));
      }
    } catch (e) {
      talker.error('PhotoRepository Failed to deletePhotoPath: $e');

      final exeption = e is Exception ? e : Exception(e.toString());
      return DataFailed(error: exeption);
    }
  }
}
