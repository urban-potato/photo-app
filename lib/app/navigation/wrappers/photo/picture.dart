import 'package:auto_route/auto_route.dart' show RoutePage;
import 'package:flutter/material.dart';

import '../../../../features/photo/presentation/screens/picture/index.dart'
    show PictureScreen;

@RoutePage(name: 'PictureRoute')
class PictureScreenWrapper extends StatelessWidget {
  const PictureScreenWrapper({super.key, required this.picturePath});

  final String picturePath;

  @override
  Widget build(BuildContext context) {
    return PictureScreen(picturePath: picturePath);
  }
}
