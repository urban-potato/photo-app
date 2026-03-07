import 'package:flutter/material.dart';

import 'camera_icon_button.dart';

class SwitchFlashButton extends StatelessWidget {
  const SwitchFlashButton({
    super.key,
    required this.switchFlash,
    required this.hasFlashSupport,
    required this.isFlashOn,
  });

  final Future<void> Function() switchFlash;
  final bool hasFlashSupport;
  final bool isFlashOn;

  @override
  Widget build(BuildContext context) {
    final onPressed = hasFlashSupport ? switchFlash : null;
    final disabledColor = Colors.grey[400];
    final flashIcon = isFlashOn
        ? Icons.flash_on_rounded
        : Icons.flash_off_rounded;

    return CameraIconButton(
      icon: flashIcon,
      onPressed: onPressed,
      disabledIconColor: disabledColor,
    );
  }
}
