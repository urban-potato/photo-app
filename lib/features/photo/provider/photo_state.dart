import 'package:equatable/equatable.dart';

abstract class PhotoState extends Equatable {
  final List<String>? photoPathsList;
  final TypedError? error;

  const PhotoState({this.photoPathsList, this.error});

  @override
  List<Object?> get props => [photoPathsList, error];
}

class PhotoInitial extends PhotoState {
  const PhotoInitial();
}

class PhotoLoading extends PhotoState {
  const PhotoLoading({super.photoPathsList});
}

class PhotoLoaded extends PhotoState {
  const PhotoLoaded({required super.photoPathsList});
}

class PhotoFailure extends PhotoState {
  const PhotoFailure({required super.error, super.photoPathsList});
}

class PhotoDeleteSuccess extends PhotoState {
  const PhotoDeleteSuccess({required super.photoPathsList});
}

class TypedError {
  final PhotoErrorType type;
  final Exception? error;

  TypedError({required this.type, required this.error});
}

enum PhotoErrorType { load, save, delete }
