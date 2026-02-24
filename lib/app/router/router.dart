import 'package:auto_route/auto_route.dart';

import '../../features/photo/screens/camera/index.dart' show CameraScreen;
import '../../features/photo/screens/gallery/index.dart' show GalleryScreen;
import '../../features/home/index.dart' show HomeScreen;
import 'wrappers/photo_wrapper.dart';

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
        AutoRoute(
          page: PhotoFeatureRouteWrapper.page,
          path: 'photo',
          initial: true,
          children: [
            RedirectRoute(path: '', redirectTo: 'gallery'),
            AutoRoute(page: GalleryRoute.page, path: 'gallery', initial: true),
            AutoRoute(page: CameraRoute.page, path: 'camera'),
          ],
        ),
      ],
    ),
  ];
}
