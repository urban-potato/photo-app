import 'dart:async' show Completer;

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synchronized/synchronized.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../../../../shared/domain/data_states/data_state.dart';
import '../../../../domain/repositories/photo.dart';
import 'constants/constants.dart';
import 'mixins/camera_lifecycle_mixin.dart';
import 'types/index.dart';
import 'utils/index.dart' show CameraPermissionHandler;
import 'camera_state.dart';

class CameraCubit extends Cubit<CameraState>
    with WidgetsBindingObserver, CameraLifecycleMixin
    implements CameraLifecycleHost {
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
  bool get _isControllerNull => _controller == null;
  bool _isControllerDisposed = false;
  bool _isCapturing = false;
  @override
  bool get isCapturing => _isCapturing;
  final Lock _lock = Lock();
  int _cameraGeneration = 0;
  Completer<void>? _captureCompleter;

  Lock get lock => _lock;
  CameraController? get controller => _controller;
  @override
  Completer<void>? get captureCompleter => _captureCompleter;

  @override
  @protected
  bool get isRequestingPermission => _isRequestingPermission;
  @override
  @protected
  int get selectedIndex => _selectedIndex;
  @protected
  set controller(CameraController? value) => _controller = value;

  Future<void> switchRatio(CameraAspectRatio newAspectRatio) async {
    return await _lock.synchronized(() async {
      if (_controllerUnavailable) return;

      if (state is CameraReady) {
        safeEmit((state as CameraReady).copyWith(isBusy: true));
      }

      final currentState = state;
      if (currentState is! CameraReady) return;

      safeEmit(
        currentState.copyWith(targetAspectRatio: newAspectRatio, isBusy: false),
      );
    });
  }

  Future<void> takeTimedPicture(double targetRatio) async {
    return await _lock.synchronized(() async {
      if (_controllerUnavailable) return;

      if (state is CameraReady) {
        safeEmit((state as CameraReady).copyWith(isBusy: true));
      }

      int secondsLeft = countDownSeconds;

      while (secondsLeft > 0) {
        final currentState = state;
        if (currentState is! CameraReady ||
            isClosed ||
            _isControllerNull ||
            _isControllerDisposed) {
          return;
        }

        safeEmit(
          currentState.copyWith(
            secondsLeft: secondsLeft,
            isTimerActive: true,
            isBusy: true,
          ),
        );

        await Future.delayed(const Duration(seconds: countDownPeriod));

        if (_isControllerDisposed || isClosed || _isControllerNull) return;

        secondsLeft -= countDownPeriod;
      }

      final currentState = state;
      if (currentState is! CameraReady ||
          isClosed ||
          _isControllerNull ||
          _isControllerDisposed) {
        return;
      }

      safeEmit(
        currentState.copyWith(
          secondsLeft: secondsLeft,
          isTimerActive: false,
          isBusy: true,
        ),
      );

      await _takePicture(targetRatio);
    });
  }

  @override
  @protected
  Future<void> setupCamera(int index) async {
    if (isClosed) return;

    final generation = ++_cameraGeneration;

    try {
      CameraState prevState = state;
      safeEmit(const CameraLoading());

      final deniedPermission = await _requestPermissions();
      if (_isStale(generation)) return;

      if (deniedPermission != null) {
        safeEmit(CameraPermissionDenied(permissionType: deniedPermission));
        return;
      }

      await _loadCamerasIfNeeded();
      if (_isStale(generation)) return;

      if (_cameras.isEmpty) {
        safeEmit(
          const CameraFailure(errorType: CameraErrorType.noCamerasFound),
        );
        return;
      }

      final targetIndex = _calculateCameraIndex(index);
      await disposeController();
      if (_isStale(generation)) return;

      final newController = CameraController(
        _cameras[targetIndex],
        ResolutionPreset.high,
      );
      await newController.initialize();
      if (_isStale(generation)) {
        await newController.dispose();
        return;
      }

      _hasFlashSupport =
          _cameras[targetIndex].lensDirection == CameraLensDirection.back;

      if (_hasFlashSupport) {
        await newController.setFlashMode(FlashMode.off);
      }

      if (_isStale(generation)) {
        await newController.dispose();
        return;
      }

      _selectedIndex = targetIndex;
      _controller = newController;
      _isControllerDisposed = false;

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
      if (_controllerUnavailable) return;

      if (_cameras.isNotEmpty) {
        final newIndex = _calculateNextCameraIndex();
        await setupCamera(newIndex);
      }
    });
  }

  Future<void> switchFlash() async {
    return await _lock.synchronized(() async {
      if (_controllerUnavailable) return;
      if (!_hasFlashSupport) {
        _emitFlashUnsupported();
        return;
      }

      try {
        final controller = _controller;
        if (_isControllerDisposed ||
            controller == null ||
            !controller.value.isInitialized ||
            controller.value.isTakingPicture ||
            isClosed ||
            state is! CameraReady) {
          return;
        }

        if (state is CameraReady) {
          safeEmit((state as CameraReady).copyWith(isBusy: true));
        }

        final currentMode = controller.value.flashMode;
        final newMode = currentMode == FlashMode.always
            ? FlashMode.off
            : FlashMode.always;
        final newIsFlashOn = newMode == FlashMode.always;
        await controller.setFlashMode(newMode);

        if (_isControllerDisposed ||
            !identical(controller, _controller) ||
            isClosed ||
            state is! CameraReady) {
          return;
        }

        final currentState = state;
        if (currentState is! CameraReady) return;

        safeEmit(
          CameraReady(
            targetAspectRatio: currentState.targetAspectRatio,
            isFlashOn: newIsFlashOn,
            hasFlashSupport: true,
            isBusy: false,
          ),
        );
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
      if (state is CameraReady) {
        safeEmit((state as CameraReady).copyWith(isBusy: true));
      }
      await _takePicture(targetRatio);
    });
  }

  Future<void> _takePicture(double targetRatio) async {
    if (_isControllerNull || state is! CameraReady || _isControllerDisposed) {
      return;
    }

    try {
      final controller = _controller;
      if (_isControllerDisposed ||
          controller == null ||
          !controller.value.isInitialized ||
          controller.value.isTakingPicture ||
          _controllerInvalid(controller)) {
        return;
      }

      _captureCompleter = Completer<void>();
      _isCapturing = true;

      final picture = await controller.takePicture();
      if (_controllerInvalid(controller)) {
        _talker.warning('Picture ignored: controller changed or cubit closed');
        return;
      }

      final bytes = await picture.readAsBytes();
      if (_controllerInvalid(controller)) {
        _talker.warning(
          'Picture readAsBytes ignored: controller changed or cubit closed',
        );
        return;
      }

      final currentState = state;
      if (currentState is! CameraReady) return;
      final dataState = await _photoRepository.savePhoto(bytes, targetRatio);

      if (_isControllerNull || _controllerInvalid(controller)) {
        _talker.warning(
          'Picture savePhoto ignored: controller changed or cubit closed',
        );
        return;
      }

      if (dataState is DataSuccess) {
        safeEmit(CameraPictureTaken(pictureFile: dataState.data!));
      } else {
        safeEmit(const CameraPictureFailure());
        // await setupCamera(_selectedIndex);
      }
      _isCapturing = false;
    } catch (e, st) {
      _talker.error('Take picture failed', e, st);

      safeEmit(const CameraPictureFailure());

      // await setupCamera(_selectedIndex);
    } finally {
      _isCapturing = false;
      _captureCompleter?.complete();
      _captureCompleter = null;
    }
  }

  bool _isStale(int generation) => generation != _cameraGeneration || isClosed;

  bool _controllerInvalid(CameraController controller) =>
      _isControllerDisposed || !identical(controller, _controller) || isClosed;

  bool get _controllerUnavailable =>
      _isControllerNull || _isControllerDisposed || isClosed || _isCapturing;

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
          isBusy: false,
        ),
      );
    } else if (prevState is CameraReadyPaused) {
      safeEmit(
        CameraReady(
          hasFlashSupport: _hasFlashSupport,
          isFlashOn: prevState.isFlashOn,
          targetAspectRatio: prevState.targetAspectRatio,
          isBusy: false,
        ),
      );
    } else {
      safeEmit(CameraReady(hasFlashSupport: _hasFlashSupport, isBusy: false));
    }
  }

  void _emitFlashUnsupported() {
    final currentState = state;
    if (currentState is! CameraReady) return;

    safeEmit(
      CameraReady(
        targetAspectRatio: currentState.targetAspectRatio,
        isFlashOn: false,
        hasFlashSupport: false,
        message: 'No flash available on this camera',
        isBusy: false,
      ),
    );
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

  @override
  @protected
  void safeEmit(CameraState state) {
    if (!isClosed) emit(state);
  }

  @override
  @protected
  Future<void> disposeController() async {
    if (isCapturing && _captureCompleter != null) {
      await _captureCompleter?.future;
    }

    final oldController = _controller;
    _controller = null;
    _isControllerDisposed = true;

    if (oldController != null) {
      try {
        await oldController.dispose();
      } catch (_) {}

      await Future.delayed(controllerDisposeDelay);
    }
  }

  @override
  Future<void> close() async {
    if (isCapturing && _captureCompleter != null) {
      await _captureCompleter!.future;
    }

    WidgetsBinding.instance.removeObserver(this);
    safeEmit(const CameraClosed());
    await disposeController();
    await super.close();
  }
}
