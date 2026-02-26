import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../provider/index.dart' show PhotoCubit;
import '../provider/index.dart';

class CameraWidget extends StatelessWidget {
  const CameraWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return BlocProvider(
      create: (_) => CameraCubit(),
      child: BlocBuilder<CameraCubit, CameraState>(
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
            return Stack(
              children: [
                SizedBox.expand(child: CameraPreview(state.controller)),
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
                                  onPressed: () => context
                                      .read<CameraCubit>()
                                      .switchCamera(),
                                  icon: const Icon(Icons.cameraswitch_rounded),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.timer_rounded),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Flexible(
                          flex: 1,
                          child: IconButton(
                            onPressed: () async {
                              final cubit = context.read<CameraCubit>();
                              final path = await cubit.takePicture();

                              if (path != null && context.mounted) {
                                context.read<PhotoCubit>().addPhotoPath(path);
                                if (context.mounted) {
                                  context.router.pop();
                                }
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
                              onPressed: () {},
                              icon: const Icon(Icons.flash_on_rounded),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('Woops, something went wrong'));
        },
      ),
    );
  }
}
