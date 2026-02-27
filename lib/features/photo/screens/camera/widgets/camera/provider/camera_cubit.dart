import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> with WidgetsBindingObserver {
  static const int countDownSeconds = 3;
  static const int countDownPeriod = 1;

  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _selectedIndex = 0;
  bool _hasFlashSupport = true;

  CameraController? get controller => _controller;

  CameraCubit() : super(const CameraInitial()) {
    WidgetsBinding.instance.addObserver(this);
    _setupCamera(_selectedIndex);
  }

  Future<void> takeTimedPicture(void Function(String path) savePicture) async {
    int secondsLeft = countDownSeconds;

    while (secondsLeft > 0) {
      final currentState = state;
      if (currentState is! CameraReady || isClosed) {
        return;
      }

      _safeEmit(
        CameraReady(
          hasFlashSupport: currentState.hasFlashSupport,
          isFlashOn: currentState.isFlashOn,
          secondsLeft: secondsLeft,
          isTimerActive: true,
        ),
      );

      await Future.delayed(const Duration(seconds: countDownPeriod));
      secondsLeft -= countDownPeriod;
    }

    final currentState = state;
    if (currentState is! CameraReady || isClosed) return;
    _safeEmit(
      CameraReady(
        hasFlashSupport: currentState.hasFlashSupport,
        isFlashOn: currentState.isFlashOn,
        secondsLeft: secondsLeft,
      ),
    );

    await takePicture(savePicture);
  }

  void _safeEmit(CameraState state) {
    if (!isClosed) emit(state);
  }

  Future<void> _setupCamera(int index) async {
    if (isClosed) return;
    _safeEmit(const CameraLoading());

    final status = await Permission.camera.request();
    if (isClosed) return;

    if (!status.isGranted) {
      _safeEmit(const CameraPermissionDenied());
      return;
    }

    try {
      if (_cameras.isEmpty) {
        _cameras = await availableCameras();
        if (isClosed) return;

        if (_cameras.isEmpty) {
          _safeEmit(
            const CameraFailure(errorTtype: CameraErrorType.noCamerasFound),
          );
          return;
        }
      }

      final targetIndex = index % _cameras.length;
      await _controller?.dispose();
      if (isClosed) return;

      final newController = CameraController(
        _cameras[targetIndex],
        ResolutionPreset.high,
      );
      _controller = newController;

      await newController.initialize();
      if (_controller != newController || isClosed) return;

      _selectedIndex = targetIndex;
      _hasFlashSupport =
          _cameras[targetIndex].lensDirection == CameraLensDirection.back;

      if (_hasFlashSupport) {
        try {
          await newController.setFlashMode(FlashMode.off);
          if (_controller != newController || isClosed) return;
        } catch (e) {
          log('Flash error: $e');
        }
      }
    } catch (e) {
      log('Error initializing camera: $e');
      _safeEmit(
        const CameraFailure(errorTtype: CameraErrorType.initializationFailed),
      );
      return;
    }

    _safeEmit(CameraReady(hasFlashSupport: _hasFlashSupport));
  }

  Future<void> switchCamera() async {
    if (_cameras.isEmpty) return;
    final newIndex = (_selectedIndex + 1) % _cameras.length;
    _hasFlashSupport = true;
    await _setupCamera(newIndex);
  }

  Future<void> switchFlash() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (!_hasFlashSupport) {
      final currentState = state;
      if (currentState is! CameraReady) return;
      _safeEmit(
        CameraReady(
          isFlashOn: currentState.isFlashOn,
          hasFlashSupport: false,
          warningMessage: 'No flash available on this camera',
        ),
      );
      return;
    }

    try {
      if (!controller.value.isInitialized) {
        return;
      }
      final currentMode = controller.value.flashMode;
      final newMode = currentMode == FlashMode.always
          ? FlashMode.off
          : FlashMode.always;
      final newIsFlashOn = newMode == FlashMode.always;

      await controller.setFlashMode(newMode);

      if (controller != _controller || isClosed) {
        log('Flash switch ignored: controller changed or cubit closed');
        return;
      }

      final actualMode = controller.value.flashMode;
      if (actualMode != newMode) {
        log('Flash not applied: likely no support');
        _hasFlashSupport = false;
        _safeEmit(
          const CameraReady(
            isFlashOn: false,
            hasFlashSupport: false,
            warningMessage: 'No flash available on this camera',
          ),
        );
        return;
      }
      log('Actual mode after set: $actualMode vs new: $newMode');

      _safeEmit(
        CameraReady(isFlashOn: newIsFlashOn, hasFlashSupport: _hasFlashSupport),
      );
    } on CameraException catch (e) {
      log('Flash error: $e');
      if (controller != _controller || isClosed) return;

      _hasFlashSupport = false;
      _safeEmit(
        const CameraReady(
          isFlashOn: false,
          hasFlashSupport: false,
          warningMessage: 'No flash available on this camera',
        ),
      );
    } catch (e) {
      log('Error switching flash: $e');
      if (e.toString().contains('disposed') || e is StateError) {
        log('Ignored error on disposed controller');
        return;
      }

      final currentState = state;
      if (currentState is! CameraReady) return;
      _safeEmit(
        CameraReady(
          isFlashOn: currentState.isFlashOn,
          hasFlashSupport: currentState.hasFlashSupport,
          warningMessage: 'Something went wrong',
        ),
      );
    }
  }

  // Future<String?> takePicture() async {
  Future<void> takePicture(void Function(String path) savePicture) async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (controller.value.isTakingPicture) return;

    try {
      final picture = await controller.takePicture();
      if (controller != _controller || isClosed) {
        log('Picture ignored: controller changed or cubit closed');
        return;
      }
      final bytes = await picture.readAsBytes();
      if (controller != _controller || isClosed) return;

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final appDir = await getApplicationDocumentsDirectory();
      final photosDir = Directory('${appDir.path}/photos');
      final isDirExists = await photosDir.exists();

      if (!isDirExists) {
        await photosDir.create(recursive: true);
      }

      final path = '${photosDir.path}/$timestamp.jpg';
      final file = File(path);
      await file.writeAsBytes(bytes);

      // return path;
      savePicture(path);
    } catch (e) {
      log('Failed to capture photo: $e');
      return;
    }
  }

  Future<void> retryInitialization() async {
    await _setupCamera(_selectedIndex);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _handlePause();
    } else if (state == AppLifecycleState.resumed) {
      _handleResume();
    }
  }

  Future<void> _handlePause() async {
    final controller = _controller;
    _controller = null;
    await controller?.dispose();
  }

  Future<void> _handleResume() async {
    await _setupCamera(_selectedIndex);
  }

  @override
  Future<void> close() async {
    WidgetsBinding.instance.removeObserver(this);

    final controller = _controller;
    await controller?.dispose();

    if (_controller == controller) {
      _controller = null;
    }
    await super.close();
  }
}
