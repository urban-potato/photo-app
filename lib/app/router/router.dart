import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart' show Key;

import '../../features/photo/index.dart' show GalleryScreen, PictureScreen;
import '../../features/settings/index.dart' show SettingsScreen;
import 'wrappers/camera.dart';
import 'wrappers/photo.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.custom(
    transitionsBuilder: TransitionsBuilders.fadeIn,
    duration: const Duration(milliseconds: 300),
    reverseDuration: const Duration(milliseconds: 300),
    opaque: true,
  );

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: PhotoFeatureRouteWrapper.page,
      path: '/',
      initial: true,
      children: [
        RedirectRoute(path: '', redirectTo: 'gallery'),
        AutoRoute(page: GalleryRoute.page, path: 'gallery', initial: true),
        AutoRoute(page: CameraRoute.page, path: 'camera'),
        AutoRoute(page: PictureRoute.page, path: 'picture'),
        AutoRoute(page: SettingsRoute.page, path: 'settings'),
      ],
    ),
  ];
}
