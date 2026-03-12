import 'dart:io' show File;

import 'package:native_exif/native_exif.dart';
import 'package:talker_flutter/talker_flutter.dart' show Talker;

import '../../domain/services/index.dart' show ExifServiceI;

class ExifService implements ExifServiceI {
  ExifService({required Talker talker}) : _talker = talker;

  final Talker _talker;
  final Map<String, DateTime> _cache = {};

  @override
  Future<DateTime> getCreationDate(String path) async {
    if (_cache.containsKey(path)) return _cache[path]!;

    DateTime? dateTime;
    Exif? exif;

    try {
      exif = await Exif.fromPath(path);
      dateTime = await exif.getOriginalDate();
    } catch (e) {
      _talker.warning(
        'ExifService getCreationDate failed to get date from Exif: $e',
      );
    } finally {
      await exif?.close();
    }

    if (dateTime == null) {
      try {
        dateTime = await File(path).lastModified();
      } catch (e) {
        _talker.warning(
          'ExifService getCreationDate failed to get date from File: $e',
        );

        dateTime = DateTime.now();
      }
    }

    _cache[path] = dateTime;
    return dateTime;
  }
}
