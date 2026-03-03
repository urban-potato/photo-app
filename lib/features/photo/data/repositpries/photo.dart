import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;

import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferencesAsync;
import 'package:talker_flutter/talker_flutter.dart' show Talker;

import '../../../../shared/domain/data_states/data_state.dart';
import '../../domain/repositories/photo.dart';
import '../data_sources/photo.dart';

class PhotoRepository implements PhotoRepositoryI {
  const PhotoRepository({
    required SharedPreferencesAsync preferencesAsync,
    required PhotoDataSource photoDataSource,
    required this.talker,
  }) : _prefs = preferencesAsync,
       _photoDataSource = photoDataSource;

  static const storageKey = 'photoPaths';

  final Talker talker;
  final SharedPreferencesAsync _prefs;
  final PhotoDataSource _photoDataSource;

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
  Future<DataState<File>> savePhoto(Uint8List bytes) async {
    try {
      final dataState = await _photoDataSource.savePhoto(bytes);

      switch (dataState) {
        case (DataSuccess _):
          {
            final file = dataState.data!;
            final path = file.path;

            final photoPathsList = await _prefs.getStringList(storageKey) ?? [];
            photoPathsList.add(path);
            await _prefs.setStringList(storageKey, photoPathsList);

            return DataSuccess(data: file);
          }
        case (DataFailed _):
          {
            final exeption = dataState.error!;
            talker.error('PhotoRepository Failed to savePhoto: $exeption');

            return DataFailed(error: exeption);
          }
      }
    } catch (e) {
      talker.error('PhotoRepository Failed to savePhotoPath: $e');

      final exeption = e is Exception ? e : Exception(e.toString());
      return DataFailed(error: exeption);
    }
  }

  @override
  Future<DataState<String>> deletePhoto(String path) async {
    try {
      final dataState = await _photoDataSource.deletePhoto(path);

      switch (dataState) {
        case (DataSuccess _):
          {
            final deletedPath = dataState.data!;

            final photoPathsList = await _prefs.getStringList(storageKey) ?? [];
            final result = photoPathsList.remove(deletedPath);

            if (result) {
              await _prefs.setStringList(storageKey, photoPathsList);
              return DataSuccess(data: deletedPath);
            } else {
              talker.warning(
                'PhotoRepository Failed to deletePhotoPath: Path not found',
              );
              return DataFailed(error: Exception('Path not found'));
            }
          }
        case (DataFailed _):
          {
            final exeption = dataState.error!;
            talker.error('PhotoRepository Failed to deletePhoto: $exeption');

            return DataFailed(error: exeption);
          }
      }
    } catch (e) {
      talker.error('PhotoRepository Failed to deletePhotoPath: $e');

      final exeption = e is Exception ? e : Exception(e.toString());
      return DataFailed(error: exeption);
    }
  }
}
