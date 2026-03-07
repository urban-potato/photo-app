import 'package:flutter/material.dart';

import 'camera_icon_button.dart';

class SwitchRatioButton extends StatelessWidget {
  const SwitchRatioButton({super.key, required this.switchRatio});

  final void Function()? switchRatio;

  @override
  Widget build(BuildContext context) {
    return CameraIconButton(
      icon: Icons.aspect_ratio_rounded,
      onPressed: switchRatio,
    );
  }
}
