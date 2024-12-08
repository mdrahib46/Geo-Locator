import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? currentPosition;
  final LatLng _initialPosition = const LatLng(23.823192, 90.352723);
  late GoogleMapController googleMapController;
  Marker? userMarker;

  final List<LatLng> polylineCoordinates = [];
  final Set<Polyline> polyLines = {};

  @override
  void initState() {
    super.initState();
    listenCurrentLocation();
  }

  Future<void> listenCurrentLocation() async {
    final isGranted = await isLocationPermissionGranted();
    if (isGranted) {
      final isServiceEnable = await checkGPSServiceEnable();
      if (isServiceEnable) {
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.bestForNavigation, timeLimit: Duration(seconds: 10)),
        ).listen((position) {
          setState(() {
            currentPosition = position;
            LatLng currentLatLng =
                LatLng(position.latitude, position.longitude);
            print(currentPosition);
            polylineCoordinates.add(currentLatLng);
            polyLines.clear();
            polyLines.add(
              Polyline(
                polylineId: const PolylineId('tracking-polyline'),
                color: Colors.blue,
                width: 6,
                points: polylineCoordinates,
              ),
            );

            userMarker = Marker(
              markerId: const MarkerId('user-marker'),
              position: currentLatLng,
              draggable: true,
              onDragEnd: (newPosition) {
                setState(() {
                  currentPosition = Position(
                    latitude: newPosition.latitude,
                    longitude: newPosition.longitude,
                    timestamp: DateTime.now(),
                    accuracy: position.accuracy,
                    altitude: position.altitude,
                    heading: position.heading,
                    speed: position.speed,
                    speedAccuracy: position.speedAccuracy,
                    headingAccuracy: position.speedAccuracy,
                    altitudeAccuracy: position.speedAccuracy,
                  );
                });
              },
              infoWindow: InfoWindow(
                title: 'My Current Location',
                snippet:
                    'Lat: ${currentLatLng.latitude}, Lng: ${currentLatLng.longitude}',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
            );
          });
        });
      } else {
        await Geolocator.openLocationSettings();
      }
    } else {
      final result = await requestLocationPermission();
      if (result) {
        getCurrentLocation();
      } else {
        await Geolocator.openAppSettings();
      }
    }
  }

  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<bool> isLocationPermissionGranted() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<bool> checkGPSServiceEnable() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<void> getCurrentLocation() async {
    final isGranted = await isLocationPermissionGranted();
    if (isGranted) {
      final isServiceEnable = await checkGPSServiceEnable();
      if (isServiceEnable) {
        Position position = await Geolocator.getCurrentPosition();
        setState(() {
          currentPosition = position;
        });
      } else {
        await Geolocator.openLocationSettings();
      }
    } else {
      final result = await requestLocationPermission();
      if (result) {
        getCurrentLocation();
      } else {
        await Geolocator.openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map GeoLocator'),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (currentPosition != null) {
            googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  zoom: 16,
                  target: LatLng(
                    currentPosition!.latitude,
                    currentPosition!.longitude,
                  ),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Current location is not available yet.'),
              ),
            );
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.my_location),
      ),
      body: SafeArea(
        child: GoogleMap(
          onMapCreated: (controller) {
            googleMapController = controller;
          },
          mapType: MapType.satellite,
          initialCameraPosition: CameraPosition(
            zoom: 16,
            target: _initialPosition,
          ),
          markers: {
            Marker(
              markerId: MarkerId('home'),
              position: _initialPosition,
              infoWindow: InfoWindow(
                  title: "My Home",
                  snippet:
                      "Lat: ${_initialPosition.latitude}, Lng: ${_initialPosition.longitude}"),
            ),
          },
          circles: <Circle>{
            Circle(
              circleId: const CircleId('circle-on-home'),
              strokeWidth: 3,
              radius: 100,
              strokeColor: Colors.green,
              center: _initialPosition,
            ),
          },
          polylines: polyLines,
        ),
      ),
    );
  }
}
