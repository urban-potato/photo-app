enum CameraErrorType { noCamerasFound, initializationFailed, generic }

extension CameraErrorTypeMessage on CameraErrorType {
  String get message => switch (this) {
    CameraErrorType.noCamerasFound => 'No cameras found',
    CameraErrorType.initializationFailed =>
      'Error initializing camera. Please try again',
    CameraErrorType.generic => 'Something went wrong. Try again later',
  };
}
