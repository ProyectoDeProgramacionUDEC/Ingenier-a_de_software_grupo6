import 'package:flutter/material.dart';
import 'package:objetos_perdidos/widgets/reporte_card.dart';
import 'package:objetos_perdidos/reporte.dart';

class ListaReportes extends StatelessWidget {
  final List<Reporte> reportes;

  const ListaReportes({super.key, required this.reportes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reportes.length,
      itemBuilder: (context, index) {
        return ReporteCard(reporte: reportes[index]);
      },
    );
  }
}
