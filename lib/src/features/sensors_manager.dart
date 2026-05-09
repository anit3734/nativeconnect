import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import '../models/gravity_data.dart';

/// A robust controller handling consumption of hardware motion telemetry streams.
///
/// Coordinates real-time extraction and calibration of onboard tri-axial
/// accelerometers, transforming raw dynamic vector force readings into structured
/// application-level force representation models.
class NativeSensorsManager {
  /// Private constructor protecting internal utility space.
  NativeSensorsManager._();

  /// Configures and projects an active telemetry event loop projecting gravity magnitudes.
  ///
  /// Leverages core accelerometer sensors to isolate fundamental directional pull.
  /// Automatically sanitises incoming 3D spatial events and converts them from generic
  /// vector definitions into robust [GravityData] model snapshots.
  ///
  /// Recommended optimization: Release active subscription cycles when hosting widgets 
  /// disengage from foreground pipelines to conserve core device battery capacity.
  ///
  /// [samplingPeriod] mandates active hardware scan frequencies (e.g., [SensorInterval.normalInterval]).
  ///
  /// Returns an isolated stream projection emitting structured [GravityData] asynchronously.
  static Stream<GravityData> watchGravity({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    // Maps system vector events seamlessly into mapped domain object projections.
    return accelerometerEventStream(samplingPeriod: samplingPeriod).map((AccelerometerEvent event) {
      return GravityData(
        x: event.x,
        y: event.y,
        z: event.z,
      );
    });
  }
}
