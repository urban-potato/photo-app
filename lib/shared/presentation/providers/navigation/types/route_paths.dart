enum RoutePath {
  root('/'),
  photo('photo'),
  gallery('gallery'),
  camera('camera'),
  picture('picture'),
  settings('settings');

  final String relative;
  const RoutePath(this.relative);
}
