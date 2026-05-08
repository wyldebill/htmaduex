import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapme',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const _fallbackCenter = LatLng(37.7749, -122.4194);
  static const _defaultZoom = 13.0;
  GoogleMapController? _mapController;
  bool _isFindingMe = false;

  Future<void> _findMe() async {
    if (_isFindingMe) return;
    setState(() {
      _isFindingMe = true;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showMessage('Location services are disabled.');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showMessage('Location permission is required for Find Me.');
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final target = LatLng(position.latitude, position.longitude);
      await _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: target, zoom: _defaultZoom),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isFindingMe = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapme')),
      body: GoogleMap(
        // Start from a known location so the app is useful before permissions are granted.
        initialCameraPosition: const CameraPosition(
          target: _fallbackCenter,
          zoom: _defaultZoom,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        onMapCreated: (controller) => _mapController = controller,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _findMe,
        tooltip: 'Find Me',
        child: _isFindingMe
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.my_location),
      ),
    );
  }
}
