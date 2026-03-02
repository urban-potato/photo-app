import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'widgets/camera_controls.dart';
import 'widgets/countdown_display.dart';

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
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CameraControls(cameraControlsProps),
        ),

        CountdownDisplay(countDownProps),
      ],
    );
  }
}
