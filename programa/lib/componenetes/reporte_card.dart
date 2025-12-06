import 'package:flutter/material.dart';
import 'package:programa/Clases/ReporteService.dart';
import 'package:programa/Clases/reporte.dart';
import 'package:programa/services/user_service.dart';
import 'package:programa/ventanas/agregar_reporte_screen.dart';
import 'package:programa/ventanas/detalle_reporte_screen.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ReporteCard extends StatefulWidget {
  final Reporte reporte;
  final Function(Reporte)? onCustomAction;

  const ReporteCard({super.key, required this.reporte, this.onCustomAction});

  @override
  State<ReporteCard> createState() => _ReporteCardState();
}

class _ReporteCardState extends State<ReporteCard> {
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {

    // Servicios
    final reporteService = Provider.of<ReporteService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    final usuario = userService.usuarioLogueado;

    // Permisos
    final esDueno = usuario != null && usuario.rut == widget.reporte.rutUsuario;
    final esAdmin = usuario?.esAdmin ?? false;
    final tienePermisos = esDueno || esAdmin;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        // Imagen del objeto
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: widget.reporte.imagenUrl.startsWith('http')
              ? Image.network(
                  widget.reporte.imagenUrl,
                  width: 60, height: 60, fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(color: Colors.grey),
                )
              // Si no es http, revisamos si es Web o Móvil
              : kIsWeb
                  ? Image.network( // Para la aplicación web... tratamos la ruta local como URL
                      widget.reporte.imagenUrl,
                      width: 60, height: 60, fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(color: Colors.grey),
                    )
                  : Image.file( // Para la aplicación móvil tratamos simplemente con un archivo
                      File(widget.reporte.imagenUrl),
                      width: 60, height: 60, fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(color: Colors.grey),
                    ),
        ),

        title: Text(
          widget.reporte.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Text(
          "Fecha: ${widget.reporte.fecha.day}/${widget.reporte.fecha.month}/${widget.reporte.fecha.year}",
        ),

        // Navegación al detalle
        onTap: () async {
          if (_isNavigating) return;
          setState(() => _isNavigating = true);

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DetalleReporteScreen(reporte: widget.reporte),
            ),
          );

          if (context.mounted) {
            setState(() => _isNavigating = false);
          }
        },

        // Botones de acción (Trailing)
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Botón Check (Estado)
            IconButton(
              icon: Icon(
                widget.reporte.estado
                    ? Icons.check_circle
                    : Icons.check_circle_outline,
                color: widget.reporte.estado ? Colors.green : Colors.grey,
              ),
              onPressed: () {
                if (tienePermisos) {
                  if (widget.onCustomAction != null) {
                    widget.onCustomAction!(widget.reporte);
                  } else {
                    reporteService.actualizarEstadoReporte(
                      widget.reporte,
                      !widget.reporte.estado,
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("No tienes permiso para modificar esto"),
                    ),
                  );
                }
              },
            ),

            // 2. Menú Editar/Borrar (Solo si tiene los permisos necesarios)
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
                          esEncontrado: widget.reporte.estado,
                          personalUdec: widget.reporte.PersonalUdec,
                          reporteParaEditar: widget.reporte,
                          esAdministrador: esAdmin,
                        ),
                      ),
                    );

                    if (context.mounted) setState(() => _isNavigating = false);
                  } else if (value == "delete") {
                    // Confirmación de borrado
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Eliminar Reporte"),
                        content: const Text(
                          "¿Estás seguro? Esta acción no se puede deshacer.",
                        ),
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
                      // Borramos usando el servicio
                      reporteService.borrarReporte(widget.reporte);
                    }
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: "edit",
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.orange),
                        SizedBox(width: 8),
                        Text("Editar"),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: "delete",
                    child: Row(
                      children: [
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
