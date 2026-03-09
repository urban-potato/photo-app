import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../shared/presentation/providers/index.dart'
    show NavigationProviderI, CameraAppRoute;
import '../../../../../../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;

class CameraButton extends StatelessWidget {
  const CameraButton({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.read<ResponsiveSizeCubit>();
    final iconSize = responsive.scaleLayout(26);
    final buttonSize = responsive.scaleLayout(50);

    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          if (context.mounted) {
            final router = context.read<NavigationProviderI>();
            router.push(context, const CameraAppRoute());
          }
        },
        child: Icon(Icons.camera_alt_rounded, size: iconSize),
      ),
    );
  }
}
