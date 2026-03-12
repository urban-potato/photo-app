import 'package:equatable/equatable.dart';

import 'photo_item.dart';

class PhotoModelUI extends Equatable {
  final List<PhotoItemModelUI> photosList;

  const PhotoModelUI({required this.photosList});

  @override
  List<Object?> get props => [photosList];
}
