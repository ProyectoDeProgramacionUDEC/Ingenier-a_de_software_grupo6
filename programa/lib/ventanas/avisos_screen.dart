import 'package:flutter/material.dart';
import 'package:programa/Clases/reporte.dart';
import 'package:programa/services/similitud_service.dart';
import 'package:programa/widgets/coincidencia_card.dart';

class AvisosScreen extends StatelessWidget {
  final List<Reporte> todosLosReportes;
  final double similitudMinima;

  const AvisosScreen({
    super.key,
    required this.todosLosReportes,
    this.similitudMinima = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    final coincidencias = SimilitudService.encontrarCoincidencias(
      todosLosReportes,
      similitudMinima: similitudMinima,
    );

    return coincidencias.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: coincidencias.length,
            itemBuilder: (context, index) {
              return CoincidenciaCard(coincidencia: coincidencias[index]);
            },
          );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay coincidencias',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No se encontraron objetos perdidos y encontrados con nombres similares.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
