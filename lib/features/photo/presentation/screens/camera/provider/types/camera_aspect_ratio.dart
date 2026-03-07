enum CameraAspectRatio {
  small(3 / 4),
  big(9 / 16),
  square(1 / 1);

  double get portrait => _ratio;
  double get landscape => 1 / _ratio;

  final double _ratio;
  const CameraAspectRatio(this._ratio);
}
