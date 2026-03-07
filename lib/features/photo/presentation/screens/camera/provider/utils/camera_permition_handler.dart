import 'package:permission_handler/permission_handler.dart';

import '../types/index.dart' show PermissionType;

class CameraPermissionHandler {
  Future<PermissionType?> requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    if (!cameraStatus.isGranted) {
      return PermissionType.camera;
    }

    final audioStatus = await Permission.microphone.request();
    if (!audioStatus.isGranted) {
      return PermissionType.microphone;
    }

    return null;
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }
}
