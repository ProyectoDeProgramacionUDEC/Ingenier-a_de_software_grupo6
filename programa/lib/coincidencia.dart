import 'package:programa/Clases/reporte.dart';

class Coincidencia {
  final Reporte perdido;
  final Reporte encontrado;
  final double similitud;

  Coincidencia({
    required this.perdido,
    required this.encontrado,
    required this.similitud,
  });
}