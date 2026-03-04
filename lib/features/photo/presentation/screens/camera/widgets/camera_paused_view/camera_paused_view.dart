import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../shared/presentation/providers/responsive_size/index.dart';

class CameraPausedView extends StatelessWidget {
  const CameraPausedView({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.watch<ResponsiveSizeCubit>();
    final iconSize = responsive.scaleLayout(100);

    return Center(child: Icon(Icons.camera_alt, size: iconSize));
  }
}
