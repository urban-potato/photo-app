import '../provider/index.dart' show CameraErrorType, PermissionType;

extension CameraErrorTypeMessage on CameraErrorType {
  String get message => switch (this) {
    CameraErrorType.noCamerasFound => 'No cameras found',
    CameraErrorType.initializationFailed =>
      'Error initializing camera. Please try again',
    CameraErrorType.generic => 'Something went wrong. Try again later',
  };
}

extension PermissionTypeMessage on PermissionType {
  String get message {
    final name = switch (this) {
      PermissionType.camera => 'camera',
      PermissionType.microphone => 'microphone',
    };
    return 'To use this feature, the app needs access to your $name. '
        'Please enable $name access in the app settings';
  }
}
