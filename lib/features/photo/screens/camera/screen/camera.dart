import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../widgets/camera/index.dart' show CameraWidget;

@RoutePage()
class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('New photo'),
        elevation: 0,
        backgroundColor:
            theme.appBarTheme.backgroundColor?.withValues(alpha: 0.3) ??
            Colors.black.withValues(alpha: 0.3),
      ),
      body: const CameraWidget(),
    );
  }
}
