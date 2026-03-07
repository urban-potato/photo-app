import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:synchronized/synchronized.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../../../../shared/domain/data_states/data_state.dart';
import '../../../../domain/repositories/photo.dart';
import 'camera_state.dart';
import 'enums/camera_aspect_ratio.dart';

class CameraCubit extends Cubit<CameraState> with WidgetsBindingObserver {
  CameraCubit({required PhotoRepositoryI photoRepository, required this.talker})
    : _photoRepository = photoRepository,
      super(const CameraInitial()) {
    WidgetsBinding.instance.addObserver(this);
    _setupCamera(_selectedIndex);
  }

  final Talker talker;
  final PhotoRepositoryI _photoRepository;

  static const countDownSeconds = 3;
  static const countDownPeriod = 1;

  final Lock _lock = Lock();
  bool _isBusy = false;
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _selectedIndex = 0;
  bool _hasFlashSupport = true;

  bool _isRequestingPermission = false;
  bool _permissionDialogCausedPause = false;

  CameraController? get controller => _controller;
  bool get _isDisposed => !(_controller?.value.isInitialized ?? false);

  void switchRatio(CameraAspectRatio newAspectRatio) {
    if (_isBusy || _isDisposed) return;
    _isBusy = true;

    final currentState = state;

    if (currentState is! CameraReady || isClosed) {
      _isBusy = false;
      return;
    }

    talker.warning(
      'CameraCubit switchRatio targetAspectRatio = $newAspectRatio',
    );

    _isBusy = false;
    _safeEmit(currentState.copyWith(targetAspectRatio: newAspectRatio));
  }

  Future<void> takeTimedPicture(double targetRatio) async {
    if (_isBusy || _isDisposed) return;
    _isBusy = true;

    int secondsLeft = countDownSeconds;

    while (secondsLeft > 0) {
      final currentState = state;
      if (currentState is! CameraReady || isClosed) {
        _isBusy = false;
        return;
      }

      _safeEmit(
        currentState.copyWith(secondsLeft: secondsLeft, isTimerActive: true),
      );

      await Future.delayed(const Duration(seconds: countDownPeriod));
      secondsLeft -= countDownPeriod;
    }

    final currentState = state;
    if (currentState is! CameraReady || isClosed || _isDisposed) {
      _isBusy = false;
      return;
    }

    _safeEmit(
      currentState.copyWith(secondsLeft: secondsLeft, isTimerActive: false),
    );

    _isBusy = false;
    await takePicture(targetRatio);
  }

  void _safeEmit(CameraState state) {
    if (!isClosed) emit(state);
  }

