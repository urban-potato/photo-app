import '../../../../../features/photo/presentation/models/index.dart'
    show PhotoItemModelUI;

sealed class AppRoute {
  const AppRoute();
}

class GalleryAppRoute extends AppRoute {
  const GalleryAppRoute();
}

class CameraAppRoute extends AppRoute {
  const CameraAppRoute();
}

class PictureAppRoute extends AppRoute {
  const PictureAppRoute({required this.initialPhoto});

  final PhotoItemModelUI initialPhoto;
}

class SettingsAppRoute extends AppRoute {
  const SettingsAppRoute();
}
