sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

class Failure<T> extends Result<T> {
  const Failure(this.message, {this.error, this.stackTrace});

  final String message;
  final Exception? error;
  final StackTrace? stackTrace;
}