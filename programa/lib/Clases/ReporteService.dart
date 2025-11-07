import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:programa/Clases/reporte.dart';


class ReporteService extends ChangeNotifier {
  final List<Reporte> _reportes = [];
  List<Reporte> get reportes => _reportes;


  void agregarNuevoReporte(Reporte reporte) {
    _reportes.add(reporte);
    print('¡REPORTE RECIBIDO EN SERVICIO! Total actual: ${_reportes.length}');
    notifyListeners(); 
  }
  
  Future<void> respaldarEnHive() async {
    //Próximam3ente: Implementar respaldo en Hive
    print('Respaldando ${_reportes.length} reportes en Hive...');
  }
}