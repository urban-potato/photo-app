class Descriptor<T> {
  const Descriptor({
    required this.storageKey,
    required this.defaultValue,
    required this.fromStorage,
    required this.toStorage,
  });

  final String storageKey;
  final T defaultValue;
  final T Function(String raw) fromStorage;
  final String Function(T value) toStorage;
}
