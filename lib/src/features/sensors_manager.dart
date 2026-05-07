import 'package:sensors_plus/sensors_plus.dart';
import '../models/gravity_data.dart';
import '../utils/exceptions.dart';

/// Individual manager handling device motion and sensor streams.
class SensorsManager {
  /// Watches the device's accelerometer/gravity data in real-time.
  /// Allows customization of the sensor sampling rate via [samplingPeriod].
  /// Returns a stream of [GravityData] containing 3D coordinate forces and magnitude.
  /// Throws a [NativeConnectException] if sensor stream is unavailable.
  static Stream<GravityData> watchGravity({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    try {
      return accelerometerEventStream(samplingPeriod: samplingPeriod).map((event) {
        return GravityData(
          x: event.x,
          y: event.y,
          z: event.z,
        );
      });
    } catch (e) {
      throw NativeConnectException(
        message: 'Failed to access device accelerometer/gravity sensors.',
        code: 'SENSORS_ERROR',
        originalError: e,
      );
    }
  }
}
