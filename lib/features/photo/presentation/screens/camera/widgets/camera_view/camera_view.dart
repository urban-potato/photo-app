import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../camera_controls/camera_controls.dart';
import '../countdown_display/countdown_display.dart';
import 'subwidgets/index.dart';

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
    if (!controller.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return OrientationBuilder(
      builder: (context, orientation) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final targetAspectRatio = orientation == Orientation.portrait
                ? cameraControlsProps.currentAspectRatio.portrait
                : cameraControlsProps.currentAspectRatio.landscape;

            return Stack(
              fit: StackFit.expand,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CameraPreviewPositioned(
                    controller: controller,
                    countDownProps: countDownProps,
                    targetAspectRatio: targetAspectRatio,
                    constraints: constraints,
                    orientation: orientation,
                  ),
                ),

                CameraControlsPositioned(
                  cameraControlsProps: cameraControlsProps,
                  constraints: constraints,
                  orientation: orientation,
                  targetAspectRatio: targetAspectRatio,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
