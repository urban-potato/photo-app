import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../provider/index.dart';
import '../../countdown_display/countdown_display.dart';
import '../utils/index.dart' show adjustAspectRatio, calculatePreviewSize;

typedef CameraPreviewProps = ({
  bool isCameraReady,
  CameraAspectRatio? aspectRatio,
  int? secondsLeft,
});

class CameraPreviewPositioned extends StatelessWidget {
  const CameraPreviewPositioned({
    super.key,
    required this.constraints,
    required this.orientation,
    required this.cameraPreviewProps,
  });

  final BoxConstraints constraints;
  final Orientation orientation;
  final CameraPreviewProps cameraPreviewProps;

  @override
  Widget build(BuildContext context) {
    final (:isCameraReady, :aspectRatio, :secondsLeft) = cameraPreviewProps;

    if (!isCameraReady) {
      return const Center(child: CircularProgressIndicator());
    } else {
      final camera = context.read<CameraCubit>();
      final controller = camera.controller;

      if (controller == null) {
        return const SizedBox.shrink();
      }
      if (aspectRatio == null) {
        return const SizedBox.shrink();
      }

      final CountDownProps countDownProps = (secondsLeft: secondsLeft);

      final targetAspectRatio = orientation == Orientation.portrait
          ? aspectRatio.portrait
          : aspectRatio.landscape;

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
}
