import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'widgets/camera_controls/index.dart';
import 'widgets/countdown_display/countdown_display.dart';

class CameraView extends StatelessWidget {
  const CameraView({
    super.key,
    required this.controller,
    required this.cameraControlsProps,
    required this.countDownProps,
  });

  final CameraController controller;
  final CameraControlsProps cameraControlsProps;
  final CountDownProps countDownProps;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(child: CameraPreview(controller)),
        CameraControls(cameraControlsProps),
        CountdownDisplay(countDownProps),
      ],
    );
  }
}
