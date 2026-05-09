import 'package:flutter/material.dart';
import 'package:nativeconnect/nativeconnect.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NativeDemoScreen(),
  ));
}

class NativeDemoScreen extends StatefulWidget {
  const NativeDemoScreen({super.key});

  @override
  State<NativeDemoScreen> createState() => _NativeDemoScreenState();
}

class _NativeDemoScreenState extends State<NativeDemoScreen> {
  String _locationData = "Click to get location";
  String _sensorData = "Waiting for sensor data...";
  String? _imagePath;

  // 📍 Feature 1: Location
  Future<void> _handleLocation() async {
    try {
      final pos = await NativeConnect.getLocation();
      setState(() {
        _locationData = "Lat: ${pos?.latitude}, Long: ${pos?.longitude}";
      });
    } catch (e) {
      setState(() => _locationData = "Location Error: $e");
    }
  }

  // 📸 Feature 2: Camera
  Future<void> _handleCamera() async {
    try {
      final image = await NativeConnect.takePhoto();
      if (image != null) {
        setState(() => _imagePath = image.path);
      }
    } catch (e) {
      debugPrint("Camera Error: $e");
    }
  }

  // 📤 Feature 3: Share (New!)
  Future<void> _handleShare() async {
    if (_imagePath != null) {
      // Photo share karne ke liye
      await NativeConnect.shareFiles(files: [XFile(_imagePath!)], text: "Check out this photo from NativeConnect!");
    } else {
      // Agar photo nahi hai toh sirf text share karein
      await NativeConnect.shareText(text: "NativeConnect is awesome! Try it on pub.dev");
    }
  }

  @override
  void initState() {
    super.initState();
    // 🧭 Feature 4: Sensors
    NativeConnect.watchGravity().listen((data) {
      setState(() {
        _sensorData = "X: ${data.x.toStringAsFixed(2)}, Y: ${data.y.toStringAsFixed(2)}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NativeConnect v0.0.3 Demo"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Camera & Share Section
            Card(
              child: Column(
                children: [
                  if (_imagePath != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Captured: ${_imagePath!.split('/').last}"),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _handleCamera,
                        icon: const Icon(Icons.camera),
                        label: const Text("Capture"),
                      ),
                      ElevatedButton.icon(
                        onPressed: _handleShare,
                        icon: const Icon(Icons.share),
                        label: const Text("Share"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade100),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Location Section
            _simpleTile(Icons.map, "Location", _locationData, _handleLocation),

            const SizedBox(height: 15),

            // Sensors Section
            _simpleTile(Icons.explore, "Sensors (Auto)", _sensorData, null),
          ],
        ),
      ),
    );
  }

  Widget _simpleTile(IconData icon, String title, String value, VoidCallback? action) {
    return ListTile(
      tileColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
      trailing: action != null
          ? IconButton(onPressed: action, icon: const Icon(Icons.refresh))
          : null,
    );
  }
}