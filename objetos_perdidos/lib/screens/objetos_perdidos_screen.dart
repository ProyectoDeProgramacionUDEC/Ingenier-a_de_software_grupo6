import 'package:flutter/material.dart';
import 'package:objetos_perdidos/reporte_list.dart';
import 'package:objetos_perdidos/reporte.dart';

class PerdidosScreen extends StatelessWidget {
  final List<Reporte> todosLosReportes;

  const PerdidosScreen({super.key, required this.todosLosReportes});

  @override
  Widget build(BuildContext context) {
    final perdidos = todosLosReportes.where((r) => !r.encontrado).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Objetos Perdidos')),
      body: ListaReportes(reportes: perdidos),
    );
  }
}
