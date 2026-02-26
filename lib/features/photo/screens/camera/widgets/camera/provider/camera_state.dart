import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object?> get props => [];
}

class CameraInitial extends CameraState {
  const CameraInitial();
}

class CameraLoading extends CameraState {
  const CameraLoading();
}

class CameraPermissionDenied extends CameraState {
  const CameraPermissionDenied();
}

class CameraReady extends CameraState {
  final CameraController controller;

  const CameraReady({required this.controller});

  @override
  List<Object?> get props => [controller];
}

class CameraFailure extends CameraState {
  final CameraErrorType errorTtype;

  const CameraFailure({required this.errorTtype});

  @override
  List<Object?> get props => [errorTtype];
}

enum CameraErrorType { noCamerasFound, initializationFailed, generic }
