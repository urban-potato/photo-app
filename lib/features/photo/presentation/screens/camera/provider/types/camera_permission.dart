enum PermissionType { camera, microphone }

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
