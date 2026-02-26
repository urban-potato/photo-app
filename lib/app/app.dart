import 'package:flutter/material.dart';

import 'router/router.dart';
import 'theme/index.dart' show TAppTheme;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter();

    return MaterialApp.router(
      routerConfig: router.config(),
      debugShowCheckedModeBanner: false,
      title: 'Photo App',
      theme: TAppTheme.lightTheme(),
    );
  }
}
