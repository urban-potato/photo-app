import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synchronized/synchronized.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../../../../shared/domain/data_states/data_state.dart';
import '../../../../domain/repositories/photo.dart';
import 'constants/constants.dart';
import 'types/index.dart';
import 'utils/index.dart' show CameraPermissionHandler;
import 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> with WidgetsBindingObserver {
  CameraCubit({
    required PhotoRepositoryI photoRepository,
    required Talker talker,
  }) : _talker = talker,
       _photoRepository = photoRepository,
       super(const CameraInitial()) {
    WidgetsBinding.instance.addObserver(this);
    setupCamera(_selectedIndex);
  }

  final Talker _talker;
  final PhotoRepositoryI _photoRepository;
  final CameraPermissionHandler _permissionHandler = CameraPermissionHandler();
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _selectedIndex = 0;
  bool _hasFlashSupport = true;
  bool _isRequestingPermission = false;
  bool get _isDisposed => !(_controller?.value.isInitialized ?? false);
  final Lock _lock = Lock();

  Lock get lock => _lock;
  CameraController? get controller => _controller;

  @protected
  bool get isRequestingPermission => _isRequestingPermission;
  @protected
  int get selectedIndex => _selectedIndex;
  @protected
  set controller(CameraController? value) => _controller = value;

  Future<void> switchRatio(CameraAspectRatio newAspectRatio) async {
    return await _lock.synchronized(() async {
      if (_isDisposed) return;

      final currentState = state;
      if (currentState is! CameraReady || isClosed || _isDisposed) return;

      safeEmit(currentState.copyWith(targetAspectRatio: newAspectRatio));
    });
  }

  Future<void> takeTimedPicture(double targetRatio) async {
    return await _lock.synchronized(() async {
      if (_isDisposed) return;

      int secondsLeft = countDownSeconds;

      while (secondsLeft > 0) {
        final currentState = state;
        if (currentState is! CameraReady || isClosed || _isDisposed) return;

        safeEmit(
          currentState.copyWith(secondsLeft: secondsLeft, isTimerActive: true),
        );

        await Future.delayed(const Duration(seconds: countDownPeriod));
        secondsLeft -= countDownPeriod;
      }

      final currentState = state;
      if (currentState is! CameraReady || isClosed || _isDisposed) return;

      safeEmit(
        currentState.copyWith(secondsLeft: secondsLeft, isTimerActive: false),
      );

      await _takePicture(targetRatio);
    });
  }

  @protected
  Future<void> setupCamera(int index) async {
    if (isClosed) return;

    try {
      CameraState prevState = state;
      safeEmit(const CameraLoading());

      final deniedPermission = await _requestPermissions();
      if (deniedPermission != null) {
        safeEmit(CameraPermissionDenied(permissionType: deniedPermission));
        return;
      }

      await _loadCamerasIfNeeded();
      if (_cameras.isEmpty) {
        safeEmit(
          const CameraFailure(errorType: CameraErrorType.noCamerasFound),
        );
        return;
      }

      final targetIndex = _calculateCameraIndex(index);
      await disposeController();
      if (isClosed) return;

      final newController = CameraController(
        _cameras[targetIndex],
        ResolutionPreset.high,
      );
      await newController.initialize();

      _hasFlashSupport =
          _cameras[targetIndex].lensDirection == CameraLensDirection.back;

      if (_hasFlashSupport) {
        await newController.setFlashMode(FlashMode.off);
      }

      _controller = newController;
      _selectedIndex = targetIndex;

      _emitReadyState(prevState);
    } catch (e) {
      _talker.error('Error initializing camera: $e');
      safeEmit(
        const CameraFailure(errorType: CameraErrorType.initializationFailed),
      );
    }
  }

  Future<void> switchCamera() async {
    return await _lock.synchronized(() async {
      if (_isDisposed) return;

      if (_cameras.isNotEmpty) {
        final newIndex = _calculateNextCameraIndex();
        await setupCamera(newIndex);
      }
    });
  }

  Future<void> switchFlash() async {
    return await _lock.synchronized(() async {
      if (_isDisposed) return;
      if (!_hasFlashSupport) {
        _emitFlashUnsupported();
        return;
      }

      try {
        final controller = _controller;
        if (controller == null || !controller.value.isInitialized) return;

        final currentMode = controller.value.flashMode;
        final newMode = currentMode == FlashMode.always
            ? FlashMode.off
            : FlashMode.always;
        final newIsFlashOn = newMode == FlashMode.always;
        await controller.setFlashMode(newMode);

        if (controller == _controller && !isClosed && !_isDisposed) {
          final currentState = state;
          if (currentState is CameraReady) {
            safeEmit(
              CameraReady(
                targetAspectRatio: currentState.targetAspectRatio,
                isFlashOn: newIsFlashOn,
                hasFlashSupport: true,
              ),
            );
          }
        }
      } catch (e) {
        _talker.error('Error switching flash: $e');

        if (e.toString().contains('disposed') || e is StateError) {
          _talker.warning(
            'Error switching flash: Ignored error on disposed controller',
          );
          return;
        }

        _emitFlashUnsupported();
      }
    });
  }

  Future<void> takePicture(double targetRatio) async {
    return await _lock.synchronized(() async {
      await _takePicture(targetRatio);
    });
  }

  Future<void> _takePicture(double targetRatio) async {
    if (_isDisposed || state is! CameraReady) return;

    try {
      final controller = _controller;
      if (controller == null ||
          !controller.value.isInitialized ||
          controller.value.isTakingPicture) {
        return;
      }

      final picture = await controller.takePicture();
      if (controller != _controller || isClosed) {
        _talker.warning('Picture ignored: controller changed or cubit closed');
        return;
      }

      final bytes = await picture.readAsBytes();
      if (controller != _controller || isClosed) {
        _talker.warning(
          'Picture readAsBytes ignored: controller changed or cubit closed',
        );
        return;
      }

      final currentState = state;
      if (currentState is CameraReady) {
        final dataState = await _photoRepository.savePhoto(bytes, targetRatio);

        if (dataState is DataSuccess) {
          safeEmit(CameraPictureTaken(pictureFile: dataState.data!));
        } else {
          safeEmit(const CameraPictureFailure());
          await setupCamera(_selectedIndex);
        }
      }
    } catch (e) {
      safeEmit(const CameraPictureFailure());
      await setupCamera(_selectedIndex);
    }
  }

  int _calculateCameraIndex(int index) {
    return index % _cameras.length;
  }

  int _calculateNextCameraIndex() {
    return (_selectedIndex + 1) % _cameras.length;
  }

  Future<void> _loadCamerasIfNeeded() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
  }

  void _emitReadyState(CameraState prevState) {
    if (prevState is CameraReady) {
      safeEmit(
        CameraReady(
          hasFlashSupport: _hasFlashSupport,
          targetAspectRatio: prevState.targetAspectRatio,
        ),
      );
    } else if (prevState is CameraReadyPaused) {
      safeEmit(
        CameraReady(
          hasFlashSupport: _hasFlashSupport,
          isFlashOn: prevState.isFlashOn,
          targetAspectRatio: prevState.targetAspectRatio,
        ),
      );
    } else {
      safeEmit(CameraReady(hasFlashSupport: _hasFlashSupport));
    }
  }

  void _emitFlashUnsupported() {
    final currentState = state;
    if (currentState is CameraReady) {
      safeEmit(
        CameraReady(
          targetAspectRatio: currentState.targetAspectRatio,
          isFlashOn: false,
          hasFlashSupport: false,
          message: 'No flash available on this camera',
        ),
      );
    }
  }

  Future<PermissionType?> _requestPermissions() async {
    _isRequestingPermission = true;
    final denied = await _permissionHandler.requestPermissions();
    _isRequestingPermission = false;
    return denied;
  }

  Future<void> retryInitialization() async {
    return await _lock.synchronized(() async {
      await setupCamera(_selectedIndex);
    });
  }

  Future<void> grantPermissionInSettings() async {
    await _permissionHandler.openSettings();
  }

  @protected
  void safeEmit(CameraState state) {
    if (!isClosed) emit(state);
  }

  @protected
  Future<void> disposeController() async {
    final oldController = _controller;
    if (oldController != null) {
      await oldController.dispose();
      if (_controller == oldController) _controller = null;
      await Future.delayed(controllerDisposeDelay);
    }
  }

  @override
  Future<void> close() async {
    WidgetsBinding.instance.removeObserver(this);

    safeEmit(const CameraClosed());
    await disposeController();
    await super.close();
  }
}
