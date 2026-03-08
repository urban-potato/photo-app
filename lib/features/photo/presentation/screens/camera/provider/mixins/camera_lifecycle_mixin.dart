import 'dart:async' show Completer;
import 'dart:developer';

import 'package:flutter/material.dart';

import '../camera_state.dart';

abstract class CameraLifecycleHost {
  bool get isRequestingPermission;
  int get selectedIndex;
  dynamic get state;
  bool get isCapturing;
  Completer<void>? get captureCompleter;

  Future<void> disposeController();
  Future<void> setupCamera(int index);
  void safeEmit(CameraState state);
}

mixin CameraLifecycleMixin
    implements CameraLifecycleHost, WidgetsBindingObserver {
  bool _permissionDialogCausedPause = false;
  bool _isHandlingPause = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log('didChangeAppLifecycleState');

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      log('didChangeAppLifecycleState 1');
      _handlePause();
    } else if (state == AppLifecycleState.resumed) {
      log('didChangeAppLifecycleState 2');
      _handleResume();
    }
  }

  Future<void> _handlePause() async {
    if (state is CameraPaused || state is CameraClosed || _isHandlingPause) {
      return;
    }

    _isHandlingPause = true;

    if (isRequestingPermission) {
      _permissionDialogCausedPause = true;
    }

    log('_handlePause');

    if (isCapturing && captureCompleter != null) {
      await captureCompleter?.future;
    }

    final currentState = state;
    if (currentState is CameraReady) {
      log('_handlePause currentState is CameraReady');
      safeEmit(
        CameraReadyPaused(
          hasFlashSupport: currentState.hasFlashSupport,
          isFlashOn: currentState.isFlashOn,
          targetAspectRatio: currentState.targetAspectRatio,
        ),
      );
    } else if (currentState is CameraReadyPaused) {
      log('_handlePause currentState is CameraReadyPaused');
      safeEmit(
        CameraReadyPaused(
          hasFlashSupport: currentState.hasFlashSupport,
          isFlashOn: currentState.isFlashOn,
          targetAspectRatio: currentState.targetAspectRatio,
        ),
      );
    } else {
      log('_handlePause currentState is NOT CameraReady');
      safeEmit(const CameraPaused());
    }

    log('_handlePause disposeController');

    await disposeController();
    _isHandlingPause = false;
  }

  Future<void> _handleResume() async {
    if (_permissionDialogCausedPause) {
      _permissionDialogCausedPause = false;
      return;
    }

    log('_handleResume');

    if (isCapturing && captureCompleter != null) {
      await captureCompleter?.future;
    }

    await setupCamera(selectedIndex);
    _isHandlingPause = false;
  }
}
