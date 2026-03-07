class TypedError {
  final PhotoErrorType type;
  final Exception? error;

  TypedError({required this.type, required this.error});
}

enum PhotoErrorType { load, save, delete }

extension PhotoErrorTypeMessage on PhotoErrorType {
  String get message => switch (this) {
    PhotoErrorType.load => 'Error loading photos. Please try again',
    PhotoErrorType.save => 'Error saving photo. Please try again',
    PhotoErrorType.delete => 'Error deleting photo. Please try again',
  };
}
