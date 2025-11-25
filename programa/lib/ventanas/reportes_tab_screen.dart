import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:programa/Clases/reporte_list.dart';
import 'package:programa/ventanas/agregar_reporte_screen.dart';
import 'package:programa/Clases/ReporteService.dart';
import 'package:programa/ventanas/avisos_screen.dart';
import 'package:programa/services/user_service.dart';

class ReportesTabsScreen extends StatelessWidget {
  const ReportesTabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    // Obtenemos el usuario y verificamos su rol
    final usuarioLogueado = Provider.of<UserService>(context).usuarioLogueado;
    final bool esAdmin = usuarioLogueado?.esAdmin ?? false;

    return Consumer<ReporteService>(
      builder: (context, reporteService, child) {
        
        // Obtenemos lista segura
        final listaSegura = reporteService.obtenerReportesVisibles(usuarioLogueado);

        print(
          '¡PANTALLA DE TABS REDIBUJADA! Mostrando ${listaSegura.length} reportes.',
        ); 

        // Procesamos las listas (Filtrar y Ordenar por fecha)
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
                // TAB 1: PERDIDOS
                perdidos.isEmpty 
                  ? const Center(child: Text("No tienes reportes de objetos perdidos."))
                  : ListaReportes(
                      reportes: perdidos,
                      esAdmin: esAdmin,
                    ),

                // TAB 2: ENCONTRADOS
                encontrados.isEmpty 
                  ? const Center(child: Text("No has encontrado ningún objeto aún."))
                  : ListaReportes(
                      reportes: encontrados,
                      esAdmin: esAdmin
                    ),

                // TAB 3: AVISOS (Inteligencia de coincidencias)
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
                    // Al agregar, el formulario tomará el RUT del usuarioLogueado
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