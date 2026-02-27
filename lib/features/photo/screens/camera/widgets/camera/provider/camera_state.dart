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
  final PermissionType permissionType;

  const CameraPermissionDenied({required this.permissionType});
}

class CameraReady extends CameraState {
  final bool isFlashOn;
  final bool hasFlashSupport;
  final bool isTimerActive;
  final int? secondsLeft;
  final String? warningMessage;

  const CameraReady({
    this.isFlashOn = false,
    this.hasFlashSupport = true,
    this.isTimerActive = false,
    this.secondsLeft,
    this.warningMessage,
  });

  @override
  List<Object?> get props => [
    isFlashOn,
    hasFlashSupport,
    warningMessage,
    secondsLeft,
    isTimerActive,
  ];
}

class CameraFailure extends CameraState {
  final CameraErrorType errorTtype;

  const CameraFailure({required this.errorTtype});

  @override
  List<Object?> get props => [errorTtype];
}

enum CameraErrorType { noCamerasFound, initializationFailed, generic }

enum PermissionType { camera, microphone }
