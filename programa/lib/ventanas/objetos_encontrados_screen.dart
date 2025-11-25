import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:programa/Clases/reporte_list.dart';
import 'package:programa/Clases/ReporteService.dart';
import 'package:programa/services/user_service.dart';

class EncontradosScreen extends StatelessWidget {
  const EncontradosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Identificamos al usuario y su rol
    final usuarioLogueado = Provider.of<UserService>(context).usuarioLogueado;
    final bool esAdmin = usuarioLogueado?.esAdmin ?? false;

    return Consumer<ReporteService>(
      builder: (context, reporteService, child) {
        
        // Pedimos la lista filtrada por seguridad
        final listaSegura = reporteService.obtenerReportesVisibles(usuarioLogueado);

        // Filtramos para esta pantalla ("Solo los Encontrados")
        final encontrados = listaSegura
            .where((r) => r.encontrado == true) 
            .toList();

        return Scaffold(
          appBar: AppBar(title: const Text('Objetos Encontrados')),

          body: encontrados.isEmpty 
            ? const Center(child: Text("No hay reportes encontrados"))
            : ListaReportes(
                reportes: encontrados,
                esAdmin: esAdmin, 
              ),
        );
      },
    );
  }
}