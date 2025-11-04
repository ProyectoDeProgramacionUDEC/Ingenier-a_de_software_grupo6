import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:programa/Clases/reporte.dart';
import 'package:programa/Clases/reporte_list.dart';
import 'package:programa/ventanas/agregar_reporte_screen.dart';

class ReportesTabsScreen extends StatelessWidget {
  final List<Reporte> todosLosReportes;
  final Function(Reporte) onReporteAgregado;

  const ReportesTabsScreen({
    super.key,
    required this.todosLosReportes,
    required this.onReporteAgregado,
  });

  @override
  Widget build(BuildContext context) {
    final perdidos = todosLosReportes.where((r) => !r.encontrado).toList()
      ..sort((a, b) => b.fecha.compareTo(a.fecha));
    final encontrados = todosLosReportes.where((r) => r.encontrado).toList()
      ..sort((a, b) => b.fecha.compareTo(a.fecha));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Reportes de Objetos"),
          bottom: const TabBar(
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: "Perdidos"),
              Tab(text: "Encontrados"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListaReportes(reportes: perdidos),
            ListaReportes(reportes: encontrados),
          ],
        ),
        // BOTÓN FLOTANTE PARA AGREGAR
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AgregarReporteScreen(
                  onReporteAgregado: onReporteAgregado,
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
  }
}
