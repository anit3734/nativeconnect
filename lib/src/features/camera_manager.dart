import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/exceptions.dart';
import '../utils/permissions_handler.dart';

/// A specialized manager facilitating device camera access and interactions.
///
/// This class encapsulates all camera workflow operations, encompassing automatic
/// permissions requesting, triggering system shutter activities, and executing
/// compression transformations on captured graphical assets.
class NativeCameraManager {
  /// Private internal constructor protecting instantiation.
  NativeCameraManager._();

  /// Triggers device camera activity to capture a photographic record.
  ///
  /// Automatically performs proactive inspection and orchestration of native system
  /// permissions prior to invoking the image picking subsystem.
  ///
  /// If relevant system authorisations are withheld, a rigorous [NativeConnectException] 
  /// is projected back to the caller context.
  ///
  /// [maxWidth] assigns specific horizontal pixel boundary constraints to generated output.
  /// [maxHeight] assigns specific vertical pixel boundary constraints to generated output.
  /// [imageQuality] enforces a numeric compression scaling factor between 0 and 100.
  /// [preferredCameraDevice] orchestrates fallback orientation preference between rear/front.
  ///
  /// Returns a future delivering null if discarded, or an [XFile] containing 
  /// storage path metadata upon explicit capture operation.
  ///
  /// Throws custom [NativeConnectException] on permission denial, cancellation, or 
  /// low-level native sensor errors.
  static Future<XFile?> takePhoto({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    // 1. Automated check & request pipeline.
    final permission = await NativePermissionsHandler.request(Permission.camera);
    if (permission != PermissionStatus.granted) {
      throw NativeConnectException(
        code: 'CAMERA_PERMISSION_DENIED',
        message: 'Execution halted: Camera sensor permission was definitively denied.',
      );
    }

    try {
      // 2. Instantiation of underlying system capture logic.
      final ImagePicker picker = ImagePicker();
      
      // 3. Secure secure cross-thread photo execution hook.
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        preferredCameraDevice: preferredCameraDevice,
      );
      
      return photo;
    } catch (e) {
      throw NativeConnectException(
        code: 'CAMERA_CAPTURE_ERROR',
        message: 'An anomaly prohibited interaction with native camera APIs.',
        details: e.toString(),
      );
    }
  }
}