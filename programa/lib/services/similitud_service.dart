import 'package:string_similarity/string_similarity.dart';
import 'package:programa/Clases/reporte.dart';
import 'package:programa/coincidencia.dart';
import 'dart:math';

class SimilitudService {
  static List<Coincidencia> encontrarCoincidencias(
    List<Reporte> todosLosReportes, {
    double similitudMinima = 0.8,
  }) {
    final perdidos = todosLosReportes.where((r) => !r.encontrado).toList();
    final encontrados = todosLosReportes.where((r) => r.encontrado).toList();
    final List<Coincidencia> coincidencias = [];

    for (var perdido in perdidos) {
      for (var encontrado in encontrados) {
        final similitudTitulo = _calcularSimilitud(
          perdido.nombre,
          encontrado.nombre,
        );
        
        final similitudDescripcion = _calcularSimilitud(
          perdido.descripcion,
          encontrado.descripcion,
        );

        if (similitudTitulo >= 0.7 || similitudDescripcion >= 0.6) {
          final similitudMaxima = max(similitudTitulo, similitudDescripcion);
          
          coincidencias.add(
            Coincidencia(
              perdido: perdido,
              encontrado: encontrado,
              similitud: similitudMaxima,
              similitudTitulo: similitudTitulo,
              similitudDescripcion: similitudDescripcion,
            ),
          );
        }
      }
    }

    coincidencias.sort((a, b) => b.similitud.compareTo(a.similitud));

    return coincidencias;
  }

  static double _calcularSimilitud(String str1, String str2) {
    final s1 = str1.toLowerCase().trim();
    final s2 = str2.toLowerCase().trim();

    return s1.similarityTo(s2);
  }
}
