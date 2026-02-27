import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../provider/index.dart' show PhotoCubit;
import '../provider/index.dart';

class CameraWidget extends StatelessWidget {
  const CameraWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CameraCubit(),
      child: BlocConsumer<CameraCubit, CameraState>(
        listener: (context, state) {
          if (state is CameraReady && state.warningMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.warningMessage!)));
          }
        },
        builder: (context, state) {
          if (state is CameraPermissionDenied) {
            final permissionName = switch (state.permissionType) {
              PermissionType.camera => 'camera',
              PermissionType.microphone => 'microphone',
            };
            final message =
                'To use this feature, the app needs access to your $permissionName. Please enable $permissionName access in the app settings';
            final buttonText = 'Open App Settings';
            Future<void> onPressed() async {
              final cubit = context.read<CameraCubit>();
              await cubit.grantPermissionInSettings();
            }

            return _ErrorStateView(
              message: message,
              buttonText: buttonText,
              onPressed: onPressed,
            );
          }

          if (state is CameraFailure) {
            final message = switch (state.errorTtype) {
              CameraErrorType.noCamerasFound => 'No cameras found',
              CameraErrorType.initializationFailed =>
                'Error initializing camera. Please try again',
              CameraErrorType.generic =>
                'Something went wrong. Try again later',
            };
            return _ErrorStateView(message: message);
          }

          if (state is CameraLoading || state is CameraInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CameraReady) {
            final isFlashOn = state.isFlashOn;
            final hasFlash = state.hasFlashSupport;
            final isTimerActive = state.isTimerActive;
            final secondsLeft = state.secondsLeft;
            final cubit = context.read<CameraCubit>();
            final controller = cubit.controller;

            if (controller == null) {
              return const _ErrorStateView();
            }

            return _CameraView(
              controller: controller,
              isTimerActive: isTimerActive,
              hasFlash: hasFlash,
              isFlashOn: isFlashOn,
              seconds: secondsLeft,
            );
          }

          return const Center(child: Text('Woops, something went wrong'));
        },
      ),
    );
  }
}

class _CameraView extends StatelessWidget {
  const _CameraView({
    required this.controller,
    required this.isTimerActive,
    required this.hasFlash,
    required this.isFlashOn,
    required this.seconds,
  });

  final CameraController controller;
  final bool isTimerActive;
  final bool hasFlash;
  final bool isFlashOn;
  final int? seconds;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(child: CameraPreview(controller)),
        _CameraControls(
          isTimerActive: isTimerActive,
          hasFlash: hasFlash,
          isFlashOn: isFlashOn,
        ),

        ((seconds ?? 0) > 0)
            ? _CountdownDisplay(seconds: seconds)
            : const SizedBox.shrink(),
      ],
    );
  }
}

class _CountdownDisplay extends StatelessWidget {
  const _CountdownDisplay({required this.seconds});

  final int? seconds;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$seconds',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontWeight: FontWeight.bold,
          fontSize: 80,
        ),
      ),
    );
  }
}

class _CameraControls extends StatelessWidget {
  const _CameraControls({
    required this.hasFlash,
    required this.isFlashOn,
    required this.isTimerActive,
  });

  final bool hasFlash;
  final bool isFlashOn;
  final bool isTimerActive;

  @override
  Widget build(BuildContext context) {
    final cameraCubit = context.read<CameraCubit>();
    final timerColor = isTimerActive ? Colors.yellow : null;
    final flashColor = hasFlash ? null : Colors.grey;
    final flashIcon = isFlashOn
        ? Icons.flash_on_rounded
        : Icons.flash_off_rounded;

    void savePicture(String path) {
      if (context.mounted) {
        context.read<PhotoCubit>().addPhotoPath(path);
      }
    }

    Future<void> switchCamera() async {
      await cameraCubit.switchCamera();
    }

    Future<void> takeTimedPicture() async {
      await cameraCubit.takeTimedPicture(savePicture);

      if (context.mounted) {
        context.router.pop();
      }
    }

    Future<void> takePicture() async {
      await cameraCubit.takePicture(savePicture);

      if (context.mounted) {
        context.router.pop();
      }
    }

    Future<void> switchFlash() async {
      await cameraCubit.switchFlash();
    }

    final onPressedFlashIcon = hasFlash ? switchFlash : null;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: DecoratedBox(
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
                    IconButton(
                      onPressed: switchCamera,
                      icon: const Icon(Icons.cameraswitch_rounded),
                    ),
                    IconButton(
                      onPressed: takeTimedPicture,
                      icon: Icon(Icons.timer_rounded, color: timerColor),
                    ),
                  ],
                ),
              ),
            ),

            Flexible(
              flex: 1,
              child: IconButton(
                onPressed: takePicture,
                icon: const Icon(Icons.camera),
                iconSize: 60,
              ),
            ),

            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: onPressedFlashIcon,
                  icon: Icon(flashIcon),
                  color: flashColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorStateView extends StatelessWidget {
  const _ErrorStateView({
    this.message = 'Woops, something went wrong',
    this.buttonText = 'Retry',
    this.onPressed,
  });

  final String message;
  final String buttonText;
  final Future<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    Future<void> retryInit() async {
      final cubit = context.read<CameraCubit>();
      await cubit.retryInitialization();
    }

    final action = onPressed ?? retryInit;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          spacing: 24,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(onPressed: action, child: Text(buttonText)),
          ],
        ),
      ),
    );
  }
}
