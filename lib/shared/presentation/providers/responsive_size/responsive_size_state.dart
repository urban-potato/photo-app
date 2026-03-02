import 'package:equatable/equatable.dart';

class ResponsiveSizeState extends Equatable {
  final double screenWidth;
  final double screenHeight;
  final bool isVertical;

  const ResponsiveSizeState({
    required this.isVertical,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  List<Object?> get props => [isVertical, screenWidth, screenHeight];
}
