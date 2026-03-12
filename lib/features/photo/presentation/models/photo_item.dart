import 'package:equatable/equatable.dart';

class PhotoItemModelUI extends Equatable {
  final String path;
  final DateTime dateTime;

  const PhotoItemModelUI({required this.path, required this.dateTime});

  @override
  List<Object?> get props => [path, dateTime];
}
