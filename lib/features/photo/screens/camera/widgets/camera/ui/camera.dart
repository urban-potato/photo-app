import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart' show Talker;

import '../../../../../provider/index.dart' show PhotoCubit;
import '../provider/index.dart';
import 'widgets/camera_view.dart';
import 'widgets/error_state_view.dart';

class CameraWidget extends StatelessWidget {
  const CameraWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final talker = context.read<Talker>();

    return BlocProvider(
      create: (_) => CameraCubit(talker: talker),

      child: BlocConsumer<CameraCubit, CameraState>(
        listener: (context, state) {
          if (state is CameraReady) {
            final warningMessage = state.warningMessage;
            if (warningMessage == null) return;

            final messenger = ScaffoldMessenger.of(context);
            messenger.showSnackBar(SnackBar(content: Text(warningMessage)));
          }

          if (state is CameraPictureTaken && context.mounted) {
            final router = context.router;
            router.popUntil((route) => route.isFirst);
          }

          if (state is CameraPictureFailure && context.mounted) {
            final messenger = ScaffoldMessenger.of(context);
            messenger.showSnackBar(
              const SnackBar(content: Text('Failed to capture photo')),
            );
          }
        },

        builder: (context, state) {
          final cameraCubit = context.read<CameraCubit>();
          final photoCubit = context.read<PhotoCubit>();

          if (state is CameraPermissionDenied) {
            return ErrorStateView.fromPermissionDenied(
              permissionType: state.permissionType,
              onPressed: cameraCubit.grantPermissionInSettings,
            );
          }

          if (state is CameraFailure) {
            return ErrorStateView.fromCameraFailure(
              errorTtype: state.errorTtype,
              onPressed: cameraCubit.retryInitialization,
            );
          }

          if (state is CameraLoading || state is CameraInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CameraReady) {
            final isFlashOn = state.isFlashOn;
            final hasFlash = state.hasFlashSupport;
            final isTimerActive = state.isTimerActive;
            final secondsLeft = state.secondsLeft;
            final controller = cameraCubit.controller;

            if (controller == null) {
              return ErrorStateView.noController(
                onPressed: cameraCubit.retryInitialization,
              );
            }

            Future<void> savePicture(String path) async {
              await photoCubit.addPhotoPath(path);
            }

            Future<void> takeTimedPicture() async {
              await cameraCubit.takeTimedPicture(savePicture);
            }

            Future<void> takePicture() async {
              await cameraCubit.takePicture(savePicture);
            }

            final CountDownProps countDownProps = (secondsLeft: secondsLeft);
            final CameraControlsProps cameraControlsProps = (
              hasFlash: hasFlash,
              isFlashOn: isFlashOn,
              isTimerActive: isTimerActive,
              switchFlash: cameraCubit.switchFlash,
              switchCamera: cameraCubit.switchCamera,
              takeTimedPicture: takeTimedPicture,
              takePicture: takePicture,
            );

            return CameraView(
              controller: controller,
              cameraControlsProps: cameraControlsProps,
              countDownProps: countDownProps,
            );
          }

          if (state is CameraPictureTaken) {
            final picture = state.pictureFile;

            return Center(child: Image.file(picture));
          }

          return const Center(child: Text('Woops, something went wrong'));
        },
      ),
    );
  }
}
