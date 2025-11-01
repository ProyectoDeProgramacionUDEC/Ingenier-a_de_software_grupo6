import 'package:flutter/material.dart';
import 'package:objetos_perdidos/reporte.dart';

class ReporteCard extends StatelessWidget {
  final Reporte reporte;

  const ReporteCard({super.key, required this.reporte});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Image.network(reporte.imagenUrl, width: 60, height: 60, fit: BoxFit.cover),
        title: Text(reporte.nombre),
        subtitle: Text(
          "Fecha: ${reporte.fecha.day}/${reporte.fecha.month}/${reporte.fecha.year}",
        ),
      ),
    );
  }
}
