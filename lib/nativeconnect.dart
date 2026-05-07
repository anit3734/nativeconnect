import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'src/features/camera_manager.dart';
import 'src/features/location_manager.dart';
import 'src/features/sensors_manager.dart';
import 'src/models/gravity_data.dart';
import 'src/utils/exceptions.dart';

// Package exports so clients get unified types automatically without importing underlying libraries
export 'package:geolocator/geolocator.dart' show Position, LocationAccuracy;
export 'package:image_picker/image_picker.dart' show XFile, CameraDevice;
export 'package:sensors_plus/sensors_plus.dart' show SensorInterval;
export 'src/models/gravity_data.dart' show GravityData;
export 'src/utils/exceptions.dart' show NativeConnectException;

/// The main unified entry point for the **NativeConnect** package.
/// Provides a simple, one-line static API to interact with native hardware features.
class NativeConnect {
  /// Fetches the current location coordinates of the device.
  /// Handles checking global GPS service and requesting location permissions automatically.
  /// [accuracy] lets you balance precise location against speed/battery usage (default is [LocationAccuracy.high]).
  /// Throws a [NativeConnectException] if denied, disabled, or failed.
  static Future<Position?> getLocation({
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) =>
      LocationManager.getCurrentLocation(accuracy: accuracy);

  /// Captures a physical photo using the device camera.
  /// Handles checking and requesting camera permissions automatically.
  /// Supports optional compression using [maxWidth], [maxHeight], and [imageQuality].
  /// [preferredCameraDevice] selects between front and rear cameras.
  /// Throws a [NativeConnectException] if denied or failed.
  static Future<XFile?> takePhoto({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) =>
      CameraManager.takePhoto(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        preferredCameraDevice: preferredCameraDevice,
      );

  /// Watches the physical accelerometer/gravity sensor of the device in real-time.
  /// Returns a stream of [GravityData] containing x, y, z force and magnitude.
  /// [samplingPeriod] lets you balance data frequency against battery consumption (default is [SensorInterval.normalInterval]).
  /// Throws a [NativeConnectException] on sensor access failure.
  static Stream<GravityData> watchGravity({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) =>
      SensorsManager.watchGravity(samplingPeriod: samplingPeriod);
}