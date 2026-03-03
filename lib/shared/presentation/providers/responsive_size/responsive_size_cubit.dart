import 'package:flutter/foundation.dart' show PlatformDispatcher;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'responsive_size_state.dart';

class ResponsiveSizeCubit extends Cubit<ResponsiveSizeState>
    with WidgetsBindingObserver {
  ResponsiveSizeCubit()
    : super(
        const ResponsiveSizeState(
          screenWidth: _defaultWidth,
          screenHeight: _defaultHeight,
          isVertical: true,
        ),
      ) {
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addObserver(this);
    _updateScreenSizeFromMetrics();
  }

  static const double _defaultWidth = 360;
  static const double _defaultHeight = 640;

  static const double _designBaseWidth = _defaultWidth;
  static const double _tabletBreakpoint = 600;

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _updateScreenSizeFromMetrics();
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  void _updateScreenSizeFromMetrics() {
    final view = PlatformDispatcher.instance.views.first;

    final width = view.physicalSize.width / view.devicePixelRatio;
    final height = view.physicalSize.height / view.devicePixelRatio;

    final isVertical = height >= width;

    if (width != state.screenWidth ||
        height != state.screenHeight ||
        isVertical != state.isVertical) {
      emit(
        ResponsiveSizeState(
          screenWidth: width,
          screenHeight: height,
          isVertical: isVertical,
        ),
      );
    }
  }

  bool get isTablet =>
      (state.screenWidth >= _tabletBreakpoint) && state.isVertical;

  //
  // Scale factors
  //
  double get layoutScale {
    final scale = state.screenWidth / _designBaseWidth;
    return scale.clamp(0.85, 1.30);
  }

  double get textScale {
    final scale = state.screenWidth / _designBaseWidth;
    return scale.clamp(1.0, 1.20);
  }

  //
  // Base scale methods
  //

  double scaleLayout(double value) => value * layoutScale;
  double scaleText(double value) => value * textScale;

  //
  // Design sizes
  //

  // ---- Spacing ----
  double get spacingXXS => scaleLayout(2);
  double get spacingXS => scaleLayout(4);
  double get spacingS => scaleLayout(8);
  double get spacingM => scaleLayout(12);
  double get spacingL => scaleLayout(16);
  double get spacingXL => scaleLayout(24);
  double get spacingXXL => scaleLayout(32);

  // ---- Padding ----
  double get paddingXXXS => scaleLayout(2);
  double get paddingXXS => scaleLayout(4);
  double get paddingXS => scaleLayout(8);
  double get paddingS => scaleLayout(12);
  double get paddingM => scaleLayout(16);
  double get paddingL => scaleLayout(20);
  double get paddingXL => scaleLayout(24);
  double get paddingXXL => scaleLayout(32);

  double get screenHPadding => scaleLayout(16);
  double get screenVPadding => scaleLayout(20);

  // ---- Radius ----
  double get radiusXXS => scaleLayout(2);
  double get radiusXS => scaleLayout(4);
  double get radiusS => scaleLayout(8);
  double get radiusM => scaleLayout(12);
  double get radiusL => scaleLayout(16);
  double get radiusXL => scaleLayout(24);
  double get radiusXXL => scaleLayout(32);

  double get radiusCircular => 1000;

  // ---- Icons ----
  double get iconXXS => scaleLayout(12);
  double get iconXS => scaleLayout(16);
  double get iconS => scaleLayout(20);
  double get iconM => scaleLayout(24);
  double get iconL => scaleLayout(28);
  double get iconXL => scaleLayout(32);
  double get iconXXL => scaleLayout(40);
  double get iconXXXL => scaleLayout(50);

  // ---- Text ----
  double get textXXS => scaleText(10);
  double get textXS => scaleText(12);
  double get textS => scaleText(14);
  double get textM => scaleText(16);
  double get textL => scaleText(18);
  double get textXL => scaleText(22);
  double get textXXL => scaleText(26);

  double get textHuge => scaleText(80);
}
