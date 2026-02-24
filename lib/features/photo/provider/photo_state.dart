import 'package:equatable/equatable.dart';

abstract class PhotoState extends Equatable {
  final List<String>? photoPathsList;
  final Exception? error;

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
  const PhotoFailure({super.error});
}