  Future<void> _setupCamera(int index) async {
    if (isClosed) return;

    CameraState prevState = state;

    _safeEmit(const CameraLoading());

    try {
      _isRequestingPermission = true;
      final cameraStatus = await Permission.camera.request();
      if (isClosed) return;
      _isRequestingPermission = false;

      if (!cameraStatus.isGranted) {
        _safeEmit(
          const CameraPermissionDenied(permissionType: PermissionType.camera),
        );
        return;
      }

      _isRequestingPermission = true;
      final audioStatus = await Permission.microphone.request();
      if (isClosed) return;
      _isRequestingPermission = false;

      if (!audioStatus.isGranted) {
        _safeEmit(
          const CameraPermissionDenied(
            permissionType: PermissionType.microphone,
          ),
        );
        return;
      }

      if (_cameras.isEmpty) {
        _cameras = await availableCameras();
        if (isClosed) return;

        if (_cameras.isEmpty) {
          _safeEmit(
            const CameraFailure(errorType: CameraErrorType.noCamerasFound),
          );
          return;
        }
      }

      final targetIndex = index % _cameras.length;
      await _controller?.dispose();
      await Future.delayed(const Duration(milliseconds: 100));
      _controller = null;
      if (isClosed) return;

      final newController = CameraController(
        _cameras[targetIndex],
        ResolutionPreset.high,
      );
      _controller = newController;

      await newController.initialize();
      if (_controller != newController || isClosed || _isDisposed) return;

      _selectedIndex = targetIndex;
      _hasFlashSupport =
          _cameras[targetIndex].lensDirection == CameraLensDirection.back;

      if (_hasFlashSupport) {
        try {
          await newController.setFlashMode(FlashMode.off);
          if (_controller != newController || isClosed || _isDisposed) return;
        } catch (e) {
          talker.error('Error setting FlashMode: $e');
        }
      }
    } on CameraException catch (e) {
      talker.error('Camera exception: $e');

      if (e.code == 'AudioAccessDenied') {
        final audioStatus = await Permission.microphone.status;
        if (isClosed) return;

        if (!audioStatus.isGranted) {
          _safeEmit(
            const CameraPermissionDenied(
              permissionType: PermissionType.microphone,
            ),
          );
        }
        return;
      }

      _safeEmit(
        const CameraFailure(errorType: CameraErrorType.initializationFailed),
      );
    } catch (e) {
      talker.error('Error initializing camera: $e');

      _safeEmit(
        const CameraFailure(errorType: CameraErrorType.initializationFailed),
      );
      return;
    }

    if (prevState is CameraReady) {
      _safeEmit(
        CameraReady(
          hasFlashSupport: _hasFlashSupport,
          targetAspectRatioPortrait: prevState.targetAspectRatioPortrait,
        ),
      );
    } else if (prevState is CameraReadyPaused) {
      _safeEmit(
        CameraReady(
          hasFlashSupport: _hasFlashSupport,
          isFlashOn: prevState.isFlashOn,
          targetAspectRatioPortrait: prevState.targetAspectRatio,
        ),
      );
    } else {
      _safeEmit(CameraReady(hasFlashSupport: _hasFlashSupport));
    }
  }

  Future<void> switchCamera() async {
    if (_isBusy || _isDisposed) return;
    _isBusy = true;

    try {
      if (_cameras.isEmpty) return;

      final newIndex = (_selectedIndex + 1) % _cameras.length;
      _hasFlashSupport = true;
      await _setupCamera(newIndex);
    } finally {
      _isBusy = false;
    }
  }

  Future<void> switchFlash() async {
    if (_isBusy || _isDisposed) return;
    _isBusy = true;

    try {
      final controller = _controller;
      if (controller == null ||
          !controller.value.isInitialized ||
          _isDisposed) {
        return;
      }

      if (!_hasFlashSupport) {
        final currentState = state;
        if (currentState is CameraReady) {
          _safeEmit(
            CameraReady(
              targetAspectRatioPortrait: currentState.targetAspectRatioPortrait,
              isFlashOn: false,
              hasFlashSupport: false,
              message: 'No flash available on this camera',
            ),
          );
        }

        return;
      }

      if (!controller.value.isInitialized || _isDisposed) {
        return;
      }

      final currentMode = controller.value.flashMode;
      final newMode = currentMode == FlashMode.always
          ? FlashMode.off
          : FlashMode.always;
      final newIsFlashOn = newMode == FlashMode.always;

      await controller.setFlashMode(newMode);

      if (controller != _controller || isClosed || _isDisposed) {
        talker.warning(
          'Flash switch ignored: controller changed or cubit closed',
        );
        return;
      }

      final actualMode = controller.value.flashMode;
      if (actualMode != newMode) {
        talker.warning('Flash not applied: likely no support');

        _hasFlashSupport = false;

        final currentState = state;
        if (currentState is CameraReady) {
          _safeEmit(
            CameraReady(
              targetAspectRatioPortrait: currentState.targetAspectRatioPortrait,
              isFlashOn: false,
              hasFlashSupport: false,
              message: 'No flash available on this camera',
            ),
          );
        }

        return;
      }

      final currentState = state;
      if (currentState is CameraReady) {
        _safeEmit(
          CameraReady(
            targetAspectRatioPortrait: currentState.targetAspectRatioPortrait,
            isFlashOn: newIsFlashOn,
            hasFlashSupport: _hasFlashSupport,
          ),
        );
      }
    } on CameraException catch (e) {
      talker.error('CameraException switching flash: $e');

      if (controller != _controller || isClosed || _isDisposed) return;

      _hasFlashSupport = false;

      final currentState = state;
      if (currentState is CameraReady) {
        _safeEmit(
          CameraReady(
            targetAspectRatioPortrait: currentState.targetAspectRatioPortrait,
            isFlashOn: false,
            hasFlashSupport: false,
            message: 'No flash available on this camera',
          ),
        );
      }
    } catch (e) {
      talker.error('Error switching flash: $e');

      if (e.toString().contains('disposed') || e is StateError) {
        talker.warning(
          'Error switching flash: Ignored error on disposed controller',
        );
        return;
      }

      final currentState = state;
      if (currentState is CameraReady) {
        _safeEmit(
          CameraReady(
            targetAspectRatioPortrait: currentState.targetAspectRatioPortrait,
            isFlashOn: false,
            hasFlashSupport: false,
            message: 'Something went wrong',
          ),
        );
      }
    } finally {
      _isBusy = false;
    }
  }

