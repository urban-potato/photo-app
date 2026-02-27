// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [CameraScreen]
class CameraRoute extends PageRouteInfo<void> {
  const CameraRoute({List<PageRouteInfo>? children})
    : super(CameraRoute.name, initialChildren: children);

  static const String name = 'CameraRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CameraScreen();
    },
  );
}

/// generated route for
/// [GalleryScreen]
class GalleryRoute extends PageRouteInfo<void> {
  const GalleryRoute({List<PageRouteInfo>? children})
    : super(GalleryRoute.name, initialChildren: children);

  static const String name = 'GalleryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GalleryScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [PhotoFeatureWrapper]
class PhotoFeatureRouteWrapper extends PageRouteInfo<void> {
  const PhotoFeatureRouteWrapper({List<PageRouteInfo>? children})
    : super(PhotoFeatureRouteWrapper.name, initialChildren: children);

  static const String name = 'PhotoFeatureRouteWrapper';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const PhotoFeatureWrapper());
    },
  );
}

/// generated route for
/// [PictureScreen]
class PictureRoute extends PageRouteInfo<PictureRouteArgs> {
  PictureRoute({
    Key? key,
    required String picturePath,
    List<PageRouteInfo>? children,
  }) : super(
         PictureRoute.name,
         args: PictureRouteArgs(key: key, picturePath: picturePath),
         initialChildren: children,
       );

  static const String name = 'PictureRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PictureRouteArgs>();
      return PictureScreen(key: args.key, picturePath: args.picturePath);
    },
  );
}

class PictureRouteArgs {
  const PictureRouteArgs({this.key, required this.picturePath});

  final Key? key;

  final String picturePath;

  @override
  String toString() {
    return 'PictureRouteArgs{key: $key, picturePath: $picturePath}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PictureRouteArgs) return false;
    return key == other.key && picturePath == other.picturePath;
  }

  @override
  int get hashCode => key.hashCode ^ picturePath.hashCode;
}
