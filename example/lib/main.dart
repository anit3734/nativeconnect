import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nativeconnect/nativeconnect.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NativeConnect Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Elegant Indigo
          brightness: Brightness.dark,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: const Color(0xFF1E1E2E), // Premium Dark Slate
        ),
      ),
      home: const ShowcaseHome(),
    );
  }
}

class ShowcaseHome extends StatefulWidget {
  const ShowcaseHome({super.key});

  @override
  State<ShowcaseHome> createState() => _ShowcaseHomeState();
}

class _ShowcaseHomeState extends State<ShowcaseHome> with WidgetsBindingObserver {
  XFile? _image;
  Position? _position;
  bool _loadingLocation = false;
  String? _error;
  
  StreamSubscription<GravityData>? _sensorSubscription;
  GravityData? _sensorData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startListening();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopListening();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startListening();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _stopListening();
    }
  }

  void _startListening() {
    _sensorSubscription?.cancel();
    _sensorSubscription = NativeConnect.watchGravity().listen((data) {
      setState(() {
        _sensorData = data;
      });
    }, onError: (err) {
      debugPrint("Sensor Error: $err");
    });
  }

  void _stopListening() {
    _sensorSubscription?.cancel();
    _sensorSubscription = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A), // Sleek Dark Background
      appBar: AppBar(
        title: const Text(
          '🚀 NativeConnect',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF161624),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Error Banner if any exception occurs
            if (_error != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withAlpha(38),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.redAccent.withAlpha(102)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.redAccent),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.redAccent, size: 18),
                      onPressed: () => setState(() => _error = null),
                    )
                  ],
                ),
              ),

            // Feature 1: Camera
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.camera_alt_rounded, color: Color(0xFF8B5CF6), size: 28),
                        const SizedBox(width: 12),
                        Text(
                          'Camera Capture',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Capture a high-quality photo with automated permission handling.',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    if (_image != null)
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.withAlpha(76)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              File(_image!.path),
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ElevatedButton.icon(
                      onPressed: _takePhoto,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.photo_camera),
                      label: const Text('Take Photo Automatically', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Feature 2: Location
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, color: Color(0xFF10B981), size: 28),
                        const SizedBox(width: 12),
                        Text(
                          'GPS Location',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Retrieve device coordinates seamlessly with auto-permission request.',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    if (_position != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Latitude: ${_position!.latitude}', style: const TextStyle(fontFamily: 'monospace')),
                            Text('Longitude: ${_position!.longitude}', style: const TextStyle(fontFamily: 'monospace')),
                            Text('Accuracy: ${_position!.accuracy.toStringAsFixed(1)}m', style: const TextStyle(fontFamily: 'monospace', color: Colors.grey)),
                          ],
                        ),
                      ),
                    ElevatedButton.icon(
                      onPressed: _loadingLocation ? null : _fetchLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: _loadingLocation
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.my_location),
                      label: Text(_loadingLocation ? 'Fetching...' : 'Get Location Automatically', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Feature 3: Sensors
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.sensors_rounded, color: Color(0xFFF59E0B), size: 28),
                        const SizedBox(width: 12),
                        Text(
                          'Gravity Sensors',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Real-time accelerometer & gravity data streamed continuously.',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    if (_sensorData == null)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Text('Waiting for sensor stream...', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                        ),
                      )
                    else
                      Column(
                        children: [
                          _buildSensorProgress('X Axis Force', _sensorData!.x, const Color(0xFFEF4444)),
                          const SizedBox(height: 12),
                          _buildSensorProgress('Y Axis Force', _sensorData!.y, const Color(0xFF10B981)),
                          const SizedBox(height: 12),
                          _buildSensorProgress('Z Axis Force', _sensorData!.z, const Color(0xFF3B82F6)),
                          const Divider(height: 24, color: Colors.white12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Magnitude Force:', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                '${_sensorData!.magnitude.toStringAsFixed(2)} m/s²',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF59E0B), fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorProgress(String title, double value, Color color) {
    // Accelerometers report raw forces usually up to ~19.6 (2g) or more. Let's normalize value roughly to 0-1 for indicator.
    final normalized = (value.abs() / 15.0).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text('${value.toStringAsFixed(2)} m/s²', style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: normalized,
          color: color,
          backgroundColor: Colors.white10,
          minHeight: 6,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Future<void> _takePhoto() async {
    try {
      setState(() => _error = null);
      final photo = await NativeConnect.takePhoto();
      if (photo != null) {
        setState(() => _image = photo);
      }
    } on NativeConnectException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'An unexpected camera error occurred.');
    }
  }

  Future<void> _fetchLocation() async {
    try {
      setState(() {
        _error = null;
        _loadingLocation = true;
      });
      final loc = await NativeConnect.getLocation();
      setState(() => _position = loc);
    } on NativeConnectException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'An unexpected location error occurred.');
    } finally {
      setState(() => _loadingLocation = false);
    }
  }
}