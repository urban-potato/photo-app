import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/data_state/data_state.dart';
import '../../../shared/repositories/photo_repository.dart';
import 'photo_state.dart';

class PhotoCubit extends Cubit<PhotoState> {
  PhotoCubit({required PhotoRepositoryI photoRepository})
    : _photoRepository = photoRepository,
      super(const PhotoInitial());

  final PhotoRepositoryI _photoRepository;

  Future<void> loadPhotoPaths() async {
    final photoPathsList = state.photoPathsList;
    emit(PhotoLoading(photoPathsList: photoPathsList));
    final dataState = await _photoRepository.getAllPhotoPaths();
    if (isClosed) return;

    switch (dataState) {
      case (DataSuccess _):
        {
          emit(PhotoLoaded(photoPathsList: dataState.data));
          return;
        }
      case (DataFailed _):
        {
          final error = (dataState as DataFailed).error;
          emit(PhotoFailure(error: error));
          return;
        }
    }
  }

  Future<void> addPhotoPath(String photoPath) async {
    final photoPathsList = state.photoPathsList;
    emit(PhotoLoading(photoPathsList: photoPathsList));
    final dataState = await _photoRepository.savePhotoPath(photoPath);
    if (isClosed) return;

    switch (dataState) {
      case (DataSuccess _):
        {
          emit(PhotoLoaded(photoPathsList: dataState.data));
          return;
        }
      case (DataFailed _):
        {
          final error = (dataState as DataFailed).error;
          emit(PhotoFailure(error: error));
          return;
        }
    }
  }

  Future<void> deletePhotoPath(String photoPath) async {
    final photoPathsList = state.photoPathsList;
    emit(PhotoLoading(photoPathsList: photoPathsList));
    final dataState = await _photoRepository.deletePhotoPath(photoPath);
    if (isClosed) return;

    switch (dataState) {
      case (DataSuccess _):
        {
          emit(PhotoLoaded(photoPathsList: dataState.data));
          return;
        }
      case (DataFailed _):
        {
          final error = (dataState as DataFailed).error;
          emit(PhotoFailure(error: error));
          return;
        }
    }
  }
}
