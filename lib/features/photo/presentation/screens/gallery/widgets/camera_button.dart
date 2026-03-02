import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../../app/router/router.dart' show CameraRoute;

class CameraButton extends StatelessWidget {
  const CameraButton({super.key});

  @override
  Widget build(BuildContext context) {
    final router = context.router;

    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: () {
        router.push(const CameraRoute());
      },
      child: const Icon(Icons.camera_alt_rounded),
    );
  }
}
