import 'package:flutter/material.dart';
import 'package:objetos_perdidos/reporte.dart';
import 'package:objetos_perdidos/reporte_list.dart';


// PANEL PARA VER OBJETOS DEL ADMINISTRADOR

class ReportesTabsScreen extends StatelessWidget {
  final List<Reporte> todosLosReportes;

  const ReportesTabsScreen({super.key, required this.todosLosReportes});

  @override
  Widget build(BuildContext context) {
    final perdidos = todosLosReportes.where((r) => !r.encontrado).toList()..sort((a, b) => b.fecha.compareTo(a.fecha));
    final encontrados = todosLosReportes.where((r) => r.encontrado).toList()..sort((a, b) => b.fecha.compareTo(a.fecha));

    return DefaultTabController(
      length: 2, // dos pestañas
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
      ),
    );
  }
}
