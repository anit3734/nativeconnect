/// Custom exception class to handle platform-specific errors and permission denials gracefully.
class NativeConnectException implements Exception {
  /// User-friendly description of the error.
  final String message;

  /// Unique error code to identify the type of error.
  final String code;

  /// The underlying original error or stack trace, if available.
  final dynamic originalError;

  /// Creates a new [NativeConnectException] with required [message] and [code].
  const NativeConnectException({
    required this.message,
    required this.code,
    this.originalError,
  });

  @override
  String toString() {
    if (originalError != null) {
      return 'NativeConnectException [$code]: $message (Original: $originalError)';
    }
    return 'NativeConnectException [$code]: $message';
  }
}
