import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../features/settings/presentation/index.dart'
    show SettingsScreen;

@RoutePage(name: 'SettingsRoute')
class SettingsScreenWrapper extends StatelessWidget {
  const SettingsScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsScreen();
  }
}
