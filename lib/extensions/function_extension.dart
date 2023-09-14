extension Exists<T, R> on R Function(T) {
  /// Calls the function if argument is not null,
  /// otherwise does nothing.
  R? ifArg(T? argument) => argument == null ? null : this(argument);
}
