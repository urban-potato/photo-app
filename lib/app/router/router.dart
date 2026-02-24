import 'package:auto_route/auto_route.dart';

import '../../features/camera/index.dart' show CameraScreen;
import '../../features/gallery/index.dart' show GalleryScreen;
import '../../features/home/index.dart' show HomeScreen;

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
        RedirectRoute(path: '', redirectTo: 'gallery'),
        AutoRoute(page: GalleryRoute.page, path: 'gallery', initial: true),
        AutoRoute(page: CameraRoute.page, path: 'camera'),
      ],
    ),
  ];
}
