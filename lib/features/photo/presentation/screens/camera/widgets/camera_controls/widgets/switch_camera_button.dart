import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../../../../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;

class SwitchCameraButton extends StatelessWidget {
  const SwitchCameraButton({super.key, required this.switchCamera});

  final Future<void> Function() switchCamera;

  @override
  Widget build(BuildContext context) {
    final responsive = context.watch<ResponsiveSizeCubit>();
    final iconSize = responsive.iconM;

    return IconButton(
      onPressed: switchCamera,
      icon: Icon(Icons.cameraswitch_rounded, size: iconSize),
    );
  }
}
