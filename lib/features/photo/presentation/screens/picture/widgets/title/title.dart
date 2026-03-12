import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../shared/presentation/providers/responsive_size/index.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key, required this.date, required this.time});

  final String date;
  final String time;

  @override
  Widget build(BuildContext context) {
    final responsive = context.read<ResponsiveSizeCubit>();
    final colorScheme = Theme.of(context).colorScheme;

    final fontSizeDate = responsive.textL;
    final fontSizeTime = responsive.textS;
    final colorTime = colorScheme.onSurfaceVariant;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: TextStyle(fontSize: fontSizeDate, fontWeight: FontWeight.w500),
        ),
        Text(
          time,
          style: TextStyle(fontSize: fontSizeTime, color: colorTime),
        ),
      ],
    );
  }
}
