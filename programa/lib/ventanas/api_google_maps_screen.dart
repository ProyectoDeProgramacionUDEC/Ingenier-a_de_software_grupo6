import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


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

  Future<String?> getAddressFromOSM(double lat, double lng) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'flutter-app',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['display_name'];
      }
    } catch (e) {
      print("Error obteniendo dirección OSM: $e");
    }
    return null;
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
              // Actualizamos la variable cada vez que se mueve el mapa
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
              onPressed: () async {
                if (_ubicacionSeleccionada != null) {
                  final lat = _ubicacionSeleccionada!.latitude;
                  final lng = _ubicacionSeleccionada!.longitude;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Obteniendo dirección...")),
                  );

                  // Obtenemos la dirección desde OSM
                  final direccion = await getAddressFromOSM(lat, lng);
                  
                  final resultado = {
                    "direccion": direccion ?? "Ubicación personalizada",
                    "coordenadas": _ubicacionSeleccionada, 
                  };

                  print("Enviando datos: $resultado");

                  if (context.mounted) {
                    Navigator.pop(context, resultado);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Mueve el mapa un poco para detectar ubicación...")),
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