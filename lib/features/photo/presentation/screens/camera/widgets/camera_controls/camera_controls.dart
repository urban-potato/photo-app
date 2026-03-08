import 'package:flutter/material.dart';

import 'widgets/index.dart';

typedef CameraControlsProps = ({
  bool hasFlashSupport,
  bool isFlashOn,
  bool isTimerActive,
  Future<void> Function()? switchFlash,
  Future<void> Function()? switchCamera,
  void Function()? switchRatio,
  Future<void> Function()? takeTimedPicture,
  Future<void> Function()? takePicture,
  bool isBusy,
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
      :switchRatio,
      :isBusy,
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
                SwitchCameraButton(switchCamera: isBusy ? null : switchCamera),
                TakeTimedPictureButton(
                  takeTimedPicture: isBusy ? null : takeTimedPicture,
                  isTimerActive: isTimerActive,
                ),
              ],
            ),
          ),
        ),

        TakePictureButton(takePicture: isBusy ? null : takePicture),

        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchFlashButton(
                  switchFlash: isBusy ? null : switchFlash,
                  hasFlashSupport: hasFlashSupport,
                  isFlashOn: isFlashOn,
                ),
                SwitchRatioButton(switchRatio: isBusy ? null : switchRatio),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
