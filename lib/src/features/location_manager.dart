import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/exceptions.dart';
import '../utils/permissions_handler.dart';

/// Individual manager handling location coordinate fetching with auto-permission checks.
class LocationManager {
  /// Fetches the current physical coordinates of the device with a customizable [accuracy].
  /// Checks if global GPS services are enabled first.
  /// Throws a [NativeConnectException] on denial or failure.
  static Future<Position?> getCurrentLocation({
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) async {
    try {
      // 1. Check if global GPS / Location services are enabled on the device
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        throw const NativeConnectException(
          message: 'Location services are disabled on your device. Please enable GPS in your system settings.',
          code: 'LOCATION_SERVICE_DISABLED',
        );
      }

      // 2. Auto-check and request location permission
      final hasPermission = await NativePermissions.checkAndRequest(Permission.location);
      if (!hasPermission) {
        throw const NativeConnectException(
          message: 'Location permission was denied.',
          code: 'LOCATION_PERMISSION_DENIED',
        );
      }

      // 3. Get physical coordinates using modern LocationSettings
      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          timeLimit: const Duration(seconds: 15), // Prevents hanging indefinitely
        ),
      );
    } on NativeConnectException {
      rethrow;
    } catch (e) {
      throw NativeConnectException(
        message: 'Failed to retrieve current device coordinates.',
        code: 'LOCATION_ERROR',
        originalError: e,
      );
    }
  }
}