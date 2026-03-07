import 'package:flutter/material.dart';

import 'camera_icon_button.dart';

class SwitchCameraButton extends StatelessWidget {
  const SwitchCameraButton({super.key, required this.switchCamera});

  final Future<void> Function() switchCamera;

  @override
  Widget build(BuildContext context) {
    return CameraIconButton(
      icon: Icons.cameraswitch_rounded,
      onPressed: switchCamera,
    );
  }
}
