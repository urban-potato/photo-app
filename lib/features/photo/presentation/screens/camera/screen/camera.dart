import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../provider/index.dart' show PhotoCubit;
import '../provider/index.dart';
import '../widgets/camera_view.dart';
import '../widgets/error_state_view.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('New photo'),
        elevation: 0,
        backgroundColor:
            theme.appBarTheme.backgroundColor?.withValues(alpha: 0.3) ??
            Colors.black.withValues(alpha: 0.3),
      ),
      body: BlocConsumer<CameraCubit, CameraState>(
        listener: (context, state) {
          if (state is CameraReady) {
            final warningMessage = state.warningMessage;
            if (warningMessage == null) return;

            final messenger = ScaffoldMessenger.of(context);
            messenger.showSnackBar(SnackBar(content: Text(warningMessage)));
          }

          if (state is CameraPictureTaken && context.mounted) {
            final photoCubit = context.read<PhotoCubit>();
            final router = context.router;

            router.popUntil((route) => route.isFirst);
            photoCubit.loadPhotoPaths();
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

          if (state is CameraPictureTaken) {
            final picture = state.pictureFile;

            return Center(child: Image.file(picture));
          }

          if (state is CameraReady) {
            final controller = cameraCubit.controller;

            if (controller == null) {
              return ErrorStateView.noController(
                onPressed: cameraCubit.retryInitialization,
              );
            }

            final CountDownProps countDownProps = (
              secondsLeft: state.secondsLeft,
            );
            final CameraControlsProps cameraControlsProps = (
              hasFlashSupport: state.hasFlashSupport,
              isFlashOn: state.isFlashOn,
              isTimerActive: state.isTimerActive,
              switchFlash: cameraCubit.switchFlash,
              switchCamera: cameraCubit.switchCamera,
              takeTimedPicture: cameraCubit.takeTimedPicture,
              takePicture: cameraCubit.takePicture,
            );

            return CameraView(
              controller: controller,
              cameraControlsProps: cameraControlsProps,
              countDownProps: countDownProps,
            );
          }

          return const Center(child: Text('Woops, something went wrong'));
        },
      ),
    );
  }
}
