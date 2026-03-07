import 'package:flutter/material.dart';

import 'camera_icon_button.dart';

class TakeTimedPictureButton extends StatelessWidget {
  const TakeTimedPictureButton({
    super.key,
    required this.takeTimedPicture,
    required this.isTimerActive,
  });

  final Future<void> Function() takeTimedPicture;
  final bool isTimerActive;

  @override
  Widget build(BuildContext context) {
    final timerColor = isTimerActive ? Colors.yellow : null;

    return CameraIconButton(
      icon: Icons.timer_rounded,
      onPressed: takeTimedPicture,
      iconColor: timerColor,
    );
  }
}
