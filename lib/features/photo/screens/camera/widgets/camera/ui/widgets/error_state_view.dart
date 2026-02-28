import 'package:flutter/material.dart';

import '../../provider/camera_state.dart' show CameraErrorType;
import '../../provider/index.dart' show PermissionType;

class ErrorStateView extends StatelessWidget {
  const ErrorStateView({
    super.key,
    this.message = 'Woops, something went wrong',
    this.buttonText = 'Retry',
    required this.onPressed,
  });

  final String message;
  final String buttonText;
  final Future<void> Function() onPressed;

  factory ErrorStateView.fromPermissionDenied({
    required PermissionType permissionType,
    required Future<void> Function() onPressed,
  }) {
    final permissionName = switch (permissionType) {
      PermissionType.camera => 'camera',
      PermissionType.microphone => 'microphone',
    };
    return ErrorStateView(
      message:
          'To use this feature, the app needs access to your $permissionName. Please enable $permissionName access in the app settings',
      buttonText: 'Open App Settings',
      onPressed: onPressed,
    );
  }

  factory ErrorStateView.fromCameraFailure({
    required CameraErrorType errorTtype,
    required Future<void> Function() onPressed,
  }) {
    final message = switch (errorTtype) {
      CameraErrorType.noCamerasFound => 'No cameras found',
      CameraErrorType.initializationFailed =>
        'Error initializing camera. Please try again',
      CameraErrorType.generic => 'Something went wrong. Try again later',
    };
    return ErrorStateView(message: message, onPressed: onPressed);
  }

  factory ErrorStateView.noController({
    required Future<void> Function() onPressed,
  }) {
    return ErrorStateView(onPressed: onPressed);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          spacing: 24,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(onPressed: onPressed, child: Text(buttonText)),
          ],
        ),
      ),
    );
  }
}
