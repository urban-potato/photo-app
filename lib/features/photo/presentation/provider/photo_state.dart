import 'package:equatable/equatable.dart';

import '../models/index.dart' show PhotoModelUI;
import 'types/index.dart';

sealed class PhotoState extends Equatable {
  final PhotoModelUI? photos;
  final TypedError? error;

  const PhotoState({this.photos, this.error});

  @override
  List<Object?> get props => [photos, error];
}

class PhotoInitial extends PhotoState {
  const PhotoInitial();
}

class PhotoLoading extends PhotoState {
  const PhotoLoading({super.photos});
}

class PhotoLoaded extends PhotoState {
  const PhotoLoaded({required super.photos});
}

class PhotoFailure extends PhotoState {
  const PhotoFailure({required super.error, super.photos});
}
