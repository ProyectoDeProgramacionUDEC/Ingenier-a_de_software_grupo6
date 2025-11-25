import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:programa/Clases/reporte_list.dart';
import 'package:programa/ventanas/agregar_reporte_screen.dart';
import 'package:programa/Clases/ReporteService.dart';
import 'package:programa/ventanas/avisos_screen.dart';
import 'package:programa/services/user_service.dart';

class ReportesTabsScreen extends StatefulWidget {
  const ReportesTabsScreen({super.key});

  @override
  State<ReportesTabsScreen> createState() => _ReportesTabsScreenState();
}

class _ReportesTabsScreenState extends State<ReportesTabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Tenemos 4 pestañas: Perdidos, Encontrados, Avisos, Finalizados
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioLogueado = Provider.of<UserService>(context).usuarioLogueado;
    // (Opcional) Si tu ListaReportes pide esAdmin, lo dejamos, aunque la tarjeta ya maneja permisos
    final bool esAdmin = usuarioLogueado?.esAdmin ?? false;

    return Consumer<ReporteService>(
      builder: (context, reporteService, child) {
        // 1. Obtenemos solo los reportes que este usuario puede ver
        final listaSegura = reporteService.obtenerReportesVisibles(
          usuarioLogueado,
        );

        print('Mostrando ${listaSegura.length} reportes seguros.');

        // --- FILTROS PARA LA LÓGICA DE BALANCE ---

        // Pendientes (Estado false)
        final perdidosPendientes =
            listaSegura
                .where((r) => r.estado == false && r.tipoObjeto == false)
                .toList()
              ..sort((a, b) => b.fecha.compareTo(a.fecha));

        final encontradosPendientes =
            listaSegura.where((r) => !r.estado && r.tipoObjeto).toList()
              ..sort((a, b) => b.fecha.compareTo(a.fecha));

        // Resueltos (Estado true) - Usados para validar el "1 a 1"
        final perdidosResueltos = listaSegura
            .where((r) => r.estado && !r.tipoObjeto)
            .toList();
        final encontradosResueltos = listaSegura
            .where((r) => r.estado && r.tipoObjeto)
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text("Reportes de Objetos"),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.blue,
              tabs: const [
                Tab(text: "Perdidos"),
                Tab(text: "Encontrados"),
                Tab(text: "Avisos"),
                Tab(text: "Finalizados"),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              // --- TAB 1: PERDIDOS ---
              perdidosPendientes.isEmpty
                  ? const Center(
                      child: Text("No hay reportes de objetos perdidos."),
                    )
                  : ListaReportes(
                      reportes: perdidosPendientes,
                      // LOGICA: Si validamos un perdido...
                      onReporteChanged: (reporte) {
                        // Regla: Solo si las listas de resueltos están iguales (Ej: 2 perdidos y 2 encontrados)
                        if (perdidosResueltos.length ==
                            encontradosResueltos.length) {
                          reporteService.actualizarEstadoReporte(reporte, true);
                          // Animación: ¡Bien! Ahora ve a buscar el encontrado
                          _tabController.animateTo(1);
                        } else {
                          // Error: Ya hay un perdido "guacho". Faltan encontrados.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "⚠️ Balance incorrecto: Debes validar un 'Encontrado' primero.",
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          // Lo mandamos a donde debe ir (Finalizados/Historial) para que vea qué falta
                          _tabController.animateTo(3);
                        }
                      },
                    ),

              // --- TAB 2: ENCONTRADOS ---
              encontradosPendientes.isEmpty
                  ? const Center(child: Text("No hay hallazgos pendientes."))
                  : ListaReportes(
                      reportes: encontradosPendientes,
                      // LOGICA: Si validamos un encontrado...
                      onReporteChanged: (reporte) {
                        // Regla: Solo si hay más perdidos resueltos esperando pareja
                        if (encontradosResueltos.length <
                            perdidosResueltos.length) {
                          reporteService.actualizarEstadoReporte(reporte, true);
                          // Animación: ¡Ciclo completo! Vamos al historial
                          _tabController.animateTo(3);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "⚠️ Balance incorrecto: Primero valida un reporte de 'Objeto Perdido'.",
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      },
                    ),

              // --- TAB 3: AVISOS (Inteligencia Artificial / Match) ---
              AvisosScreen(todosLosReportes: listaSegura, similitudMinima: 0.6),

              // --- TAB 4: FINALIZADOS (Historial de balance) ---
              // Aquí mostramos las dos columnas para ver las parejas
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Perdidos Resueltos",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ListaReportes(
                            reportes: perdidosResueltos,
                            // Permitimos deshacer (volver a false) sin restricciones
                            onReporteChanged: (r) => reporteService
                                .actualizarEstadoReporte(r, false),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.swap_horiz, color: Colors.grey),
                  Expanded(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Encontrados Resueltos",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ListaReportes(
                            reportes: encontradosResueltos,
                            onReporteChanged: (r) => reporteService
                                .actualizarEstadoReporte(r, false),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
        );
      },
    );
  }
}
