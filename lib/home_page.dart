import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:h3_flutter/h3_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MapboxMapController? _mapController;
  LatLng? _currentLocation;
  final String _mapboxAccessToken = 'SEU_MAPBOX_ACCESS_TOKEN_AQUI';
  final h3 = H3();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    await Permission.location.request();

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;

    if (_currentLocation != null) {
      _drawHexFromLocation(_currentLocation!);
    }
  }

  void _drawHexFromLocation(LatLng location) {
    final String h3Index =
        h3.geoToH3(location.latitude, location.longitude, 10); // resolução 10
    final List<LatLng> hexBoundary = h3
        .h3ToGeoBoundary(h3Index)
        .map((coord) => LatLng(coord.lat, coord.lng))
        .toList();

    final List<List<LatLng>> polygon = [hexBoundary];

    _mapController?.addFill(
      FillOptions(
        geometry: polygon,
        fillColor: '#00FF00',
        fillOpacity: 0.4,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Corrida Territorial')),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : MapboxMap(
              accessToken: _mapboxAccessToken,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 15,
              ),
              myLocationEnabled: true,
              myLocationTrackingMode: MyLocationTrackingMode.Tracking,
            ),
    );
  }
}
