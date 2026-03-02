import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../shared/presentation/providers/responsive_size/index.dart';

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

        _CountdownDisplay(countDownProps),
      ],
    );
  }
}

typedef CameraControlsProps = ({
  bool hasFlashSupport,
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
      :hasFlashSupport,
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
                hasFlashSupport: hasFlashSupport,
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
    required this.hasFlashSupport,
    required this.isFlashOn,
  });

  final Future<void> Function() switchFlash;
  final bool hasFlashSupport;
  final bool isFlashOn;

  @override
  Widget build(BuildContext context) {
    final onPressed = hasFlashSupport ? switchFlash : null;
    final flashColor = hasFlashSupport ? null : Colors.grey;
    final flashIcon = isFlashOn
        ? Icons.flash_on_rounded
        : Icons.flash_off_rounded;
    final responsiveSizeCubit = context.watch<ResponsiveSizeCubit>();
    final iconSize = responsiveSizeCubit.iconM;

    return IconButton(
      onPressed: onPressed,
      icon: Icon(flashIcon, size: iconSize),
      color: flashColor,
    );
  }
}

class _TakePictureButton extends StatelessWidget {
  const _TakePictureButton({required this.takePicture});

  final Future<void> Function() takePicture;

  @override
  Widget build(BuildContext context) {
    final responsiveSizeCubit = context.watch<ResponsiveSizeCubit>();
    final paddingV = responsiveSizeCubit.paddingXXXS;
    final iconSize = responsiveSizeCubit.iconXXXL;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: paddingV),
      child: IconButton(
        onPressed: () async {
          await takePicture();
        },
        icon: const Icon(Icons.camera),
        iconSize: iconSize,
      ),
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
    final responsiveSizeCubit = context.watch<ResponsiveSizeCubit>();
    final iconSize = responsiveSizeCubit.iconM;

    return IconButton(
      onPressed: () async {
        await takeTimedPicture();
      },
      icon: Icon(Icons.timer_rounded, size: iconSize, color: timerColor),
    );
  }
}

class _SwitchCameraButton extends StatelessWidget {
  const _SwitchCameraButton({required this.switchCamera});

  final Future<void> Function() switchCamera;

  @override
  Widget build(BuildContext context) {
    final responsiveSizeCubit = context.watch<ResponsiveSizeCubit>();
    final iconSize = responsiveSizeCubit.iconM;

    return IconButton(
      onPressed: switchCamera,
      icon: Icon(Icons.cameraswitch_rounded, size: iconSize),
    );
  }
}

typedef CountDownProps = ({int? secondsLeft});

class _CountdownDisplay extends StatelessWidget {
  const _CountdownDisplay(this.countDownProps);

  final CountDownProps countDownProps;

  @override
  Widget build(BuildContext context) {
    final secondsLeft = countDownProps.secondsLeft ?? 0;
    final responsiveSizeCubit = context.watch<ResponsiveSizeCubit>();
    final fontSize = responsiveSizeCubit.textHuge;

    return (secondsLeft > 0)
        ? Center(
            child: Text(
              '$secondsLeft',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
              textAlign: TextAlign.center,
            ),
          )
        : const SizedBox.shrink();
  }
}
