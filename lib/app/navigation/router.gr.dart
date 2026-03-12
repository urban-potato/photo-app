// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [CameraScreenWrapper]
class CameraRoute extends PageRouteInfo<void> {
  const CameraRoute({List<PageRouteInfo>? children})
    : super(CameraRoute.name, initialChildren: children);

  static const String name = 'CameraRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CameraScreenWrapper();
    },
  );
}

/// generated route for
/// [GalleryScreenWrapper]
class GalleryRoute extends PageRouteInfo<void> {
  const GalleryRoute({List<PageRouteInfo>? children})
    : super(GalleryRoute.name, initialChildren: children);

  static const String name = 'GalleryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GalleryScreenWrapper();
    },
  );
}

/// generated route for
/// [HomeScreenWrapper]
class HomeRouteWrapper extends PageRouteInfo<void> {
  const HomeRouteWrapper({List<PageRouteInfo>? children})
    : super(HomeRouteWrapper.name, initialChildren: children);

  static const String name = 'HomeRouteWrapper';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreenWrapper();
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
/// [PictureScreenWrapper]
class PictureRoute extends PageRouteInfo<PictureRouteArgs> {
  PictureRoute({
    Key? key,
    required PhotoItemModelUI initialPhoto,
    List<PageRouteInfo>? children,
  }) : super(
         PictureRoute.name,
         args: PictureRouteArgs(key: key, initialPhoto: initialPhoto),
         initialChildren: children,
       );

  static const String name = 'PictureRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PictureRouteArgs>();
      return PictureScreenWrapper(
        key: args.key,
        initialPhoto: args.initialPhoto,
      );
    },
  );
}

class PictureRouteArgs {
  const PictureRouteArgs({this.key, required this.initialPhoto});

  final Key? key;

  final PhotoItemModelUI initialPhoto;

  @override
  String toString() {
    return 'PictureRouteArgs{key: $key, initialPhoto: $initialPhoto}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PictureRouteArgs) return false;
    return key == other.key && initialPhoto == other.initialPhoto;
  }

  @override
  int get hashCode => key.hashCode ^ initialPhoto.hashCode;
}

/// generated route for
/// [SettingsScreenWrapper]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsScreenWrapper();
    },
  );
}
