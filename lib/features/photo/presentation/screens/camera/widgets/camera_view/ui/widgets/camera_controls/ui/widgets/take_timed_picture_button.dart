import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../../../../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;

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
    final responsiveSizeCubit = context.watch<ResponsiveSizeCubit>();
    final iconSize = responsiveSizeCubit.iconM;

    return IconButton(
      onPressed: () async {
        await takeTimedPicture();
      },
      icon: Icon(Icons.timer_rounded, size: iconSize, color: timerColor),
    );
  }
}
