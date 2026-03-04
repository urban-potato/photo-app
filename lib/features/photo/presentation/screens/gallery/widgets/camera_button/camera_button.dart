import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../app/router/router.dart' show CameraRoute;
import '../../../../../../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;

class CameraButton extends StatelessWidget {
  const CameraButton({super.key});

  @override
  Widget build(BuildContext context) {
    final router = context.router;
    final responsive = context.read<ResponsiveSizeCubit>();
    final iconSize = responsive.scaleLayout(26);
    final buttonSize = responsive.scaleLayout(50);

    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          router.push(const CameraRoute());
        },
        child: Icon(Icons.camera_alt_rounded, size: iconSize),
      ),
    );
  }
}
