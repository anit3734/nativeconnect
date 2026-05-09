## 0.0.3
* **New Feature**: Integrated `share_plus` to support one-line text and file sharing.
* **Architecture**: Refactored project structure into a clean feature-based modular design.
* **Documentation**: Added comprehensive API documentation for all native managers.
* **Fix**: Updated repository and issue tracker URLs in pubspec.yaml.

## 0.0.2

* Updated author profile links (LinkedIn & GitHub) in README.md.

## 0.0.1 - Initial Release

* **Core Unified API**: Primary static class `NativeConnect` exposing `getLocation()`, `takePhoto()`, and `watchGravity()`.
* **Auto-Permission Checks**: On-the-fly system requests for camera and location permissions.
* **Modern Geolocator API**: High-precision coordinates checking with global device GPS switch verification.
* **Smart Camera compression**: Allows choosing camera device (front/rear) and custom compression configurations (`imageQuality`, `maxWidth`, `maxHeight`).
* **High-Performance Sensors**: Real-time 3D accelerometer stream with customizable sampling frequency (`samplingPeriod`) and vector magnitude calculation.
* **Robust Custom Exceptions**: Standardization of native hardware failures and permanent permission denials using `NativeConnectException`.
