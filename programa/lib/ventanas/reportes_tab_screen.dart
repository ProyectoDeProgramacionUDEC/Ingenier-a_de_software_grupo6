import 'package:flutter/material.dart';
import 'package:programa/Clases/reporte_list.dart';
import 'package:programa/ventanas/agregar_reporte_screen.dart';
import 'package:programa/Clases/ReporteService.dart';
import 'package:programa/ventanas/avisos_screen.dart';
import 'package:programa/services/user_service.dart';
import 'package:provider/provider.dart';

class ReportesTabsScreen extends StatelessWidget {
  const ReportesTabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    // Obtenemos el usuario que está en sesión
    final usuarioLogueado = Provider.of<UserService>(context).usuarioLogueado;

    return Consumer<ReporteService>(
      builder: (context, reporteService, child) {
        
        // Obtenemos una lista segura de reportes
        final listaSegura = reporteService.obtenerReportesVisibles(usuarioLogueado);

        print(
          '¡PANTALLA DE TABS REDIBUJADA! Mostrando ${listaSegura.length} reportes para el usuario ${usuarioLogueado?.nombre ?? "Anon"}.',
        ); 

        // Procesamos las listas
        final perdidos = listaSegura
            .where((r) => !r.encontrado)
            .toList()
          ..sort((a, b) => b.fecha.compareTo(a.fecha));

        final encontrados = listaSegura
            .where((r) => r.encontrado)
            .toList()
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
                // TAB 1: PERDIDOS (Filtrados)
                // Si no hay nada, mostramos mensaje
                perdidos.isEmpty 
                  ? const Center(child: Text("No tienes reportes de objetos perdidos."))
                  : ListaReportes(
                      reportes: perdidos,
                      onReporteChanged: (reporte, nuevoEstado) {
                        reporteService.actualizarEstadoReporte(
                          reporte,
                          nuevoEstado,
                        );
                      },
                    ),

                // TAB 2: ENCONTRADOS (Filtrados)
                encontrados.isEmpty 
                  ? const Center(child: Text("No has encontrado ningún objeto aún."))
                  : ListaReportes(
                      reportes: encontrados,
                      onReporteChanged: (reporte, nuevoEstado) {
                        reporteService.actualizarEstadoReporte(
                          reporte,
                          nuevoEstado,
                        );
                      },
                    ),

                AvisosScreen(
                  todosLosReportes: listaSegura, 
                  similitudMinima: 0.6,
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AgregarReporteScreen(
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