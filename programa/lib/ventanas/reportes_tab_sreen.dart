import 'package:flutter/material.dart';
import 'package:programa/Clases/reporte_list.dart';
import 'package:programa/ventanas/agregar_reporte_screen.dart';
import 'package:programa/Clases/ReporteService.dart';
import 'package:programa/ventanas/avisos_screen.dart';
import 'package:provider/provider.dart';

class ReportesTabsScreen extends StatelessWidget {
  const ReportesTabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReporteService>(
      builder: (context, reporteService, child) {
        print(
          '¡PANTALLA DE LISTA REDIBUJADA! Mostrando ${reporteService.reportes.length} reportes.',
        ); //debuger
        final todosLosReportes = reporteService.reportes;
        final perdidos = todosLosReportes.where((r) => !r.encontrado).toList()
          ..sort((a, b) => b.fecha.compareTo(a.fecha));
        final encontrados = todosLosReportes.where((r) => r.encontrado).toList()
          ..sort((a, b) => b.fecha.compareTo(a.fecha));
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Reportes de Objetos"),
              bottom: const TabBar(
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(text: "Perdidos"),
                  Tab(text: "Encontrados"),
                  Tab(text: "Avisos"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                ListaReportes(
                  reportes: perdidos,
                  onReporteChanged: (reporte, nuevoEstado) {
                    reporteService.actualizarEstadoReporte(
                      reporte,
                      nuevoEstado,
                    );
                  },
                ),
                ListaReportes(
                  reportes: encontrados,
                  onReporteChanged: (reporte, nuevoEstado) {
                    reporteService.actualizarEstadoReporte(
                      reporte,
                      nuevoEstado,
                    );
                  },
                ),
                AvisosScreen(
                  todosLosReportes: todosLosReportes,
                  similitudMinima: 0.6,
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AgregarReporteScreen(
                      personalUdec: true,
                      esEncontrado: false,
                    ),
                  ),
                );
              },
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}
