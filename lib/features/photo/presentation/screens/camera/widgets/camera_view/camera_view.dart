import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../camera_controls/camera_controls.dart';
import '../countdown_display/countdown_display.dart';
import 'utils/index.dart';

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

    final orientation = MediaQuery.of(context).orientation;
    final aspectRatio = controller.value.aspectRatio;
    final adjustedAspectRatio = adjustAspectRatio(
      orientation: orientation,
      aspectRatio: aspectRatio,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final previewSize = calculatePreviewSize(
          maxWidth: constraints.maxWidth,
          maxHeight: constraints.maxHeight,
          aspectRatio: adjustedAspectRatio,
        );

        return Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: SizedBox(
                height: previewSize.height,
                width: previewSize.width,
                child: CameraPreview(controller),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [const Spacer(), CameraControls(cameraControlsProps)],
            ),

            Align(
              alignment: Alignment.center,
              child: CountdownDisplay(countDownProps),
            ),
          ],
        );
      },
    );
  }
}
