import 'package:auto_route/auto_route.dart' show RoutePage, AutoRouter;
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
