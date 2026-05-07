# 🚀 NativeConnect

[![pub package](https://img.shields.io/pub/v/nativeconnect.svg?logo=dart&logoColor=white&color=indigo)](https://pub.dev/packages/nativeconnect)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter Style](https://img.shields.io/badge/style-linter-success.svg)](https://pub.dev/packages/flutter_lints)

The most intuitive, production-grade Flutter package for seamless native device hardware integration. Interact with **Location (GPS)**, **Camera**, and **Sensors** using a unified, robust **one-line static API** with automatic permission checks and lifecycle-safe stream handlers.

---

## 🎯 Why NativeConnect?

| Feature | The Hard Way (Normal Packages) | The Smart Way (NativeConnect) |
| :--- | :--- | :--- |
| **Boilerplate** | 30+ lines of permission checks, try-catches & redirects | **1 Line of code** |
| **Permissions** | Manual request loops & setting handling | **Auto-managed on-demand** |
| **Battery Life** | Stream leaks & background drains if forgot to dispose | **Lifecycle-safe auto-pausing** |
| **Error Handling** | Raw platform-specific codes that crash apps | **Standardized exceptions** |

---

## ✨ Key Features

* **📦 Unified Architecture**: Access Location, Camera, and Sensors with a single import `import 'package:nativeconnect/nativeconnect.dart';`. No underlying library imports required.
* **🛡️ On-The-Fly Permissions**: Automatically checks and requests system permissions only when the feature is called. Zero upfront permission spamming.
* **📡 Intelligent GPS Location**: Verifies if global location services are enabled on the device. Gracefully handles disabled GPS and coarse/fine accuracy levels.
* **📸 Smart Camera & Compression**: Select front/rear camera and apply on-the-fly photo compression (`imageQuality`, `maxWidth`, `maxHeight`) to prevent memory overload.
* **🌀 Battery-Friendly Sensors**: Streams 3D gravity accelerometer values with an auto-cancelling listener that turns off when the app goes into the background, preventing device lag and preserving battery.
* **⚠️ Custom Exception Mapping**: Exposes a clean `NativeConnectException` with clear error codes like `LOCATION_SERVICE_DISABLED` or `CAMERA_PERMISSION_DENIED`.

---

## 🚀 Installation & Setup

### 1. Add Dependency

Add `nativeconnect` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  nativeconnect: ^0.0.1
```

### 2. Platform Permissions Configuration

#### 🤖 Android Setup

Insert the following permissions inside your `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Camera Access -->
    <uses-permission android:name="android.permission.CAMERA" />
    
    <!-- GPS Location Access -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
</manifest>
```

#### 🍏 iOS Setup

Add the following keys to your `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app requires camera access to capture photographs.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app requires location access to retrieve physical coordinates.</string>
```

---

## 💻 Code Examples

### 1. Fetch Current GPS Location

```dart
import 'package:nativeconnect/nativeconnect.dart';

Future<void> fetchLocation() async {
  try {
    final position = await NativeConnect.getLocation(
      accuracy: LocationAccuracy.high, // Customizable accuracy level
    );
    if (position != null) {
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    }
  } on NativeConnectException catch (e) {
    print('Location Error [${e.code}]: ${e.message}');
  }
}
```

### 2. Capture a Photo (with dynamic compression)

```dart
import 'package:nativeconnect/nativeconnect.dart';

Future<void> captureImage() async {
  try {
    final XFile? photo = await NativeConnect.takePhoto(
      imageQuality: 85, // Compresses image to 85% to save bandwidth & storage
      preferredCameraDevice: CameraDevice.rear,
    );
    if (photo != null) {
      print('Photo saved successfully: ${photo.path}');
    }
  } on NativeConnectException catch (e) {
    print('Camera Error [${e.code}]: ${e.message}');
  }
}
```

### 3. Stream Real-Time Gravity Sensors

```dart
import 'package:nativeconnect/nativeconnect.dart';

void watchMovement() {
  NativeConnect.watchGravity(
    samplingPeriod: SensorInterval.normalInterval, // Battery-optimized sampling
  ).listen((GravityData data) {
    print('X Axis Force: ${data.x} m/s²');
    print('Y Axis Force: ${data.y} m/s²');
    print('Z Axis Force: ${data.z} m/s²');
    print('Total Magnitude: ${data.magnitude} m/s²');
  }, onError: (error) {
    print('Sensor Stream Error: $error');
  });
}
```

---

## ✍️ Author & Creator

Created with ❤️ by **Anit** 

A passionate software developer dedicated to crafting clean, premium, and hyper-efficient developer utilities.

- 💼 **LinkedIn**: [Connect with Anit](https://linkedin.com/)
- 💻 **GitHub**: [Anit's Workspace](https://github.com/)

---

## 🛡️ License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
