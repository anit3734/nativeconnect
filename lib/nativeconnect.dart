
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:share_plus/share_plus.dart';

import 'src/features/camera_manager.dart';
import 'src/features/location_manager.dart';
import 'src/features/sensors_manager.dart';
import 'src/features/share_manager.dart';
import 'src/models/gravity_data.dart';

export 'package:geolocator/geolocator.dart' show Position, LocationAccuracy;
export 'package:image_picker/image_picker.dart' show XFile, CameraDevice;
export 'package:sensors_plus/sensors_plus.dart' show SensorInterval;
export 'package:share_plus/share_plus.dart' show ShareResult, ShareResultStatus;

export 'src/models/gravity_data.dart';
export 'src/utils/exceptions.dart';

/// The centralized canonical entry-point into all managed native ecosystem features.
///
/// This class operates as a consolidated facade, exposing single-line, production-ready 
/// static API handlers for hardware locations, visual capture rigs, telemetry acceleration 
/// circuits, and universal share channels.
class NativeConnect {
  /// Protects internal library state from manual, non-static instantiations.
  NativeConnect._();

  // --- Feature 1: Location Ecosystem ---

  /// Queries current geographical coordinate parameters from hardware GPS radios.
  ///
  /// Internally automates verification of radio power and projection of system
  /// permissions modals on-the-fly.
  ///
  /// [accuracy] adjusts precision vs processing cost tuning (e.g. [LocationAccuracy.high]).
  /// [timeLimit] dictates maximal window period valid before auto-abort trigger.
  ///
  /// Returns a fully parsed [Position] reference if successful.
  static Future<Position?> getLocation({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration? timeLimit,
  }) =>
      NativeLocationManager.getLocation(
        accuracy: accuracy,
        timeLimit: timeLimit,
      );

  // --- Feature 2: Camera Ecosystem ---

  /// Engages native shutter pipelines to produce photographic static assets.
  ///
  /// Handles underlying logic guarding permissions and coordinates active execution
  /// and custom compressions mapping upon return.
  ///
  /// [maxWidth] bounds resulting frame width resolution dimension.
  /// [maxHeight] bounds resulting frame height resolution dimension.
  /// [imageQuality] numeric compression density constraint scale 0-100.
  /// [preferredCameraDevice] sets runtime lens prioritisation Rear vs Front.
  ///
  /// Returns unique local [XFile] pointers resolving on storage capture location.
  static Future<XFile?> takePhoto({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) =>
      NativeCameraManager.takePhoto(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        preferredCameraDevice: preferredCameraDevice,
      );

  // --- Feature 3: Sensor Ecosystem ---

  /// Orchestrates highly-efficient asynchronous streams projecting accelerometer forces.
  ///
  /// Leverages fundamental system pipelines to evaluate dynamic gravity vector changes.
  /// Developers should disconnect stream listeners in offscreen pipelines for battery wellness.
  ///
  /// [samplingPeriod] calibrates total update pulse cadence per second.
  ///
  /// Emits isolated [GravityData] model packets indefinitely during connection lifecycles.
  static Stream<GravityData> watchGravity({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) =>
      NativeSensorsManager.watchGravity(
        samplingPeriod: samplingPeriod,
      );

  // --- Feature 4: Sharing Ecosystem ---

  /// Distributes structured raw text payloads to underlying OS sharing stacks.
  ///
  /// Seamlessly projects a system sharing sheet containing user strings and urls.
  ///
  /// [text] constitutes primary text container to share.
  /// [subject] supplies additional meta headers for standard email headers.
  /// [sharePositionOrigin] explicit anchor bounding rect for anchoring popups on iOS tablets.
  ///
  /// Resolves dynamic [ShareResult] revealing outcome metrics of interaction.
  static Future<ShareResult> shareText({
    required String text,
    String? subject,
    Rect? sharePositionOrigin,
  }) =>
      NativeShareManager.shareText(
        text: text,
        subject: subject,
        sharePositionOrigin: sharePositionOrigin,
      );

  /// Distributes multiple binary file caches targeting external ecosystem interfaces.
  ///
  /// Handles direct marshaling of [XFile] binary objects to system attachment buses.
  ///
  /// [files] stores exact cached file locations awaiting dispatch.
  /// [text] supplementary commentary string included with attachments.
  /// [subject] auxiliary header for communication subject lines.
  /// [sharePositionOrigin] specifies bounding box to ensure compatibility with tablet popovers.
  ///
  /// Resolves to unified [ShareResult] standard containers.
  static Future<ShareResult> shareFiles({
    required List<XFile> files,
    String? text,
    String? subject,
    Rect? sharePositionOrigin,
  }) =>
      NativeShareManager.shareFiles(
        files: files,
        text: text,
        subject: subject,
        sharePositionOrigin: sharePositionOrigin,
      );
}