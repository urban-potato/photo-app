import 'package:flutter/material.dart';

import '../../../provider/index.dart';
import '../../camera_controls/camera_controls.dart';
import '../utils/index.dart' show calculatePreviewSize;

class CameraControlsPositioned extends StatelessWidget {
  const CameraControlsPositioned({
    super.key,
    required this.constraints,
    required this.orientation,
    required this.cameraControlsProps,
  });

  final BoxConstraints constraints;
  final Orientation orientation;
  final CameraControlsProps cameraControlsProps;

  @override
  Widget build(BuildContext context) {
    final biggestAspectRatio = orientation == Orientation.portrait
        ? CameraAspectRatio.big.portrait
        : CameraAspectRatio.big.landscape;

    final biggestSize = calculatePreviewSize(
      maxWidth: constraints.maxWidth,
      maxHeight: constraints.maxHeight,
      aspectRatio: biggestAspectRatio,
    );

    final maxHeight = constraints.maxHeight;
    final bottomOffset = (maxHeight - biggestSize.height) / 2;

    return Positioned(
      bottom: bottomOffset,
      left: 0,
      right: 0,
      child: CameraControls(cameraControlsProps),
    );
  }
}
