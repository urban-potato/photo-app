import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synchronized/synchronized.dart';

import '../../../../shared/domain/data_states/data_state.dart';
import '../../domain/repositories/photo.dart';
import '../mappers/index.dart' show PhotoModelDomainExtension;
import 'photo_state.dart';
import 'types/index.dart';

class PhotoCubit extends Cubit<PhotoState> {
  PhotoCubit({required PhotoRepositoryI photoRepository})
    : _photoRepository = photoRepository,
      super(const PhotoInitial());

  final PhotoRepositoryI _photoRepository;

  final Lock _lock = Lock();

  Future<void> deletePhoto(String photoPath) async {
    return await _lock.synchronized(() async {
      final photos = state.photos;
      emit(PhotoLoading(photos: photos));

      final dataState = await _photoRepository.deletePhoto(photoPath);
      if (isClosed) return;

      if (dataState is DataSuccess) {
        final photos = dataState.data!.toModelUi();
        emit(PhotoLoaded(photos: photos));
      } else {
        final error = dataState.error;
        final typedError = TypedError(
          type: PhotoErrorType.delete,
          error: error,
        );

        emit(PhotoFailure(error: typedError, photos: photos));
      }
    });
  }

  Future<void> loadPhotoPaths() async {
    return await _lock.synchronized(() async {
      await _loadPhotoPaths();
    });
  }

  Future<void> _loadPhotoPaths() async {
    final photos = state.photos;
    emit(PhotoLoading(photos: photos));

    final dataState = await _photoRepository.getAllPhotoPaths();
    if (isClosed) return;

    if (dataState is DataSuccess) {
      final modelUi = dataState.data?.toModelUi();
      emit(PhotoLoaded(photos: modelUi));
    } else {
      final error = dataState.error;
      final typedError = TypedError(type: PhotoErrorType.load, error: error);

      emit(PhotoFailure(error: typedError, photos: photos));
    }
  }
}
