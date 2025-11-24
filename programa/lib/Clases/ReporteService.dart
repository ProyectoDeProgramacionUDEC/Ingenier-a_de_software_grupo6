import 'package:flutter/material.dart';
import 'package:programa/Clases/reporte.dart';
import 'package:programa/Clases/usuario.dart';

class ReporteService extends ChangeNotifier {

  final List<Reporte> _baseDeDatosReportes = [];

  List<Reporte> obtenerReportesVisibles(Usuario? usuarioLogueado) {

    if (usuarioLogueado == null) return [];

    // Si es ADMIN, le damos acceso a la lista completa de reportes
    if (usuarioLogueado.esAdmin) {
      return List.unmodifiable(_baseDeDatosReportes);
    }

    // Si es un usuario común, filtramos según el rut asociado.
    return _baseDeDatosReportes.where((reporte) {
      return reporte.rutUsuario == usuarioLogueado.rut; 
    }).toList();
  }

  void agregarNuevoReporte(Reporte reporte) {
    _baseDeDatosReportes.add(reporte);
    print('¡REPORTE RECIBIDO! Total en BD: ${_baseDeDatosReportes.length}');
    
    notifyListeners();
  }

  void actualizarEstadoReporte(Reporte reporte, bool nuevoEstado) {
    final index = _baseDeDatosReportes.indexOf(reporte);

    if (index != -1) {
      final reporteActualizado = reporte.copyWith(encontrado: nuevoEstado);
      _baseDeDatosReportes[index] = reporteActualizado;

      print('Estado actualizado. Notificando...');
      notifyListeners();
    } else {
      print('Error: Reporte no encontrado en la base de datos.');
    }
  }
}