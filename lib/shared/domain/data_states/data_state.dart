sealed class DataState<T> {
  final T? data;
  final Exception? error;

  const DataState({this.data, this.error});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess({required T super.data});
}

class DataFailed<T> extends DataState<T> {
  const DataFailed({required Exception super.error});
}
