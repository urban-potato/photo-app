import 'dart:developer';
import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _selectedIndex = 1;

  CameraCubit() : super(const CameraInitial()) {
    WidgetsBinding.instance.addObserver(this);
    _setupCamera(_selectedIndex);
  }

  Future<void> _setupCamera(int index) async {
    if (isClosed) return;
    emit(const CameraLoading());

    final status = await Permission.camera.request();
    if (isClosed) return;

    if (!status.isGranted) {
      if (!isClosed) emit(const CameraPermissionDenied());
      return;
    }

    try {
      if (_cameras.isEmpty) {
        _cameras = await availableCameras();
        if (isClosed) return;

        if (_cameras.isEmpty) {
          if (!isClosed) {
            emit(
              const CameraFailure(errorTtype: CameraErrorType.noCamerasFound),
            );
          }
          return;
        }
      }

      final targetIndex = index % _cameras.length;
      await _controller?.dispose();
      if (isClosed) return;

      _controller = CameraController(
        _cameras[targetIndex],
        ResolutionPreset.high,
      );

      await _controller?.initialize();
      if (isClosed) return;

      _selectedIndex = targetIndex;

      if (!isClosed) {
        emit(CameraReady(controller: _controller!));
      }
    } catch (e) {
      if (!isClosed) {
        log('Error initializing camera: $e');
        emit(
          const CameraFailure(errorTtype: CameraErrorType.initializationFailed),
        );
      }
    }
  }

  Future<void> switchCamera() async {
    if (_cameras.isEmpty) return;
    final newIndex = (_selectedIndex + 1) % _cameras.length;
    await _setupCamera(newIndex);
  }

  Future<String?> takePicture() async {
    final controller = _controller;
    if (controller == null || !(controller.value.isInitialized)) {
      return null;
    }

    try {
      final XFile picture = await controller.takePicture();
      final Uint8List bytes = await picture.readAsBytes();

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

      return path;
    } catch (e) {
      log('Failed to capture photo: $e');
      return null;
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
      _controller?.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      _setupCamera(_selectedIndex);
    }
  }

  @override
  Future<void> close() async {
    WidgetsBinding.instance.removeObserver(this);
    await _controller?.dispose();
    _controller = null;
    await super.close();
  }
}
