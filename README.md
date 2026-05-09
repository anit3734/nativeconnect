# 🚀 NativeConnect

[![pub package](https://img.shields.io/pub/v/nativeconnect.svg?logo=dart&logoColor=white&color=indigo)](https://pub.dev/packages/nativeconnect)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter Style](https://img.shields.io/badge/style-linter-success.svg)](https://pub.dev/packages/flutter_lints)
[![Platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS-lightgrey.svg)](https://pub.dev/packages/nativeconnect)

The most intuitive, production-grade Flutter package for seamless native device hardware integration. Interact with **Location**, **Camera**, **Sensors**, and **Sharing** using a unified, robust **one-line static API** with automatic permission checks and lifecycle-safe execution.

---

## ✨ Key Features

* **📦 Unified Architecture**: Access core hardware capabilities with a single import `import 'package:nativeconnect/nativeconnect.dart';`.
* **🛡️ On-The-Fly Permissions**: Checks and requests required OS system permissions automatically, removing boilerplate logic.
* **📡 Robust GPS Location**: Fetch accurate coordinates verifying state of device hardware GPS switches.
* **📸 Smart Camera**: Streamline image capturing from front/rear cameras with automated on-the-fly compression.
* **🌀 Battery-Friendly Sensors**: Highly optimized real-time 3D accelerometer stream that prevents battery leakage.
* **📤 Universal Sharing**: Effortless distribution of application text and media files via native sharing Sheets.
* **⚠️ Custom Exception Mapping**: Standardized `NativeConnectException` handling standardized across Android & iOS.

---

## 🚀 Installation & Setup

### 1. Add Dependency

Include `nativeconnect` within your `pubspec.yaml`:

```yaml
dependencies:
  nativeconnect: ^0.0.3
```

### 2. Platform Permissions Configuration

#### 🤖 Android Setup

Add these nodes within `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Hardware Capabilities -->
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
</manifest>
```

#### 🍏 iOS Setup

Append these key-value definitions to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Application strictly accesses camera to capture imagery payloads.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Application leverages hardware GPS to verify geographic coordinates.</string>
```

---

## 💻 Code Usage Reference

### 1. Fetch GPS Coordinates (1-Line)

```dart
import 'package:nativeconnect/nativeconnect.dart';

Future<void> getLocation() async {
  try {
    final position = await NativeConnect.getLocation();
    if (position != null) {
      print('Lat: ${position.latitude}, Lng: ${position.longitude}');
    }
  } on NativeConnectException catch (e) {
    print('Location Failure: ${e.message}');
  }
}
```

### 2. Trigger Camera Capture (1-Line)

```dart
import 'package:nativeconnect/nativeconnect.dart';

Future<void> takePhoto() async {
  try {
    final photo = await NativeConnect.takePhoto(
      imageQuality: 85, // Compress 85% automatically
    );
    if (photo != null) {
      print('Photo captured efficiently at path: ${photo.path}');
    }
  } on NativeConnectException catch (e) {
    print('Camera failure: ${e.message}');
  }
}
```

### 3. Stream Active Sensors (1-Line)

```dart
import 'package:nativeconnect/nativeconnect.dart';

void watchDeviceMotion() {
  NativeConnect.watchGravity().listen((GravityData data) {
    print('Vector Magnitude scalar is: ${data.magnitude} m/s²');
  });
}
```

### 4. Share Text & Files (1-Line)

```dart
import 'package:nativeconnect/nativeconnect.dart';

Future<void> shareWithOthers() async {
  // Option A: Share pure strings or web links
  await NativeConnect.shareText(
    text: 'Check out NativeConnect, the ultimate productivity utility!',
  );

  // Option B: Share media file references
  // await NativeConnect.shareFiles(files: [XFile('path/to/my/file.png')]);
}
```

---

## ✍️ Author & Creator

Developed with ❤️ by **Anit** 

A passionate developer focused on crafting hyper-efficient Flutter utilities and developer-centric abstraction Layers.

- 💼 **LinkedIn**: [Connect with Anit](https://www.linkedin.com/in/anit-pal)
- 💻 **GitHub**: [Anit's Workspace](https://github.com/anit3734)

---

## 🛡️ License

Distributable under standard MIT License Terms - see file [LICENSE](LICENSE) for rigorous parameters.
