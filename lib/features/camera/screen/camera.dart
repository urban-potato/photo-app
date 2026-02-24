import 'package:auto_route/auto_route.dart' show RoutePage;
import 'package:flutter/material.dart';

@RoutePage()
class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New photo')),
      body: SafeArea(child: Center(child: Text('Camera screen'))),
    );
  }
}
