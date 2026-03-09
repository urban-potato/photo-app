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
  const PictureAppRoute({required this.picturePath});

  final String picturePath;
}

class SettingsAppRoute extends AppRoute {
  const SettingsAppRoute();
}
