import 'package:equatable/equatable.dart';

import 'photo_item.dart';

class PhotoModelDomain extends Equatable {
  final List<PhotoItemModelDomain> photosList;

  const PhotoModelDomain({required this.photosList});

  @override
  List<Object?> get props => [photosList];
}
