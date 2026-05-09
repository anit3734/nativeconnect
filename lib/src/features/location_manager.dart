import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/exceptions.dart';
import '../utils/permissions_handler.dart';

/// A specialized controller streamlining interactions with global positioning subsystems.
///
/// This manager standardises hardware location acquisition workflows, integrating
/// initial state interrogation of parent device GPS radios with proactive enforcement
/// of permission prerequisites on the consumption host.
class NativeLocationManager {
  /// Private internal constructor to encapsulate the manager static context.
  NativeLocationManager._();

  /// Aggregates device coordinates by querying real-time planetary positions.
  ///
  /// This executes a rigid verification routine enforcing prerequisite checks:
  /// 1. Verifies global geographic orientation circuits remain active via [Geolocator.isLocationServiceEnabled].
  /// 2. Propels dynamic system authentication request chain targeting physical location handlers.
  ///
  /// Developers control exact behavior through configuration thresholds.
  ///
  /// [accuracy] designates absolute target coordinate refinement priority (e.g. [LocationAccuracy.high]).
  /// [timeLimit] caps absolute execution windows protecting user battery lifecycles.
  ///
  /// Returns a [Position] payload carrying precision geospatial parameters.
  ///
  /// Throws [NativeConnectException] if global services lack active power, permissions are
  /// suppressed by active denial policies, or physical locks timeout prematurely.
  static Future<Position?> getLocation({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration? timeLimit,
  }) async {
    // 1. Absolute verification of raw platform-level radio enablement.
    final bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      throw NativeConnectException(
        code: 'LOCATION_SERVICE_DISABLED',
        message: 'Hardware alert: GPS/Location radio is manually deactivated.',
      );
    }

    // 2. Orchestrated dispatch targeting logical permission authorizations.
    final PermissionStatus status = await NativePermissionsHandler.request(Permission.locationWhenInUse);
    if (status != PermissionStatus.granted) {
      throw NativeConnectException(
        code: 'LOCATION_PERMISSION_DENIED',
        message: 'Access revoked: Logical location verification rejected by OS.',
      );
    }

    try {
      // 3. Explicit query targeting raw latitude-longitude vector projection.
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          timeLimit: timeLimit,
        ),
      );
      return position;
    } catch (e) {
      throw NativeConnectException(
        code: 'LOCATION_FETCH_ERROR',
        message: 'Execution flow failed during coordinate vector sampling.',
        details: e.toString(),
      );
    }
  }
}