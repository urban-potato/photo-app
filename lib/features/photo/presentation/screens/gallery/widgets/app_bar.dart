import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      pinned: true,
      title: Text('My photos'),
    );
  }
}
