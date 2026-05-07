import 'package:permission_handler/permission_handler.dart';
import 'exceptions.dart';

/// Core utility class to check and handle device permissions automatically before calling native APIs.
class NativePermissions {
  /// Checks and requests the given [Permission] automatically.
  /// Throws a [NativeConnectException] if the permission is permanently denied.
  static Future<bool> checkAndRequest(Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      throw NativeConnectException(
        message: 'Permission to access ${permission.toString()} has been permanently denied. Please enable it in device settings.',
        code: 'PERMISSION_PERMANENTLY_DENIED',
      );
    }

    // Request the permission
    final requestResult = await permission.request();
    return requestResult.isGranted;
  }
}