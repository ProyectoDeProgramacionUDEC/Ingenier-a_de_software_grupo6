import 'package:flutter/material.dart';
import 'package:objetos_perdidos/reporte_list.dart';
import 'package:objetos_perdidos/reporte.dart';

class EncontradosScreen extends StatelessWidget {
  final List<Reporte> todosLosReportes;

  const EncontradosScreen({super.key, required this.todosLosReportes});

  @override
  Widget build(BuildContext context) {
    final encontrados = todosLosReportes.where((r) => r.encontrado).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Objetos Encontrados')),
      body: ListaReportes(reportes: encontrados),
    );
  }
}
