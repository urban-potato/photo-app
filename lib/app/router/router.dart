import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart' show Key;

import '../../features/photo/presentation/screens/gallery/index.dart'
    show GalleryScreen;
import '../../features/home/index.dart' show HomeScreen;
import '../../features/photo/presentation/screens/picture/index.dart'
    show PictureScreen;
import 'wrappers/camera.dart';
import 'wrappers/photo.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: HomeRoute.page,
      path: '/',
      initial: true,
      children: [
        RedirectRoute(path: '', redirectTo: 'photo'),
        AutoRoute(
          page: PhotoFeatureRouteWrapper.page,
          path: 'photo',
          initial: true,
          children: [
            RedirectRoute(path: '', redirectTo: 'gallery'),
            AutoRoute(page: GalleryRoute.page, path: 'gallery', initial: true),
            AutoRoute(page: CameraRoute.page, path: 'camera'),
            AutoRoute(page: PictureRoute.page, path: 'picture'),
          ],
        ),
      ],
    ),
  ];
}
