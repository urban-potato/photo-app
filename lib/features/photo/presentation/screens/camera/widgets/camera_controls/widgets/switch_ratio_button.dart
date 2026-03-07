import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../../../../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;
import '../../../provider/index.dart' show CameraAspectRatio;

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
    final responsive = context.watch<ResponsiveSizeCubit>();
    final iconSize = responsive.iconM;

    return IconButton(
      onPressed: () {
        final cameraRatios = CameraAspectRatio.values;

        final currentRatioIndex = currentRatio.index;
        final incrementedRatioIndex = currentRatioIndex + 1;
        final newRationIndex = incrementedRatioIndex >= cameraRatios.length
            ? 0
            : incrementedRatioIndex;
        final newTargetAspectRatio = cameraRatios[newRationIndex];

        switchRatio(newTargetAspectRatio);
      },
      icon: Icon(Icons.aspect_ratio_rounded, size: iconSize),
    );
  }
}
