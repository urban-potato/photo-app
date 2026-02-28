import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/data_state/data_state.dart';
import '../../../shared/repositories/photo_repository.dart';
import 'photo_state.dart';

class PhotoCubit extends Cubit<PhotoState> {
  PhotoCubit({required PhotoRepositoryI photoRepository})
    : _photoRepository = photoRepository,
      super(const PhotoInitial());

  final PhotoRepositoryI _photoRepository;

  bool _isBusy = false;

  Future<void> loadPhotoPaths() async {
    if (_isBusy) return;
    _isBusy = true;

    final photoPathsList = state.photoPathsList;
    emit(PhotoLoading(photoPathsList: photoPathsList));

    final dataState = await _photoRepository.getAllPhotoPaths();
    if (isClosed) {
      _isBusy = false;
      return;
    }

    switch (dataState) {
      case (DataSuccess _):
        {
          _isBusy = false;
          emit(PhotoLoaded(photoPathsList: dataState.data));
          return;
        }
      case (DataFailed _):
        {
          final error = (dataState as DataFailed).error;
          final typedError = TypedError(
            type: PhotoErrorType.load,
            error: error,
          );

          _isBusy = false;
          emit(PhotoFailure(error: typedError, photoPathsList: photoPathsList));
          return;
        }
    }
  }

  Future<void> addPhotoPath(String photoPath) async {
    if (_isBusy) return;
    _isBusy = true;

    final photoPathsList = state.photoPathsList;
    emit(PhotoLoading(photoPathsList: photoPathsList));

    final dataState = await _photoRepository.savePhotoPath(photoPath);
    if (isClosed) {
      _isBusy = false;
      return;
    }

    switch (dataState) {
      case (DataSuccess _):
        {
          _isBusy = false;
          emit(PhotoLoaded(photoPathsList: dataState.data));
          return;
        }
      case (DataFailed _):
        {
          final error = (dataState as DataFailed).error;
          final typedError = TypedError(
            type: PhotoErrorType.save,
            error: error,
          );

          _isBusy = false;
          emit(PhotoFailure(error: typedError, photoPathsList: photoPathsList));
          return;
        }
    }
  }

  Future<bool> deletePhotoPath(String photoPath) async {
    if (_isBusy) return false;
    _isBusy = true;

    final photoPathsList = state.photoPathsList;
    emit(PhotoLoading(photoPathsList: photoPathsList));

    final dataState = await _photoRepository.deletePhotoPath(photoPath);
    if (isClosed) {
      _isBusy = false;
      return false;
    }

    switch (dataState) {
      case (DataSuccess _):
        {
          _isBusy = false;
          emit(PhotoLoaded(photoPathsList: dataState.data));
          return true;
        }
      case (DataFailed _):
        {
          final error = (dataState as DataFailed).error;
          final typedError = TypedError(
            type: PhotoErrorType.delete,
            error: error,
          );

          _isBusy = false;
          emit(PhotoFailure(error: typedError, photoPathsList: photoPathsList));
          return false;
        }
    }
  }
}
