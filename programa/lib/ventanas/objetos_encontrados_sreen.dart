import 'package:flutter/material.dart';
import 'package:programa/Clases/reporte.dart';
import 'package:programa/Clases/reporte_list.dart';

import 'package:provider/provider.dart';
import 'package:programa/Clases/ReporteService.dart';

class EncontradosScreen extends StatelessWidget {
  const EncontradosScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ReporteService>(
      builder: (context, reporteService, child) {
        // Obtenemos los reportes desde el servicio
        final encontrados = reporteService.reportes
            .where((r) => r.encontrado)
            .toList();

        return Scaffold(
          appBar: AppBar(title: const Text('Objetos Encontrados')),

          // ----- IMPLEMENTACIÓN AQUÍ -----
          body: ListaReportes(
            reportes: encontrados,
            onReporteChanged: (reporte, nuevoEstado) {
              // Usamos la función del servicio que creamos
              reporteService.actualizarEstadoReporte(reporte, nuevoEstado);
            },
          ),
          // ---------------------------------
        );
      },
    );
  }
}
