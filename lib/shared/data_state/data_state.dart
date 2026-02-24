sealed class DataState<T> {
  final T? data;
  final Exception? error;

  const DataState({this.data, this.error});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess({required T data}) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed({required Exception error}) : super(error: error);
}
