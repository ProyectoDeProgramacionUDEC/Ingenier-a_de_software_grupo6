import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:programa/Clases/reporte.dart';
import 'package:programa/Clases/usuario.dart';

class ReporteService extends ChangeNotifier {
  // Base de datos
  final Box<Reporte> _cajaReportes = Hive.box<Reporte>('box_reportes');
  List<Reporte> get _todosLosReportes => _cajaReportes.values.toList();

  // Lógica de filtrado
  List<Reporte> obtenerReportesVisibles(Usuario? usuarioLogueado) {
    if (usuarioLogueado == null) return [];

    // Si es admin, puede verlo todo
    if (usuarioLogueado.esAdmin) {
      return _todosLosReportes;
    }

    // Si es usuario común, ve solo lo que esté asociado a el mismo
    return _todosLosReportes.where((reporte) {
      return reporte.rutUsuario == usuarioLogueado.rut;
    }).toList();
  }

  // Agregar
  void agregarNuevoReporte(Reporte reporte) {
    _cajaReportes.add(reporte);
    print('¡REPORTE GUARDADO EN HIVE! Total en BD: ${_cajaReportes.length}');
    notifyListeners();
  }

  // Actualizar
  void actualizarEstadoReporte(Reporte reporteOriginal, bool nuevoEstado) {
    final reporteActualizado = reporteOriginal.copyWith(estado: nuevoEstado);
    _reemplazarEnHive(reporteOriginal, reporteActualizado);
  }

  // Modificar reporte
  void actualizarReporte(Reporte reporteAntiguo, Reporte reporteNuevo) {
    print("Actualizando reporte completo...");
    _reemplazarEnHive(reporteAntiguo, reporteNuevo);
  }

  // Reemplazamos reporte en Hive
  void _reemplazarEnHive(Reporte viejo, Reporte nuevo) {
    final key = _cajaReportes.keys.firstWhere(
      (k) => _cajaReportes.get(k) == viejo,
      orElse: () => null,
    );

    if (key != null) {
      _cajaReportes.put(key, nuevo); // Sobrescribe en disco
      print("Objeto actualizado exitosamente en Hive.");
      notifyListeners();
    } else {
      print("Error: No se encontró el reporte original para actualizar.");
    }
  }

  void borrarReporte(Reporte reporte) {
    final key = _cajaReportes.keys.firstWhere(
      (k) => _cajaReportes.get(k) == reporte,
      orElse: () => null,
    );

    if (key != null) {
      _cajaReportes.delete(key);
      print("Reporte eliminado de Hive.");
      notifyListeners();
    }
  }
}
