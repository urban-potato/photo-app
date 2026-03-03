import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../../../../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;

class TakePictureButton extends StatelessWidget {
  const TakePictureButton({super.key, required this.takePicture});

  final Future<void> Function() takePicture;

  @override
  Widget build(BuildContext context) {
    final responsive = context.watch<ResponsiveSizeCubit>();
    final paddingV = responsive.paddingXXXS;
    final iconSize = responsive.iconXXXL;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: paddingV),
      child: IconButton(
        onPressed: () async {
          await takePicture();
        },
        icon: const Icon(Icons.camera),
        iconSize: iconSize,
      ),
    );
  }
}
