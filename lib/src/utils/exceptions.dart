/// A high-level, typed encapsulation representing logical and platform-layer failures.
///
/// Serves as the canonical standard container ensuring cross-thread uniformity
/// across discrete Android-iOS platform channels, ensuring consuming developers 
/// capture cleanly serialized context rather than opaque native runtime blobs.
class NativeConnectException implements Exception {
  /// High-definition identifier classifying specific fault context (e.g. "PERMISSION_DENIED").
  final String code;

  /// Human-comprehensible descriptive text illustrating the error environment.
  final String message;

  /// Granular low-level underlying platform exception strings, null if irrelevant.
  final String? details;

  /// Constructs a durable custom exception container holding detailed execution metadata.
  ///
  /// [code] assigns consistent key identifiers targeting systematic detection logic.
  /// [message] offers developer-centric context explanations of causality.
  /// [details] appends secondary system stack-traces or raw native stack captures.
  NativeConnectException({
    required this.code,
    required this.message,
    this.details,
  });

  /// Rejects normal instances and converts runtime references into human-legible debug definitions.
  @override
  String toString() {
    return 'NativeConnectException(code: $code, message: $message, details: $details)';
  }
}
