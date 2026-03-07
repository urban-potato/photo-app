import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../provider/index.dart' show CameraAspectRatio;
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
                  child: _CameraPreviewPositioned(
                    controller: controller,
                    countDownProps: countDownProps,
                    targetAspectRatio: targetAspectRatio,
                    constraints: constraints,
                    orientation: orientation,
                  ),
                ),

                _CameraControlsPositioned(
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

class _CameraControlsPositioned extends StatelessWidget {
  const _CameraControlsPositioned({
    required this.cameraControlsProps,
    required this.constraints,
    required this.orientation,
    required this.targetAspectRatio,
  });

  final CameraControlsProps cameraControlsProps;
  final BoxConstraints constraints;
  final Orientation orientation;
  final double targetAspectRatio;

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
      child: CameraControls(
        cameraControlsProps,
        targetRatio: targetAspectRatio,
      ),
    );
  }
}

class _CameraPreviewPositioned extends StatelessWidget {
  const _CameraPreviewPositioned({
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
