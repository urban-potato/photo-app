// import 'package:camera/camera.dart';
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
  final bool isFlashOn;
  final bool hasFlashSupport;
  final String? warningMessage;

  const CameraReady({
    this.isFlashOn = false,
    this.hasFlashSupport = true,
    this.warningMessage,
  });

  @override
  List<Object?> get props => [isFlashOn, hasFlashSupport, warningMessage];
}

class CameraFailure extends CameraState {
  final CameraErrorType errorTtype;

  const CameraFailure({required this.errorTtype});

  @override
  List<Object?> get props => [errorTtype];
}

enum CameraErrorType { noCamerasFound, initializationFailed, generic }
