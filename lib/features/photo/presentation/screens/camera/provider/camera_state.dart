import 'dart:typed_data' show Uint8List;

import 'package:equatable/equatable.dart';

import 'types/index.dart';

sealed class CameraState extends Equatable {
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
  final CameraAspectRatio targetAspectRatio;
  final bool isBusy;

  const CameraReady({
    this.isFlashOn = false,
    this.hasFlashSupport = true,
    this.isTimerActive = false,
    this.secondsLeft,
    this.message,
    this.targetAspectRatio = CameraAspectRatio.small,
    required this.isBusy,
  });

  @override
  List<Object?> get props => [
    isFlashOn,
    hasFlashSupport,
    isTimerActive,
    secondsLeft,
    message,
    targetAspectRatio,
    isBusy,
  ];

  CameraReady copyWith({
    bool? isFlashOn,
    bool? hasFlashSupport,
    bool? isTimerActive,
    int? secondsLeft,
    String? message,
    CameraAspectRatio? targetAspectRatio,
    required bool isBusy,
  }) {
    return CameraReady(
      isFlashOn: isFlashOn ?? this.isFlashOn,
      hasFlashSupport: hasFlashSupport ?? this.hasFlashSupport,
      isTimerActive: isTimerActive ?? this.isTimerActive,
      secondsLeft: secondsLeft ?? this.secondsLeft,
      message: message,
      targetAspectRatio: targetAspectRatio ?? this.targetAspectRatio,
      isBusy: isBusy,
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
  final Uint8List bytes;

  const CameraPictureTaken({required this.bytes});

  @override
  List<Object?> get props => [bytes];
}

class CameraPictureFailure extends CameraState {
  final String? message;

  const CameraPictureFailure({this.message});
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
