import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapaSeleccionScreen extends StatefulWidget {
  const MapaSeleccionScreen({super.key});

  @override
  State<MapaSeleccionScreen> createState() => _MapaSeleccionScreenState();
}

class _MapaSeleccionScreenState extends State<MapaSeleccionScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kUdeC = CameraPosition(
    target: LatLng(-36.8299, -73.0371),
    zoom: 15,
  );

  LatLng? _ubicacionSeleccionada;

  @override
  void initState() {
    super.initState();
    _irAmiUbicacion();
  }

  Future<void> _irAmiUbicacion() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18,
        ),
      ),
    );

    if (mounted) {
      setState(() {
        _ubicacionSeleccionada = LatLng(position.latitude, position.longitude);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Selecciona Ubicación Exacta")),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kUdeC,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraMove: (CameraPosition position) {
              // Actualizamos la variable cada vez que mueves el mapa
              _ubicacionSeleccionada = position.target;
            },
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Icon(Icons.location_on, size: 50, color: Colors.red),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                print(
                  "BOTÓN PRESIONADO. Datos a enviar: $_ubicacionSeleccionada",
                );

                if (_ubicacionSeleccionada != null) {
                  // Devuelve los datos A LA PANTALLA ANTERIOR
                  Navigator.pop(context, _ubicacionSeleccionada);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Mueve el mapa un poco para detectar ubicación...",
                      ),
                    ),
                  );
                }
              },
              child: const Text("CONFIRMAR ESTA UBICACIÓN"),
            ),
          ),
        ],
      ),
    );
  }
}
