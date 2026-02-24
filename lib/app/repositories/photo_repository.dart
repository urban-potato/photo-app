import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferencesAsync;

import '../../shared/data_state/data_state.dart';
import '../../shared/repositories/photo_repository.dart';

class PhotoRepository implements PhotoRepositoryI {
  const PhotoRepository({required SharedPreferencesAsync preferencesAsync})
    : _prefs = preferencesAsync;

  final SharedPreferencesAsync _prefs;

  @override
  Future<DataState<List<String>>> getAllPhotoPaths() async {
    try {
      final photoPathsList = await _prefs.getStringList('photoPaths') ?? [];
      return DataSuccess(data: photoPathsList);
    } catch (e) {
      final exeption = e is Exception ? e : Exception(e.toString());
      return DataFailed(error: exeption);
    }
  }

  @override
  Future<DataState<List<String>>> savePhotoPath(String path) async {
    try {
      final photoPathsList = await _prefs.getStringList('photoPaths') ?? [];
      photoPathsList.add(path);
      await _prefs.setStringList('photoPaths', photoPathsList);
      return DataSuccess(data: photoPathsList);
    } catch (e) {
      final exeption = e is Exception ? e : Exception(e.toString());
      return DataFailed(error: exeption);
    }
  }

  @override
  Future<DataState<List<String>>> deletePhotoPath(String path) async {
    try {
      final photoPathsList = await _prefs.getStringList('photoPaths') ?? [];
      final result = photoPathsList.remove(path);

      if (result) {
        await _prefs.setStringList('photoPaths', photoPathsList);
        return DataSuccess(data: photoPathsList);
      } else {
        return DataFailed(error: Exception('Path not found'));
      }
    } catch (e) {
      final exeption = e is Exception ? e : Exception(e.toString());
      return DataFailed(error: exeption);
    }
  }
}
