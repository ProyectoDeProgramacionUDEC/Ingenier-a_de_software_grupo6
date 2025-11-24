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

  void actualizarEstadoReporte(Reporte reporte, bool nuevoEstado) {
    // 1. Encontrar la posición (index) del reporte en la lista
    final index = _reportes.indexOf(reporte);

    // 2. Verificar que el reporte exista en nuestra lista
    if (index != -1) {
      // 3. Crear una NUEVA copia del reporte con el estado actualizado
      final reporteActualizado = reporte.copyWith(encontrado: nuevoEstado);

      // 4. Reemplazar el reporte antiguo por el nuevo en la lista
      _reportes[index] = reporteActualizado;

      print('Estado de reporte actualizado (con copyWith). Notificando...');
      notifyListeners();
    } else {
      print('Error: Se intentó actualizar un reporte que no está en la lista.');
    }
  }

  Future<void> respaldarEnHive() async {
    //Próximamente: Implementar respaldo en Hive
    print('Respaldando ${_reportes.length} reportes en Hive...');
  }
}
