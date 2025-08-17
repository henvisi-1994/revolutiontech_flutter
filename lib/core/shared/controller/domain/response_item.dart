class ResponseItem<T, R> {
  final R response;
  final T result;

  ResponseItem({
    required this.response,
    required this.result,
  });
}
