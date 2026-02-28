import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
    return Stack(
      children: [
        SizedBox.expand(child: CameraPreview(controller)),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _CameraControls(cameraControlsProps),
        ),

        ((countDownProps.secondsLeft ?? 0) > 0)
            ? _CountdownDisplay(countDownProps)
            : const SizedBox.shrink(),
      ],
    );
  }
}

typedef CameraControlsProps = ({
  bool hasFlash,
  bool isFlashOn,
  bool isTimerActive,
  Future<void> Function() switchFlash,
  Future<void> Function() switchCamera,
  Future<void> Function() takeTimedPicture,
  Future<void> Function() takePicture,
});

class _CameraControls extends StatelessWidget {
  const _CameraControls(this.cameraControlsProps);

  final CameraControlsProps cameraControlsProps;

  @override
  Widget build(BuildContext context) {
    final (
      :hasFlash,
      :isFlashOn,
      :isTimerActive,
      :switchFlash,
      :switchCamera,
      :takeTimedPicture,
      :takePicture,
    ) = cameraControlsProps;

    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SwitchCameraButton(switchCamera: switchCamera),
                  _TakeTimedPictureButton(
                    takeTimedPicture: takeTimedPicture,
                    isTimerActive: isTimerActive,
                  ),
                ],
              ),
            ),
          ),

          Flexible(
            flex: 1,
            child: _TakePictureButton(takePicture: takePicture),
          ),

          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _SwitchFlashButton(
                switchFlash: switchFlash,
                hasFlash: hasFlash,
                isFlashOn: isFlashOn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchFlashButton extends StatelessWidget {
  const _SwitchFlashButton({
    required this.switchFlash,
    required this.hasFlash,
    required this.isFlashOn,
  });

  final Future<void> Function() switchFlash;
  final bool hasFlash;
  final bool isFlashOn;

  @override
  Widget build(BuildContext context) {
    final onPressed = hasFlash ? switchFlash : null;
    final flashColor = hasFlash ? null : Colors.grey;
    final flashIcon = isFlashOn
        ? Icons.flash_on_rounded
        : Icons.flash_off_rounded;

    return IconButton(
      onPressed: onPressed,
      icon: Icon(flashIcon),
      color: flashColor,
    );
  }
}

class _TakePictureButton extends StatelessWidget {
  const _TakePictureButton({required this.takePicture});

  final Future<void> Function() takePicture;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: takePicture,
      icon: const Icon(Icons.camera),
      iconSize: 60,
    );
  }
}

class _TakeTimedPictureButton extends StatelessWidget {
  const _TakeTimedPictureButton({
    required this.takeTimedPicture,
    required this.isTimerActive,
  });

  final Future<void> Function() takeTimedPicture;
  final bool isTimerActive;

  @override
  Widget build(BuildContext context) {
    final timerColor = isTimerActive ? Colors.yellow : null;

    return IconButton(
      onPressed: takeTimedPicture,
      icon: Icon(Icons.timer_rounded, color: timerColor),
    );
  }
}

class _SwitchCameraButton extends StatelessWidget {
  const _SwitchCameraButton({required this.switchCamera});

  final Future<void> Function() switchCamera;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: switchCamera,
      icon: const Icon(Icons.cameraswitch_rounded),
    );
  }
}

typedef CountDownProps = ({int? secondsLeft});

class _CountdownDisplay extends StatelessWidget {
  const _CountdownDisplay(this.countDownProps);

  final CountDownProps countDownProps;

  @override
  Widget build(BuildContext context) {
    final secondsLeft = countDownProps.secondsLeft;

    return Center(
      child: Text(
        '$secondsLeft',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontWeight: FontWeight.bold,
          fontSize: 90,
        ),
      ),
    );
  }
}
