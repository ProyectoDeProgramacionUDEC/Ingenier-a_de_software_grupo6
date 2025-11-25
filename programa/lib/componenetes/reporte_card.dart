import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:programa/Clases/reporte.dart';
import 'package:programa/Clases/ReporteService.dart';
import 'package:programa/services/user_service.dart';
import 'package:programa/ventanas/detalle_reporte_screen.dart';
import 'package:programa/ventanas/agregar_reporte_screen.dart';

class ReporteCard extends StatefulWidget {
  final Reporte reporte;

  const ReporteCard({
    super.key,
    required this.reporte,
  });

  @override
  State<ReporteCard> createState() => _ReporteCardState();
}

class _ReporteCardState extends State<ReporteCard> {
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    final reporteService = Provider.of<ReporteService>(context, listen: false);
    
    // Obtenemos el usuario actual
    final userService = Provider.of<UserService>(context, listen: false);
    final usuario = userService.usuarioLogueado;

    // Vemos los permisos del usuario
    final esDueno = usuario != null && usuario.rut == widget.reporte.rutUsuario;
    // ¿Es Admin?
    final esAdmin = usuario?.esAdmin ?? false;

    final tienePermisos = esDueno || esAdmin;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            widget.reporte.imagenUrl,
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
        ),
        
        title: Text(widget.reporte.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          "Fecha: ${widget.reporte.fecha.day}/${widget.reporte.fecha.month}/${widget.reporte.fecha.year}",
        ),

        onTap: () async {
          if (_isNavigating) return;
          setState(() => _isNavigating = true);

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalleReporteScreen(reporte: widget.reporte),
            ),
          );

          if (context.mounted) {
            setState(() => _isNavigating = false);
          }
        },

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // El botón de check lo pueden ver todos los dueños para marcar encontrado
            IconButton(
              icon: Icon(
                widget.reporte.encontrado
                    ? Icons.check_circle
                    : Icons.check_circle_outline,
                color: widget.reporte.encontrado ? Colors.green : Colors.grey,
              ),
              onPressed: () {
                // Solo permitimos cambiar estado si tiene permisos
                if (tienePermisos) {
                   reporteService.actualizarEstadoReporte(
                    widget.reporte, 
                    !widget.reporte.encontrado
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No tienes permiso para modificar esto"))
                  );
                }
              },
            ),

            // Menú de editar/eliminar reportes
            if (tienePermisos)
              PopupMenuButton<String>(
                onSelected: (value) async {
                  
                  if (value == "edit") {
                    if (_isNavigating) return;
                    setState(() => _isNavigating = true);

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AgregarReporteScreen(
                          esEncontrado: widget.reporte.encontrado,
                          personalUdec: widget.reporte.PersonalUdec,
                          reporteParaEditar: widget.reporte,
                          esAdministrador: esAdmin,
                        ),
                      ),
                    );

                    if (context.mounted) {
                      setState(() => _isNavigating = false);
                    }
                  } 
                  
                  else if (value == "delete") {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Eliminar Reporte"),
                        content: const Text("¿Estás seguro? Esta acción no se puede deshacer."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancelar"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      reporteService.borrarReporte(widget.reporte);
                    }
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: "edit",
                    child: Row(
                      children: const [
                        Icon(Icons.edit, color: Colors.orange),
                        SizedBox(width: 8),
                        Text("Editar"),
                      ],
                    ),
                  ),
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