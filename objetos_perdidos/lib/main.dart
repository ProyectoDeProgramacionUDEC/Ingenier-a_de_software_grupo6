import 'package:flutter/material.dart';
import 'package:objetos_perdidos/reporte.dart';
import 'package:objetos_perdidos/screens/reportes_tab_screen.dart';

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

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final List<Reporte> _reportes = [];

  void _agregarReporte(Reporte nuevoReporte) {
    setState(() {
      _reportes.add(nuevoReporte);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Objetos Perdidos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ReportesTabsScreen(
        todosLosReportes: _reportes,
        onReporteAgregado: _agregarReporte,
      ),
    );
  }
}