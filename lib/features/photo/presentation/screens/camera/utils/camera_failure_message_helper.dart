import '../provider/index.dart' show CameraErrorType;

String getCameraFailureErrorMessage(CameraErrorType errorType) {
  final message = switch (errorType) {
    CameraErrorType.noCamerasFound => 'No cameras found',
    CameraErrorType.initializationFailed =>
      'Error initializing camera. Please try again',
    CameraErrorType.generic => 'Something went wrong. Try again later',
  };

  return message;
}
