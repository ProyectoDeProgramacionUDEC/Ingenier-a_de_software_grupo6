import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:programa/Clases/reporte.dart';
import 'package:programa/Clases/usuario.dart';

class ReporteService extends ChangeNotifier {
  
  final Box<Reporte> _cajaReportes = Hive.box<Reporte>('box_reportes');

  // Propiedad auxiliar para obtener todos los datos como lista (útil para filtrar)
  List<Reporte> get _todosLosReportes => _cajaReportes.values.toList();

  List<Reporte> obtenerReportesVisibles(Usuario? usuarioLogueado) {
    
    if (usuarioLogueado == null) return [];

    // Si es ADMIN, le damos acceso a TODO lo que hay en la caja
    if (usuarioLogueado.esAdmin) {
      return _todosLosReportes;
    }

    // Si es USUARIO COMÚN, filtramos lo que hay en la caja por su RUT
    return _todosLosReportes.where((reporte) {
      return reporte.rutUsuario == usuarioLogueado.rut; 
    }).toList();
  }

  // Persistencia
  void agregarNuevoReporte(Reporte reporte) {
    _cajaReportes.add(reporte);
    
    print('¡REPORTE GUARDADO EN HIVE! Total en BD: ${_cajaReportes.length}');
    notifyListeners();
  }
  void actualizarEstadoReporte(Reporte reporteOriginal, bool nuevoEstado) {
    

    final reporteActualizado = reporteOriginal.copyWith(encontrado: nuevoEstado);

    // Encontrar la llave (Key) en Hive.
    dynamic keyEncontrada;
    
    // Buscamos qué llave tiene este objeto específico en la caja
    try {
      keyEncontrada = _cajaReportes.keys.firstWhere(
        (k) => _cajaReportes.get(k) == reporteOriginal
      );
    } catch (e) {
      keyEncontrada = null;
    }

    if (keyEncontrada != null) {
      // Sobrescribimos en disco usando la llave
      _cajaReportes.put(keyEncontrada, reporteActualizado);

      print('Estado actualizado en Hive. Notificando...');
      notifyListeners();
    } else {
      print('Error: No se pudo encontrar el reporte en Hive para actualizarlo.');
    }
  }

  //Método para borrar (útil para el admin)
  void borrarReporte(Reporte reporte) {
     final key = _cajaReportes.keys.firstWhere(
        (k) => _cajaReportes.get(k) == reporte, orElse: () => null);
     
     if (key != null) {
       _cajaReportes.delete(key);
       notifyListeners();
     }
  }
}