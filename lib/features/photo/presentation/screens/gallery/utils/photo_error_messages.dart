import '../../../provider/index.dart' show PhotoErrorType;

extension PhotoErrorTypeMessage on PhotoErrorType {
  String get message => switch (this) {
    PhotoErrorType.load => 'Error loading photos. Please try again',
    PhotoErrorType.save => 'Error saving photo. Please try again',
    PhotoErrorType.delete => 'Error deleting photo. Please try again',
  };
}
