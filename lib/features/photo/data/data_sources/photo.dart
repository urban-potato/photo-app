import 'dart:io' show File, Directory;
import 'dart:typed_data' show Uint8List;

import 'package:path_provider/path_provider.dart';
import 'package:talker_flutter/talker_flutter.dart' show Talker;

import '../../../../shared/domain/data_states/data_state.dart';
import '../utils/crop_image_helper.dart';

class PhotoDataSource {
  const PhotoDataSource({required this.talker});

  static const photosSubDir = 'photos';

  final Talker talker;

  Future<DataState<File>> savePhoto(
    Uint8List bytes,
    double targetAspectRatio,
  ) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final appDir = await getApplicationDocumentsDirectory();
      final photosDir = Directory('${appDir.path}/$photosSubDir');
      final isDirExists = await photosDir.exists();

      if (!isDirExists) {
        await photosDir.create(recursive: true);
      }

      final croppedBytes = await cropImageToRatio(bytes, targetAspectRatio);

      final path = '${photosDir.path}/$timestamp.jpg';
      final file = File(path);
      final result = await file.writeAsBytes(croppedBytes);

      return DataSuccess(data: result);
    } catch (e) {
      talker.error('PhotoRepository Failed to savePhoto: $e');

      final exeption = e is Exception ? e : Exception(e.toString());
      return DataFailed(error: exeption);
    }
  }

  Future<DataState<String>> deletePhoto(String path) async {
    try {
      final file = File(path);
      final result = await file.delete(recursive: true);

      return DataSuccess(data: result.path);
    } catch (e) {
      talker.error('PhotoRepository Failed to deletePhoto: $e');

      final exeption = e is Exception ? e : Exception(e.toString());
      return DataFailed(error: exeption);
    }
  }
}
