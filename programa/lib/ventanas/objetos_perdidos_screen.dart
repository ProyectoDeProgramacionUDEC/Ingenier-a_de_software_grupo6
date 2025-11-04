import 'package:flutter/material.dart';
import 'package:programa/Clases/reporte.dart';
import 'package:programa/Clases/reporte_list.dart';
import 'package:programa/Styles/appBar.dart';

class PerdidosScreen extends StatelessWidget {
  final List<Reporte> todosLosReportes;

  const PerdidosScreen({super.key, required this.todosLosReportes});

  @override
  Widget build(BuildContext context) {
    final perdidos = todosLosReportes.where((r) => !r.encontrado).toList();

    return Scaffold(
      appBar: UdecAppBarRightLogo(title: "OBJETOS Perdidos"),
      body: ListaReportes(reportes: perdidos),
    );
  }
}
