import 'package:flutter/material.dart';

import 'widgets/index.dart';

typedef CameraControlsProps = ({
  bool hasFlashSupport,
  bool isFlashOn,
  bool isTimerActive,
  Future<void> Function() switchFlash,
  Future<void> Function() switchCamera,
  Future<void> Function() takeTimedPicture,
  Future<void> Function() takePicture,
});

class CameraControls extends StatelessWidget {
  const CameraControls(this.cameraControlsProps, {super.key});

  final CameraControlsProps cameraControlsProps;

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
                  takeTimedPicture: takeTimedPicture,
                  isTimerActive: isTimerActive,
                ),
              ],
            ),
          ),
        ),

        TakePictureButton(takePicture: takePicture),

        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: SwitchFlashButton(
              switchFlash: switchFlash,
              hasFlashSupport: hasFlashSupport,
              isFlashOn: isFlashOn,
            ),
          ),
        ),
      ],
    );
  }
}
