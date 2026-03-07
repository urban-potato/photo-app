import 'dart:io' show File;

import 'package:equatable/equatable.dart';

import 'enums/camera_aspect_ratio.dart';

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
  final String? message;
  final CameraAspectRatio targetAspectRatioPortrait;

  const CameraReady({
    this.isFlashOn = false,
    this.hasFlashSupport = true,
    this.isTimerActive = false,
    this.secondsLeft,
    this.message,
    this.targetAspectRatioPortrait = CameraAspectRatio.small,
  });

  @override
  List<Object?> get props => [
    isFlashOn,
    hasFlashSupport,
    isTimerActive,
    secondsLeft,
    message,
    targetAspectRatioPortrait,
  ];

  CameraReady copyWith({
    bool? isFlashOn,
    bool? hasFlashSupport,
    bool? isTimerActive,
    int? secondsLeft,
    String? warningMessage,
    CameraAspectRatio? targetAspectRatio,
  }) {
    return CameraReady(
      isFlashOn: isFlashOn ?? this.isFlashOn,
      hasFlashSupport: hasFlashSupport ?? this.hasFlashSupport,
      isTimerActive: isTimerActive ?? this.isTimerActive,
      secondsLeft: secondsLeft ?? this.secondsLeft,
      message: warningMessage,
      targetAspectRatioPortrait: targetAspectRatio ?? targetAspectRatioPortrait,
    );
  }
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

class CameraReadyPaused extends CameraState {
  final bool isFlashOn;
  final bool hasFlashSupport;
  final CameraAspectRatio targetAspectRatio;

  const CameraReadyPaused({
    required this.isFlashOn,
    required this.hasFlashSupport,
    required this.targetAspectRatio,
  });

  @override
  List<Object?> get props => [isFlashOn, hasFlashSupport, targetAspectRatio];
}

class CameraPaused extends CameraState {
  const CameraPaused();
}

class CameraClosed extends CameraState {
  const CameraClosed();
}

enum CameraErrorType { noCamerasFound, initializationFailed, generic }

enum PermissionType { camera, microphone }
