import 'dart:math';

/// A structured immutable data packet encapsulating 3D spatial motion vectors.
///
/// Serves as the canonical format for interpreting raw accelerometer voltages,
/// mapping generic data arrays onto accessible cartesian axial representations.
class GravityData {
  /// Evaluated physical force along lateral horizontal dimension (m/s²).
  final double x;

  /// Evaluated physical force along longitudinal vertical dimension (m/s²).
  final double y;

  /// Evaluated physical force perpendicular to hardware display plane (m/s²).
  final double z;

  /// Instantiates an immutable capsule capturing real-time hardware forces.
  ///
  /// [x] stores measured intensity on horizontal cartesian axis.
  /// [y] stores measured intensity on vertical cartesian axis.
  /// [z] stores measured intensity extending perpendicular to glass face.
  GravityData({
    required this.x,
    required this.y,
    required this.z,
  });

  /// Real-time, computed aggregate vector intensity (overall force scalar).
  ///
  /// Leverages pythagorean Euclidean distance principles `sqrt(x² + y² + z²)`
  /// to aggregate scalar intensity values across entire 3D volume contexts.
  double get magnitude => sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));
}
