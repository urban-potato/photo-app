import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../shared/presentation/widgets/index.dart'
    show MessageWithButtonView;
import '../../../../provider/index.dart';
import '../../provider/index.dart';
import '../camera_controls/camera_controls.dart' show CameraControlsProps;
import '../camera_paused_view/camera_paused_view.dart';
import '../camera_view/camera_view.dart';
import '../camera_view/utils/index.dart' show getNewTargetAspectRatio;
import '../camera_view/subwidgets/index.dart' show CameraPreviewProps;

class CameraContentBuilder extends StatelessWidget {
  const CameraContentBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CameraCubit, CameraState>(
      listener: (context, state) => _handleStateChanges(context, state),
      builder: (context, state) => _buildContent(context, state),
    );
  }

  void _handleStateChanges(BuildContext context, CameraState state) {
    if (state is CameraReady) {
      final warningMessage = state.message;
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
  }

  Widget _buildContent(BuildContext context, CameraState state) {
    final cameraCubit = context.read<CameraCubit>();
    final controller = cameraCubit.controller;

    if (state is CameraReady &&
        (controller == null || !controller.value.isInitialized)) {
      return MessageWithButtonView(onPressed: cameraCubit.retryInitialization);
    } else if (state is CameraPermissionDenied) {
      final message = state.permissionType.message;

      return MessageWithButtonView(
        message: message,
        onPressed: cameraCubit.grantPermissionInSettings,
        buttonText: 'Open Settings',
      );
    } else if (state is CameraFailure) {
      final message = state.errorType.message;
      return MessageWithButtonView(
        message: message,
        onPressed: cameraCubit.retryInitialization,
      );
    } else if (state is CameraPaused ||
        state is CameraReadyPaused ||
        state is CameraClosed) {
      return const CameraPausedView();
    } else if (state is CameraLoading || state is CameraInitial) {
      return OrientationBuilder(
        builder: (context, orientation) {
          final CameraControlsProps cameraControlsProps = (
            hasFlashSupport: false,
            isFlashOn: false,
            isTimerActive: false,
            switchFlash: null,
            switchCamera: null,
            takeTimedPicture: null,
            takePicture: null,
            switchRatio: null,
          );

          final CameraPreviewProps cameraPreviewProps = (
            isCameraReady: false,
            aspectRatio: null,
            secondsLeft: null,
          );

          return CameraView(
            cameraControlsProps: cameraControlsProps,
            orientation: orientation,
            cameraPreviewProps: cameraPreviewProps,
          );
        },
      );
    } else if (state is CameraReady) {
      return OrientationBuilder(
        builder: (context, orientation) {
          final cameraCubit = context.read<CameraCubit>();

          final targetAspectRatio = state.targetAspectRatio;

          final targetAspectRatioNum = orientation == Orientation.portrait
              ? targetAspectRatio.portrait
              : targetAspectRatio.landscape;

          final CameraControlsProps cameraControlsProps = (
            hasFlashSupport: state.hasFlashSupport,
            isFlashOn: state.isFlashOn,
            isTimerActive: state.isTimerActive,
            switchFlash: cameraCubit.switchFlash,
            switchCamera: cameraCubit.switchCamera,
            takeTimedPicture: () async {
              await cameraCubit.takeTimedPicture(targetAspectRatioNum);
            },
            takePicture: () async {
              await cameraCubit.takePicture(targetAspectRatioNum);
            },
            switchRatio: () async {
              final newAspectRatio = getNewTargetAspectRatio(targetAspectRatio);
              await cameraCubit.switchRatio(newAspectRatio);
            },
          );

          final CameraPreviewProps cameraPreviewProps = (
            isCameraReady: true,
            aspectRatio: targetAspectRatio,
            secondsLeft: state.secondsLeft,
          );

          return CameraView(
            cameraControlsProps: cameraControlsProps,
            orientation: orientation,
            cameraPreviewProps: cameraPreviewProps,
          );
        },
      );
    } else if (state is CameraPictureTaken) {
      final picture = state.pictureFile;

      return Center(child: Image.file(picture));
    } else if (state is CameraPictureFailure) {
      return const Center(child: Text('Woops, something went wrong'));
    }

    return MessageWithButtonView(onPressed: cameraCubit.retryInitialization);
  }
}
