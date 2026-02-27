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
            return Center(
              child: Column(
                spacing: 24,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Please grant camera permission',
                    style: TextStyle(fontSize: 18),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<CameraCubit>().retryInitialization(),
                    child: const Text('Grant camera permission'),
                  ),
                ],
              ),
            );
          }

          if (state is CameraLoading || state is CameraInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CameraFailure) {
            final message = switch (state.errorTtype) {
              CameraErrorType.noCamerasFound => 'No cameras found',
              CameraErrorType.initializationFailed =>
                'Error initializing camera. Please try again',
              CameraErrorType.generic =>
                'Something went wrong. Try again later',
            };
            return Center(child: Text(message));
          }

          if (state is CameraReady) {
            final flashIcon = state.isFlashOn
                ? Icons.flash_on_rounded
                : Icons.flash_off_rounded;
            final hasFlash = state.hasFlashSupport;
            final flashColor = hasFlash ? null : Colors.grey;

            final cubit = context.read<CameraCubit>();
            final controller = cubit.controller;
            final seconds = state.secondsLeft;
            // final isTimerActive = state.isTimerActive;
            final timerColor = state.isTimerActive ? Colors.yellow : null;

            void savePicture(String path) {
              if (context.mounted) {
                context.read<PhotoCubit>().addPhotoPath(path);
              }
            }

            if (controller == null) {
              return const Center(child: Text('Woops, something went wrong'));
            }

            return Stack(
              children: [
                SizedBox.expand(child: CameraPreview(controller)),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
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
                                  onPressed: () async {
                                    await context
                                        .read<CameraCubit>()
                                        .switchCamera();
                                  },
                                  icon: const Icon(Icons.cameraswitch_rounded),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await cubit.takeTimedPicture(savePicture);

                                    if (context.mounted) {
                                      context.router.pop();
                                    }
                                  },
                                  icon: Icon(
                                    Icons.timer_rounded,
                                    color: timerColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Flexible(
                          flex: 1,
                          child: IconButton(
                            onPressed: () async {
                              await cubit.takePicture(savePicture);

                              if (context.mounted) {
                                context.router.pop();
                              }
                            },
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
                              onPressed: hasFlash
                                  ? () async {
                                      await context
                                          .read<CameraCubit>()
                                          .switchFlash();
                                    }
                                  : null,
                              icon: Icon(flashIcon),
                              color: flashColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ((seconds ?? 0) > 0)
                    ? Center(
                        child: Text(
                          '$seconds',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontWeight: FontWeight.bold,
                            fontSize: 80,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            );
          }

          return const Center(child: Text('Woops, something went wrong'));
        },
      ),
    );
  }
}
