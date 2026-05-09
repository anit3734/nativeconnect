import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/exceptions.dart';

/// A specialized manager handling all native sharing integrations.
///
/// This class provides convenient, single-line static methods to invoke native
/// system sharing sheets for distributing text strings and files across apps.
class NativeShareManager {
  /// Private constructor to prevent instantiation.
  NativeShareManager._();

  /// Dispatches plain text data to the device's native sharing ecosystem.
  ///
  /// This method triggers the system sharing dialog. You can optionally
  /// supply a [subject] line which is utilized by certain consumers like 
  /// email clients.
  ///
  /// [text] represents the primary string body to distribute.
  /// [subject] is an optional topic line for email or message headers.
  /// [sharePositionOrigin] is mandatory on iPad/macOS to anchor the popover window.
  ///
  /// Returns the final [ShareResult] representing the user's share action outcome.
  ///
  /// Throws a [NativeConnectException] if the underlying platform channel experiences
  /// failures during invocation.
  static Future<ShareResult> shareText({
    required String text,
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    try {
      final ShareResult result = await SharePlus.instance.share(
        ShareParams(
          text: text,
          subject: subject,
          sharePositionOrigin: sharePositionOrigin,
        ),
      );
      return result;
    } on PlatformException catch (e) {
      throw NativeConnectException(
        code: 'SHARE_PLATFORM_ERROR',
        message: 'Failed to initiate text share action.',
        details: e.message,
      );
    } catch (e) {
      throw NativeConnectException(
        code: 'SHARE_UNKNOWN_ERROR',
        message: 'An unexpected anomaly occurred during text share.',
        details: e.toString(),
      );
    }
  }

  /// Dispatches a list of media files to the device's native sharing ecosystem.
  ///
  /// This acts identically to [shareText] but processes physical data references
  /// encapsulated in [XFile] structures.
  ///
  /// [files] consists of one or multiple cross-file references to distribute.
  /// [text] optional body string to accompany the file attachments.
  /// [subject] optional header subject for the sharing intention.
  /// [sharePositionOrigin] is required on iPad/macOS to define popover coordinates.
  ///
  /// Returns a [ShareResult] defining whether the sharing transaction completed.
  ///
  /// Throws a [NativeConnectException] if system attachments are forbidden or inaccessible.
  static Future<ShareResult> shareFiles({
    required List<XFile> files,
    String? text,
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    try {
      final ShareResult result = await SharePlus.instance.share(
        ShareParams(
          files: files,
          text: text,
          subject: subject,
          sharePositionOrigin: sharePositionOrigin,
        ),
      );
      return result;
    } on PlatformException catch (e) {
      throw NativeConnectException(
        code: 'SHARE_FILE_PLATFORM_ERROR',
        message: 'Failed to package and dispatch physical files.',
        details: e.message,
      );
    } catch (e) {
      throw NativeConnectException(
        code: 'SHARE_FILE_UNKNOWN_ERROR',
        message: 'An anomaly blocked the transmission of system files.',
        details: e.toString(),
      );
    }
  }
}