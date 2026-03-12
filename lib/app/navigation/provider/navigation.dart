import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' show BuildContext;

import '../../../shared/presentation/providers/index.dart';
import '../router.dart';

class NavigationProvider implements NavigationProviderI {
  const NavigationProvider();

  @override
  void pop(BuildContext context) {
    final router = context.router;
    router.pop();
  }

  @override
  void maybePop(BuildContext context) {
    final router = context.router;
    router.maybePop();
  }

  @override
  void popToFirst(BuildContext context) {
    final router = context.router;
    router.popUntilRoot();
  }

  @override
  void push(BuildContext context, AppRoute route) {
    final router = context.router;

    switch (route) {
      case GalleryAppRoute():
        router.push(const GalleryRoute());
      case CameraAppRoute():
        router.push(const CameraRoute());
      case PictureAppRoute(:final initialPhoto):
        router.push(PictureRoute(initialPhoto: initialPhoto));
      case SettingsAppRoute():
        router.push(const SettingsRoute());
    }
  }
}
