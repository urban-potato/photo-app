import 'dart:typed_data' show Uint8List;

import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferencesAsync;
import 'package:talker_flutter/talker_flutter.dart' show Talker;

import '../../../../shared/domain/data_states/data_state.dart';
import '../../domain/models/index.dart'
    show PhotoModelDomain, PhotoItemModelDomain;
import '../../domain/repositories/photo.dart';
import '../../domain/services/index.dart' show ExifServiceI;
import '../data_sources/photo.dart';

class PhotoRepository implements PhotoRepositoryI {
  const PhotoRepository({
    required SharedPreferencesAsync preferencesAsync,
    required PhotoDataSource photoDataSource,
    required Talker talker,
    required ExifServiceI exifService,
  }) : _talker = talker,
       _prefs = preferencesAsync,
       _photoDataSource = photoDataSource,
       _exifService = exifService;

  static const storageKey = 'photoPaths';

  final Talker _talker;
  final SharedPreferencesAsync _prefs;
  final PhotoDataSource _photoDataSource;
  final ExifServiceI _exifService;

  @override
  Future<DataState<PhotoModelDomain>> getAllPhotoPaths() async {
    try {
      final photoPathsList = await _prefs.getStringList(storageKey) ?? [];

      final List<PhotoItemModelDomain> photosList = [];

      for (final path in photoPathsList) {
        final dateTime = await _exifService.getCreationDate(path);

        photosList.add(PhotoItemModelDomain(path: path, dateTime: dateTime));
      }

      final photoModel = PhotoModelDomain(photosList: photosList);
      return DataSuccess(data: photoModel);
    } catch (e) {
      _talker.error('PhotoRepository Failed to getAllPhotoPaths: $e');

      final exeption = e is Exception ? e : Exception(e.toString());
      return DataFailed(error: exeption);
    }
  }

  @override
  Future<DataState<PhotoModelDomain>> savePhoto(
    Uint8List bytes,
    double targetAspectRatio,
  ) async {
    try {
      final dataState = await _photoDataSource.savePhoto(
        bytes,
        targetAspectRatio,
      );

      switch (dataState) {
        case (DataSuccess _):
          {
            final file = dataState.data!;
            final path = file.path;

            final photoPathsList = await _prefs.getStringList(storageKey) ?? [];
            photoPathsList.add(path);
            await _prefs.setStringList(storageKey, photoPathsList);

            final newPhotosDataState = await getAllPhotoPaths();

            if (newPhotosDataState is DataSuccess) {
              return DataSuccess(data: newPhotosDataState.data!);
            }

            final exeption = dataState.error!;
            _talker.error(
              'PhotoRepository Failed to getAppPhotos after savePhoto: $exeption',
            );

            return DataFailed(error: exeption);
          }
        case (DataFailed _):
          {
            final exeption = dataState.error!;
            _talker.error('PhotoRepository Failed to savePhoto: $exeption');

            return DataFailed(error: exeption);
          }
      }
    } catch (e) {
      _talker.error('PhotoRepository Failed to savePhotoPath: $e');

      final exeption = e is Exception ? e : Exception(e.toString());
      return DataFailed(error: exeption);
    }
  }

  @override
  Future<DataState<PhotoModelDomain>> deletePhoto(String path) async {
    try {
      final dataState = await _photoDataSource.deletePhoto(path);

      switch (dataState) {
        case (DataSuccess _):
          {
            final deletedPath = dataState.data!;

            final photoPathsList = await _prefs.getStringList(storageKey) ?? [];
            final isRemoved = photoPathsList.remove(deletedPath);

            if (isRemoved) {
              await _prefs.setStringList(storageKey, photoPathsList);

              final newPhotosDataState = await getAllPhotoPaths();

              if (newPhotosDataState is DataSuccess) {
                return DataSuccess(data: newPhotosDataState.data!);
              }

              final exeption = dataState.error!;
              _talker.error(
                'PhotoRepository Failed to getAppPhotos after savePhoto: $exeption',
              );

              return DataFailed(error: exeption);
            } else {
              _talker.warning(
                'PhotoRepository Failed to deletePhotoPath from prefs: Path not found',
              );
              return DataFailed(error: Exception('Path not found'));
            }
          }
        case (DataFailed _):
          {
            final exeption = dataState.error!;
            _talker.error('PhotoRepository Failed to deletePhoto: $exeption');

            return DataFailed(error: exeption);
          }
      }
    } catch (e) {
      _talker.error('PhotoRepository Failed to deletePhotoPath: $e');

      final exeption = e is Exception ? e : Exception(e.toString());
      return DataFailed(error: exeption);
    }
  }
}
