import 'package:flutter/material.dart';
import 'package:programa/Clases/reporte.dart';
import 'package:programa/componenetes/reporte_card.dart';

class ListaReportes extends StatelessWidget {
  final List<Reporte> reportes;
  final Function(Reporte, bool) onReporteChanged;

  const ListaReportes({
    super.key,
    required this.reportes,
    required this.onReporteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reportes.length,
      itemBuilder: (context, index) {
        return ReporteCard(
          reporte: reportes[index],
          onEncontradoChanged: (nuevoValor) {
            onReporteChanged(reportes[index], nuevoValor);
          },
        );
      },
    );
  }
}
