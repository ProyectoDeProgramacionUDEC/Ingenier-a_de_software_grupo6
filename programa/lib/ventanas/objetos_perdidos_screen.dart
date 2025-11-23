import 'package:flutter/material.dart';
import 'package:programa/Clases/reporte.dart';
import 'package:programa/Clases/reporte_list.dart';
import 'package:programa/Styles/appBar.dart';
import 'package:provider/provider.dart';
import 'package:programa/Clases/ReporteService.dart';

class PerdidosScreen extends StatelessWidget {
  const PerdidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReporteService>(
      builder: (context, reporteService, child) {
        final todosLosReportes = reporteService.reportes;
        final perdidos = todosLosReportes.where((r) => !r.encontrado).toList();
        return Scaffold(
          appBar: UdecAppBarRightLogo(title: "OBJETOS Perdidos"),
          body: ListaReportes(
            reportes: perdidos,
            onReporteChanged: (reporte, nuevoEstado) {
              reporteService.actualizarEstadoReporte(reporte, nuevoEstado);
            },
            onDeleteReporte: (reporte) {
              reporteService.eliminarReporte(reporte);
            },
          ),
        );
      },
    );
  }
}
