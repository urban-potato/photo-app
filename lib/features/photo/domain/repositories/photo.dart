import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;

import '../../../../shared/data_state/data_state.dart';

abstract interface class PhotoRepositoryI {
  Future<DataState<List<String>>> getAllPhotoPaths();
  Future<DataState<File>> savePhoto(Uint8List bytes);
  Future<DataState<String>> deletePhoto(String path);
}
