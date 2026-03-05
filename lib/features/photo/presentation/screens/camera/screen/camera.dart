import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../shared/presentation/providers/responsive_size/index.dart';
import '../../../../../../shared/presentation/theme/index.dart' show AppTheme;
import '../../../../../../shared/presentation/widgets/index.dart'
    show MessageWithButtonView;
import '../../../provider/index.dart' show PhotoCubit;
import '../provider/index.dart';
import '../utils/camera_error_messages.dart';
import '../widgets/index.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.read<ResponsiveSizeCubit>();

    return Theme(
      data: AppTheme.dark(responsive),

      child: Scaffold(
        extendBodyBehindAppBar: true,

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              if (context.mounted) {
                final router = context.router;
                router.maybePop();
              }
            },
          ),
        ),

        body: BlocConsumer<CameraCubit, CameraState>(
          listener: (context, state) {
            _handleStateChanges(context, state);
          },

          builder: (context, state) {
            return _buildContent(context, state);
          },
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, CameraState state) {
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
  }

  Widget _buildContent(BuildContext context, CameraState state) {
    final cameraCubit = context.read<CameraCubit>();

    if (state is CameraPermissionDenied) {
      final message = state.permissionType.message;

      return MessageWithButtonView(
        message: message,
        onPressed: cameraCubit.grantPermissionInSettings,
        buttonText: 'Open Settings',
      );
    }

    if (state is CameraFailure) {
      final message = state.errorType.message;
      return MessageWithButtonView(
        message: message,
        onPressed: cameraCubit.retryInitialization,
      );
    }

    if (state is CameraPaused) {
      return const CameraPausedView();
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
        return MessageWithButtonView(
          onPressed: cameraCubit.retryInitialization,
        );
      }

      final CountDownProps countDownProps = (secondsLeft: state.secondsLeft);
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
  }
}
