import 'package:flutter/material.dart' show Orientation;

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