  Future<void> takePicture(double targetRatio) async {
    if (_isBusy || _isDisposed || state is! CameraReady) return;
    _isBusy = true;

    try {
      return await _lock.synchronized(() async {
        final controller = _controller;
        if (controller == null ||
            !controller.value.isInitialized ||
            controller.value.isTakingPicture ||
            _isDisposed) {
          _isBusy = false;
          return;
        }

        final picture = await controller.takePicture();
        if (controller != _controller || isClosed || _isDisposed) {
          talker.warning('Picture ignored: controller changed or cubit closed');
          _isBusy = false;
          return;
        }
        final bytes = await picture.readAsBytes();
        if (controller != _controller || isClosed || _isDisposed) {
          talker.warning(
            'Picture readAsBytes ignored: controller changed or cubit closed',
          );
          _isBusy = false;
          return;
        }

        final currentState = state;
        if (currentState is CameraReady) {
          final dataState = await _photoRepository.savePhoto(
            bytes,
            targetRatio,
          );

          switch (dataState) {
            case (DataSuccess _):
              {
                final file = dataState.data!;
                _isBusy = false;
                _safeEmit(CameraPictureTaken(pictureFile: file));
              }
            case (DataFailed _):
              {
                _safeEmit(const CameraPictureFailure());

                await _setupCamera(_selectedIndex);
                _isBusy = false;
              }
          }
        } else {
          _isBusy = false;
          return;
        }
      });
    } catch (e) {
      if (e is CameraException && e.description?.contains('disposed') == true) {
        talker.warning('CameraException: Controller disposed');
      } else {
        talker.error('Failed to capture photo: $e');
      }

      _safeEmit(const CameraPictureFailure());

      await _setupCamera(_selectedIndex);
      _isBusy = false;
    }
  }

  Future<void> retryInitialization() async {
    _isBusy = true;
    await _setupCamera(_selectedIndex);
    _isBusy = false;
  }

  Future<void> grantPermissionInSettings() async {
    await openAppSettings();
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
    if (_isRequestingPermission) {
      _permissionDialogCausedPause = true;
    }

    final currentState = state;

    if (currentState is CameraReady) {
      _safeEmit(
        CameraReadyPaused(
          hasFlashSupport: currentState.hasFlashSupport,
          isFlashOn: currentState.isFlashOn,
          targetAspectRatio: currentState.targetAspectRatioPortrait,
        ),
      );
    } else {
      _safeEmit(const CameraPaused());
    }

    await _lock.synchronized(() async {
      final controller = _controller;
      if (_controller == controller) {
        _controller = null;
      }
      if (controller == null) return;

      await controller.dispose();
      await Future.delayed(const Duration(milliseconds: 100));
    });
  }

  Future<void> _handleResume() async {
    if (_permissionDialogCausedPause) {
      _permissionDialogCausedPause = false;
      return;
    }

    _isBusy = true;
    await _setupCamera(_selectedIndex);
    _isBusy = false;
  }

  @override
  Future<void> close() async {
    WidgetsBinding.instance.removeObserver(this);

    final controller = _controller;

    return await _lock.synchronized(() async {
      _safeEmit(const CameraClosed());

      await controller?.dispose();
      await Future.delayed(const Duration(milliseconds: 100));

      if (_controller == controller) {
        _controller = null;
      }
      await super.close();
    });
  }
}
