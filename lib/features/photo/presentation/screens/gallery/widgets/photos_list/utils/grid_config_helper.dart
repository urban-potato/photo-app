class PhotosGridConfig {
  const PhotosGridConfig._();

  static const int _phonePortrait = 2;
  static const int _tabletPortrait = 3;
  static const int _landscape = 5;
  static const double _aspectRatio = 1.0;

  static ({int crossAxisCount, double childAspectRatio}) get({
    required bool isPortrait,
    required bool isTablet,
  }) {
    if (isPortrait) {
      return isTablet
          ? (crossAxisCount: _tabletPortrait, childAspectRatio: _aspectRatio)
          : (crossAxisCount: _phonePortrait, childAspectRatio: _aspectRatio);
    }

    return (crossAxisCount: _landscape, childAspectRatio: _aspectRatio);
  }
}
