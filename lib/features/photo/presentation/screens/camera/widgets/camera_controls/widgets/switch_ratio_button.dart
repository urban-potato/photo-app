import 'package:flutter/material.dart';

import '../../../provider/index.dart' show CameraAspectRatio;
import 'camera_icon_button.dart';

class SwitchRatioButton extends StatelessWidget {
  const SwitchRatioButton({
    super.key,
    required this.switchRatio,
    required this.currentRatio,
  });

  final void Function(CameraAspectRatio newAspectRatio) switchRatio;
  final CameraAspectRatio currentRatio;

  @override
  Widget build(BuildContext context) {
    void onPressed() {
      final cameraRatios = CameraAspectRatio.values;
      final currentRatioIndex = currentRatio.index;
      final incrementedRatioIndex = currentRatioIndex + 1;
      final newRationIndex = incrementedRatioIndex >= cameraRatios.length
          ? 0
          : incrementedRatioIndex;
      final newTargetAspectRatio = cameraRatios[newRationIndex];

      switchRatio(newTargetAspectRatio);
    }

    return CameraIconButton(
      icon: Icons.aspect_ratio_rounded,
      onPressed: onPressed,
    );
  }
}
