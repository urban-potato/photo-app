import 'dart:async' show Completer, TimeoutException;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart' show Lock;
import 'package:talker_flutter/talker_flutter.dart' show Talker;

import '../camera_state.dart';

abstract interface class CameraLifecycleHost {
  bool get isRequestingPermission;
  int get selectedIndex;
  CameraState get state;
  bool get isCapturing;
  Completer<void>? get captureCompleter;
  Talker get talker;

  Future<void> disposeController();
  Future<void> setupCamera(int index);
  void safeEmit(CameraState state);
}

mixin CameraLifecycleMixin
    implements CameraLifecycleHost, WidgetsBindingObserver {
  bool _permissionDialogCausedPause = false;
  bool _isHandlingPause = false;
  final Lock _lifecycleLock = Lock(reentrant: true);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log('didChangeAppLifecycleState');

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      log('didChangeAppLifecycleState 1');
      _handlePause();
    } else if (state == AppLifecycleState.resumed) {
      log('didChangeAppLifecycleState 2');
      _handleResume();
    }
  }

  Future<void> _handlePause() async {
    return await _lifecycleLock.synchronized(() async {
      if (state is CameraPaused || state is CameraClosed || _isHandlingPause) {
        log('_handlePause: skipped because already paused or handling');
        return;
      }

      _isHandlingPause = true;
      log('_handlePause: starting');

      if (isCapturing && captureCompleter != null) {
        try {
          await captureCompleter?.future.timeout(const Duration(seconds: 5));
        } on TimeoutException {
          talker.warning('Capture completer timed out during pause');
        }
      }

      if (isRequestingPermission) {
        _permissionDialogCausedPause = true;
      }

      log('_handlePause');

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
        log(
          '_handlePause currentState is NOT CameraReady or CameraReadyPaused',
        );
        safeEmit(const CameraPaused());
      }

      log('_handlePause disposeController');

      await disposeController();
      _isHandlingPause = false;

      log('_handlePause: completed');
    });
  }

  Future<void> _handleResume() async {
    return await _lifecycleLock.synchronized(() async {
      if (_permissionDialogCausedPause) {
        _permissionDialogCausedPause = false;
        return;
      }

      log('_handleResume: starting');

      if (isCapturing && captureCompleter != null) {
        try {
          await captureCompleter?.future.timeout(const Duration(seconds: 5));
        } on TimeoutException {
          talker.warning('Capture completer timed out during resume');
        }
      }

      await setupCamera(selectedIndex);
      _isHandlingPause = false;

      log('_handleResume: completed');
    });
  }
}
