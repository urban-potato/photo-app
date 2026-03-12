import 'package:auto_route/auto_route.dart' show RoutePage;
import 'package:flutter/material.dart';

import '../../../../features/photo/presentation/models/index.dart'
    show PhotoItemModelUI;
import '../../../../features/photo/presentation/screens/picture/index.dart'
    show PictureScreen;

@RoutePage(name: 'PictureRoute')
class PictureScreenWrapper extends StatelessWidget {
  const PictureScreenWrapper({super.key, required this.initialPhoto});

  final PhotoItemModelUI initialPhoto;

  @override
  Widget build(BuildContext context) {
    return PictureScreen(initialPhoto: initialPhoto);
  }
}
