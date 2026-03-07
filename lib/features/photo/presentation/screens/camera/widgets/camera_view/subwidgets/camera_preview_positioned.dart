import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../countdown_display/countdown_display.dart';
import '../utils/index.dart' show adjustAspectRatio, calculatePreviewSize;

class CameraPreviewPositioned extends StatelessWidget {
  const CameraPreviewPositioned({
    super.key,
    required this.controller,
    required this.countDownProps,
    required this.targetAspectRatio,
    required this.constraints,
    required this.orientation,
  });

  final CameraController controller;
  final CountDownProps countDownProps;
  final double targetAspectRatio;
  final BoxConstraints constraints;
  final Orientation orientation;

  @override
  Widget build(BuildContext context) {
    final previewAspect = adjustAspectRatio(
      orientation: orientation,
      aspectRatio: controller.value.aspectRatio,
    );

    final targetSize = calculatePreviewSize(
      maxWidth: constraints.maxWidth,
      maxHeight: constraints.maxHeight,
      aspectRatio: targetAspectRatio,
    );

    final targetAspect = targetSize.aspectRatio;

    final scale = previewAspect > targetAspect
        ? previewAspect / targetAspect
        : targetAspect / previewAspect;

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: targetSize.width,
        height: targetSize.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRect(
              child: Transform.scale(
                scale: scale,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: previewAspect,
                    child: CameraPreview(controller),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: CountdownDisplay(countDownProps),
            ),
          ],
        ),
      ),
    );
  }
}
