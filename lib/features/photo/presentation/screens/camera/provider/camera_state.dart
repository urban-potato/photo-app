// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io' show File;

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

  @override
  List<Object?> get props => [permissionType];
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
    isTimerActive,
    secondsLeft,
    warningMessage,
  ];
}

class CameraFailure extends CameraState {
  final CameraErrorType errorType;

  const CameraFailure({required this.errorType});

  @override
  List<Object?> get props => [errorType];
}

class CameraPictureTaken extends CameraState {
  final File pictureFile;

  const CameraPictureTaken({required this.pictureFile});

  @override
  List<Object?> get props => [pictureFile];
}

class CameraPictureFailure extends CameraState {
  const CameraPictureFailure();
}

enum CameraErrorType { noCamerasFound, initializationFailed, generic }

enum PermissionType { camera, microphone }
