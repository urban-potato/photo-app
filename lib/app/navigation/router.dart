import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart' show Key;

import '../../features/photo/presentation/models/index.dart'
    show PhotoItemModelUI;
import '../../shared/presentation/providers/navigation/index.dart'
    show RoutePath;
import 'wrappers/index.dart';

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
      page: HomeRouteWrapper.page,
      path: RoutePath.root.relative,
      initial: true,
      children: [
        RedirectRoute(path: '', redirectTo: RoutePath.photo.relative),
        AutoRoute(
          page: PhotoFeatureRouteWrapper.page,
          path: RoutePath.photo.relative,
          initial: true,
          children: [
            RedirectRoute(path: '', redirectTo: RoutePath.gallery.relative),
            AutoRoute(
              page: GalleryRoute.page,
              path: RoutePath.gallery.relative,
              initial: true,
            ),
            AutoRoute(page: CameraRoute.page, path: RoutePath.camera.relative),
            AutoRoute(
              page: PictureRoute.page,
              path: RoutePath.picture.relative,
            ),
          ],
        ),
        AutoRoute(page: SettingsRoute.page, path: RoutePath.settings.relative),
      ],
    ),
  ];
}
