import 'package:flutter/material.dart';
import 'package:programa/Clases/reporte.dart';
import 'package:programa/Clases/reporte_list.dart';
import 'package:provider/provider.dart';
import 'package:programa/Clases/ReporteService.dart';
import 'package:programa/services/user_service.dart';

class EncontradosScreen extends StatelessWidget {
  const EncontradosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Identificamos al usuario
    final usuarioLogueado = Provider.of<UserService>(context).usuarioLogueado;

    return Consumer<ReporteService>(
      builder: (context, reporteService, child) {
        
        // Pedimos la lista FILTRADA por seguridad
        // Esto devuelve:
        // - Si es Admin: TODOS los reportes
        // - Si es Usuario: SOLO sus reportes
        final listaSegura = reporteService.obtenerReportesVisibles(usuarioLogueado);

        // Filtramos por la lógica de esta pantalla ("Encontrados")
        final encontrados = listaSegura
            .where((r) => r.encontrado == true) // Solo los marcados como encontrados
            .toList();

        return Scaffold(
          appBar: AppBar(title: const Text('Objetos Encontrados')),

          // Visualización (Si la lista está vacía, mostramos un mensaje)
          body: encontrados.isEmpty 
            ? const Center(child: Text("No hay reportes encontrados"))
            : ListaReportes(
                reportes: encontrados,
                onReporteChanged: (reporte, nuevoEstado) {
                  reporteService.actualizarEstadoReporte(reporte, nuevoEstado);
                },
              ),
        );
      },
    );
  }
}