import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraSystemUi extends StatefulWidget {
  const CameraSystemUi({super.key, required this.child});

  final Widget child;

  @override
  State<CameraSystemUi> createState() => _CameraSystemUiState();
}

class _CameraSystemUiState extends State<CameraSystemUi> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
