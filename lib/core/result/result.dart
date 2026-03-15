sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  R when<R>({
    required R Function(T value) success,
    required R Function(String message, Object? error) failure,
  }) {
    final self = this;
    if (self is Success<T>) {
      return success(self.value);
    }
    if (self is Failure<T>) {
      return failure(self.message, self.error);
    }
    throw StateError('Unknown Result type: $self');
  }
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure(this.message, {this.error});

  final String message;
  final Object? error;
}
