import 'package:programa/Clases/reporte.dart';

class Coincidencia {
  final Reporte perdido;
  final Reporte encontrado;
  final double similitud;
  final double similitudTitulo;
  final double similitudDescripcion;

  Coincidencia({
    required this.perdido,
    required this.encontrado,
    required this.similitud,
    required this.similitudTitulo,
    required this.similitudDescripcion,
  });
}
