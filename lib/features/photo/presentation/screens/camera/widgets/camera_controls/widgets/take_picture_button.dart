import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../../../../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;
import 'camera_icon_button.dart';

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
      child: CameraIconButton(
        icon: Icons.camera,
        onPressed: takePicture,
        iconSize: iconSize,
      ),
    );
  }
}
