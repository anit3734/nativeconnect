import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/exceptions.dart';
import '../utils/permissions_handler.dart';

/// Individual manager handling camera capture with auto-permission checks.
class CameraManager {
  static final ImagePicker _picker = ImagePicker();

  /// Opens the device camera to capture a photo and returns an [XFile].
  /// Allows customization of image resolution, compression, and front/rear camera selection.
  /// Throws a [NativeConnectException] on denial or failure.
  static Future<XFile?> takePhoto({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    try {
      // 1. Auto-check and request camera permission
      final hasPermission = await NativePermissions.checkAndRequest(Permission.camera);
      if (!hasPermission) {
        throw const NativeConnectException(
          message: 'Camera permission was denied.',
          code: 'CAMERA_PERMISSION_DENIED',
        );
      }

      // 2. Capture physical photo from device camera with options
      return await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        preferredCameraDevice: preferredCameraDevice,
      );
    } on NativeConnectException {
      rethrow;
    } catch (e) {
      throw NativeConnectException(
        message: 'Failed to capture photo from camera.',
        code: 'CAMERA_ERROR',
        originalError: e,
      );
    }
  }
}