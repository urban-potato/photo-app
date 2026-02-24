import '../data_state/data_state.dart';

abstract interface class PhotoRepositoryI {
  Future<DataState<List<String>>> getAllPhotoPaths();
  Future<DataState<List<String>>> savePhotoPath(String path);
  Future<DataState<List<String>>> deletePhotoPath(String path);
}
