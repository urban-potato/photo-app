import 'package:flutter/material.dart';

import '../camera_controls/camera_controls.dart' show CameraControlsProps;
import 'subwidgets/index.dart';

class CameraView extends StatelessWidget {
  const CameraView({
    super.key,
    required this.cameraControlsProps,
    required this.orientation,
    required this.cameraPreviewProps,
  });

  final CameraControlsProps cameraControlsProps;
  final CameraPreviewProps cameraPreviewProps;
  final Orientation orientation;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.center,
              child: CameraPreviewPositioned(
                constraints: constraints,
                orientation: orientation,
                cameraPreviewProps: cameraPreviewProps,
              ),
            ),

            CameraControlsPositioned(
              constraints: constraints,
              orientation: orientation,
              cameraControlsProps: cameraControlsProps,
            ),
          ],
        );
      },
    );
  }
}
