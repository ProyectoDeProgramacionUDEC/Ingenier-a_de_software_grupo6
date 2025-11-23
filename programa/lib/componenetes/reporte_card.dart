import 'package:flutter/material.dart';
import 'package:programa/Clases/reporte.dart';
// ¡Importa la nueva pantalla que acabamos de crear!
import 'package:programa/ventanas/detalle_reporte_screen.dart';

// 1. Convertimos a StatefulWidget
class ReporteCard extends StatefulWidget {
  final Reporte reporte;
  final ValueChanged<bool> onEncontradoChanged;
  final Function(Reporte) onDelete; // callback para eliminar

  const ReporteCard({
    super.key,
    required this.reporte,
    required this.onEncontradoChanged,
    required this.onDelete,
  });

  @override
  State<ReporteCard> createState() => _ReporteCardState();
}

class _ReporteCardState extends State<ReporteCard> {
  // 2. El "seguro" anti-spam
  bool _isNavigating = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Image.network(
          widget.reporte.imagenUrl, // <-- 3. Usamos 'widget.reporte'
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 60,
              height: 60,
              color: Colors.grey[200],
              child: Icon(Icons.image, color: Colors.grey[400]),
            );
          },
        ),
        title: Text(widget.reporte.nombre), // <-- 3. Usamos 'widget.reporte'
        subtitle: Text(
          "Fecha: ${widget.reporte.fecha.day}/${widget.reporte.fecha.month}/${widget.reporte.fecha.year}",
        ),

        // --- 4. LA SOLUCIÓN AL CRASH Y AL "NO CLICK" ---
        onTap: () async {
          if (_isNavigating) return; // Si ya estoy navegando, ignora el click.

          setState(() {
            _isNavigating = true;
          });

          // Navega a la nueva pantalla de detalles
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DetalleReporteScreen(reporte: widget.reporte),
            ),
          );

          // Desactiva el seguro CUANDO EL USUARIO REGRESE
          if (context.mounted) {
            setState(() {
              _isNavigating = false;
            });
          }
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                widget.reporte.encontrado
                    ? Icons.check_circle
                    : Icons.check_circle_outline,
                color: widget.reporte.encontrado ? Colors.green : Colors.grey,
              ),
              onPressed: () {
                widget.onEncontradoChanged(!widget.reporte.encontrado);
              },
            ),

            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == "delete") {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Eliminar Reporte"),
                      content: const Text(
                          "¿Estás seguro de que deseas eliminar este reporte?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancelar"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            "Eliminar",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    widget.onDelete(widget.reporte);
                  }
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "delete",
                  child: Row(
                    children: const [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text("Eliminar"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

