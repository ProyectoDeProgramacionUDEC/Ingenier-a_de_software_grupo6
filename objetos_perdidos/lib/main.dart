import 'package:flutter/material.dart';
import 'package:objetos_perdidos/reporte.dart';
import 'package:objetos_perdidos/screens/reportes_tab_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    /*
    final List<Reporte> sample = [
      Reporte(
        nombre: 'Llaves',
        fecha: DateTime.now().subtract(Duration(days: 3)),
        imagenUrl: 'https://picsum.photos/250?image=9',
        encontrado: false,
      ),
      Reporte(
        nombre: 'Mochila',
        fecha: DateTime.now().subtract(Duration(days: 2)),
        imagenUrl: 'https://picsum.photos/250?image=9',
        encontrado: false,
      ),
    ];
    */

    final List<Reporte> reportes = [];

    return MaterialApp(
      title: 'Objetos Perdidos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ReportesTabsScreen(todosLosReportes: reportes),
    );
  }
}
