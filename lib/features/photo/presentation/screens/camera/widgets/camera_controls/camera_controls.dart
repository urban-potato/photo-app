import 'package:flutter/material.dart';

import '../../provider/index.dart' show CameraAspectRatio;
import 'widgets/index.dart';

typedef CameraControlsProps = ({
  bool hasFlashSupport,
  bool isFlashOn,
  bool isTimerActive,
  Future<void> Function() switchFlash,
  Future<void> Function() switchCamera,
  void Function(CameraAspectRatio targetAspectRatio) switchRatio,
  Future<void> Function(double targetRatio) takeTimedPicture,
  Future<void> Function(double targetRatio) takePicture,
  CameraAspectRatio currentAspectRatio,
});

class CameraControls extends StatelessWidget {
  const CameraControls(
    this.cameraControlsProps, {
    super.key,
    required this.targetRatio,
  });

  final CameraControlsProps cameraControlsProps;
  final double targetRatio;

  @override
  Widget build(BuildContext context) {
    final (
      :hasFlashSupport,
      :isFlashOn,
      :isTimerActive,
      :switchFlash,
      :switchCamera,
      :takeTimedPicture,
      :takePicture,
      :switchRatio,
      :currentAspectRatio,
    ) = cameraControlsProps;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchCameraButton(switchCamera: switchCamera),
                TakeTimedPictureButton(
                  takeTimedPicture: () async {
                    await takeTimedPicture(targetRatio);
                  },
                  isTimerActive: isTimerActive,
                ),
              ],
            ),
          ),
        ),

        TakePictureButton(
          takePicture: () async {
            await takePicture(targetRatio);
          },
        ),

        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchFlashButton(
                  switchFlash: switchFlash,
                  hasFlashSupport: hasFlashSupport,
                  isFlashOn: isFlashOn,
                ),
                SwitchRatioButton(
                  switchRatio: switchRatio,
                  currentRatio: currentAspectRatio,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
