import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../../../../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;

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
    final flashColor = hasFlashSupport ? null : Colors.grey;
    final flashIcon = isFlashOn
        ? Icons.flash_on_rounded
        : Icons.flash_off_rounded;
    final responsive = context.watch<ResponsiveSizeCubit>();
    final iconSize = responsive.iconM;

    return IconButton(
      onPressed: onPressed,
      icon: Icon(flashIcon, size: iconSize),
      color: flashColor,
    );
  }
}
