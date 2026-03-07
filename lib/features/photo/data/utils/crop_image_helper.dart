import 'dart:typed_data' show Uint8List;
import 'package:image/image.dart' as img_lib;

Future<Uint8List> cropImageToRatio(
  Uint8List bytes,
  double targetAspectRatio,
) async {
  final image = img_lib.decodeImage(bytes);

  if (image == null) {
    throw Exception('Failed to decode image');
  }

  final originalWidth = image.width;
  final originalHeight = image.height;
  final originalAspectRatio = originalWidth / originalHeight;

  int newWidth = originalWidth;
  int newHeight = originalHeight;
  int offsetX = 0;
  int offsetY = 0;

  if (originalAspectRatio > targetAspectRatio) {
    newWidth = (originalHeight * targetAspectRatio).round();
    offsetX = ((originalWidth - newWidth) / 2).round();
  } else if (originalAspectRatio < targetAspectRatio) {
    newHeight = (originalWidth / targetAspectRatio).round();
    offsetY = ((originalHeight - newHeight) / 2).round();
  }

  final croppedImage = img_lib.copyCrop(
    image,
    x: offsetX,
    y: offsetY,
    width: newWidth,
    height: newHeight,
  );

  final croppedBytes = img_lib.encodeJpg(croppedImage, quality: 100);

  return croppedBytes;
}
