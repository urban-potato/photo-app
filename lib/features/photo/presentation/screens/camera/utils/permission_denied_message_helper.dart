import '../provider/index.dart' show PermissionType;

String getPermissionDeniedMessage(PermissionType permissionType) {
  final permissionName = switch (permissionType) {
    PermissionType.camera => 'camera',
    PermissionType.microphone => 'microphone',
  };
  final message =
      'To use this feature, the app needs access to your $permissionName. Please enable $permissionName access in the app settings';

  return message;
}
