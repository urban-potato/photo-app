import '../../../provider/index.dart' show PhotoErrorType;

String getPhotoFailureErrorMessage(PhotoErrorType errorType) {
  final message = switch (errorType) {
    PhotoErrorType.load => 'Error loading photos. Please try again',
    PhotoErrorType.save => 'Error saving photo. Please try again',
    PhotoErrorType.delete => 'Error deleting photo. Please try again',
  };

  return message;
}
