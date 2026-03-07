import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../shared/presentation/providers/responsive_size/index.dart';
import '../../../../../../shared/presentation/theme/index.dart' show AppTheme;
import '../../../../../../shared/presentation/utils/index.dart'
    show getUpdatedSystemUiStyle;
import '../widgets/index.dart';
import 'wrappers/system_ui.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.read<ResponsiveSizeCubit>();
    final cameraTheme = AppTheme.dark(responsive);

    return Theme(
      data: cameraTheme,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: getUpdatedSystemUiStyle(
          cameraTheme.brightness,
          cameraTheme.colorScheme,
        ),
        child: const CameraSystemUi(
          child: Scaffold(body: SafeArea(child: CameraContentBuilder())),
        ),
      ),
    );
  }
}
