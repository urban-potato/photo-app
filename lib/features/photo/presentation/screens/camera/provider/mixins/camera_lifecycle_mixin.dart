import 'package:flutter/material.dart';

import '../camera_cubit.dart';
import '../camera_state.dart';

mixin CameraLifecycleMixin on CameraCubit {
  bool _permissionDialogCausedPause = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _handlePause();
    } else if (state == AppLifecycleState.resumed) {
      _handleResume();
    }
  }

  Future<void> _handlePause() async {
    if (isRequestingPermission) {
      _permissionDialogCausedPause = true;
    }

    final currentState = state;
    if (currentState is CameraReady) {
      safeEmit(
        CameraReadyPaused(
          hasFlashSupport: currentState.hasFlashSupport,
          isFlashOn: currentState.isFlashOn,
          targetAspectRatio: currentState.targetAspectRatio,
        ),
      );
    } else {
      safeEmit(const CameraPaused());
    }

    await disposeController();
  }

  Future<void> _handleResume() async {
    if (_permissionDialogCausedPause) {
      _permissionDialogCausedPause = false;
      return;
    }

    await setupCamera(selectedIndex);
  }
}
