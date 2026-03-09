import 'package:auto_route/auto_route.dart' show RoutePage;
import 'package:flutter/material.dart';

import '../../../../features/photo/presentation/screens/gallery/index.dart'
    show GalleryScreen;

@RoutePage(name: 'GalleryRoute')
class GalleryScreenWrapper extends StatelessWidget {
  const GalleryScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const GalleryScreen();
  }
}
