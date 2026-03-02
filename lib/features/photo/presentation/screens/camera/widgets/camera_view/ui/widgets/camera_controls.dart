import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;

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
