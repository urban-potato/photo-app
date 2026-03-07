import 'package:flutter/material.dart' show Orientation;

import '../../../provider/types/index.dart' show CameraAspectRatio;

double adjustAspectRatio({
  required Orientation orientation,
  required double aspectRatio,
}) {
  if (orientation == Orientation.portrait && aspectRatio > 1) {
    return 1 / aspectRatio;
  } else if (orientation == Orientation.landscape && aspectRatio < 1) {
    return 1 / aspectRatio;
  }

  return aspectRatio;
}

CameraAspectRatio getNewTargetAspectRatio(CameraAspectRatio currentRatio) {
  final cameraRatios = CameraAspectRatio.values;
  final currentRatioIndex = currentRatio.index;
  final incrementedRatioIndex = currentRatioIndex + 1;
  final newRationIndex = incrementedRatioIndex >= cameraRatios.length
      ? 0
      : incrementedRatioIndex;
  final newTargetAspectRatio = cameraRatios[newRationIndex];
  return newTargetAspectRatio;
}
