import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;

typedef CountDownProps = ({int? secondsLeft});

class CountdownDisplay extends StatelessWidget {
  const CountdownDisplay(this.countDownProps, {super.key});

  final CountDownProps countDownProps;

  @override
  Widget build(BuildContext context) {
    final secondsLeft = countDownProps.secondsLeft ?? 0;
    final responsive = context.watch<ResponsiveSizeCubit>();

    return _buildContent(secondsLeft, responsive);
  }

  Widget _buildContent(int secondsLeft, ResponsiveSizeCubit responsive) {
    Widget widget;

    if (secondsLeft > 0) {
      widget = Center(
        child: Text(
          '$secondsLeft',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontWeight: FontWeight.bold,
            fontSize: responsive.textHuge,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      widget = const SizedBox.shrink();
    }

    return widget;
  }
}
