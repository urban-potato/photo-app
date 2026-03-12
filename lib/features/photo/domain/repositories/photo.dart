import 'dart:typed_data' show Uint8List;

import '../../../../shared/domain/data_states/data_state.dart';
import '../models/index.dart' show PhotoModelDomain;

abstract interface class PhotoRepositoryI {
  Future<DataState<PhotoModelDomain>> getAllPhotoPaths();
  Future<DataState<PhotoModelDomain>> savePhoto(
    Uint8List bytes,
    double targetAspectRatio,
  );
  Future<DataState<PhotoModelDomain>> deletePhoto(String path);
}
