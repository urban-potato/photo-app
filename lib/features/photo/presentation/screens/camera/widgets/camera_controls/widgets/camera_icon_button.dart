import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../../../../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;

class CameraIconButton extends StatelessWidget {
  const CameraIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconSize,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double? iconSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final responsive = context.watch<ResponsiveSizeCubit>();
    final iconSize = this.iconSize ?? responsive.iconM;
    final disabledColor = Colors.grey[400];

    return IconButton(
      onPressed: onPressed,
      disabledColor: disabledColor,
      icon: Icon(icon, size: iconSize, color: iconColor),
    );
  }
}
