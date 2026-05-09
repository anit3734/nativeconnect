import 'package:permission_handler/permission_handler.dart';

/// An enterprise gatekeeper governing explicit OS-level permission interrogations.
///
/// Centralises dynamic authentication lifecycles of standard capabilities such
/// as locations, camera arrays, or file storage contexts, performing redundant
/// logic verification on conditional states.
class NativePermissionsHandler {
  /// Internal constructor protecting direct instantiation.
  NativePermissionsHandler._();

  /// Initiates a proactive system request cycle targeting the assigned capability.
  ///
  /// Initially executes verification to determine if target capability exists in
  /// pre-granted states. If denied or restricted, manually inflates native OS
  /// dialogs allowing active users to approve or deny transactions.
  ///
  /// [permission] provides definition of targeted discrete system handler (e.g. [Permission.camera]).
  ///
  /// Returns the definitive enum status resolving after completion of explicit request flows.
  static Future<PermissionStatus> request(Permission permission) async {
    // Interrogate persistent repository for currently persisted granting vector.
    final status = await permission.status;
    
    // Logic short-circuit: Bypass OS prompt if previously sanctioned.
    if (status.isGranted) {
      return PermissionStatus.granted;
    }
    
    // Deploy native request prompt to solicit modern consent.
    return await permission.request();
  }
}