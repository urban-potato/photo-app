import 'package:equatable/equatable.dart';

class PhotoItemModelDomain extends Equatable {
  final String path;
  final DateTime dateTime;

  const PhotoItemModelDomain({required this.path, required this.dateTime});

  @override
  List<Object?> get props => [path, dateTime];
}
