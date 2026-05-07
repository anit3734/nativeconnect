import 'dart:math';

/// A data model representing three-dimensional gravity or accelerometer sensor data.
class GravityData {
  /// Acceleration along the X-axis.
  final double x;

  /// Acceleration along the Y-axis.
  final double y;

  /// Acceleration along the Z-axis.
  final double z;

  /// Creates a new [GravityData] instance with the given coordinate values.
  const GravityData({
    required this.x,
    required this.y,
    required this.z,
  });

  /// Computes the vector magnitude of the gravity/acceleration force.
  double get magnitude => sqrt(x * x + y * y + z * z);

  @override
  String toString() {
    return 'GravityData(x: ${x.toStringAsFixed(2)}, y: ${y.toStringAsFixed(2)}, z: ${z.toStringAsFixed(2)}, magnitude: ${magnitude.toStringAsFixed(2)})';
  }
}
