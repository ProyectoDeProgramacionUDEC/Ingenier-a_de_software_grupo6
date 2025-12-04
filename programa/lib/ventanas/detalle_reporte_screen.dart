import 'package:flutter/material.dart';
import 'package:programa/Clases/reporte.dart';
import 'package:programa/Styles/appBar.dart';
import 'package:programa/Styles/appBar.dart';
import 'package:programa/Clases/informe.dart';

class DetalleReporteScreen extends StatelessWidget {
  final Reporte reporte;

  const DetalleReporteScreen({super.key, required this.reporte});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UdecAppBarRightLogo(title: "Detalle del Reporte"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 3. NAVEGA A LA VISTA PREVIA DEL PDF
          Navigator.push(
            context,
            MaterialPageRoute(
              // Le pasamos el mismo reporte que esta pantalla ya tiene
              builder: (context) => PantallaVistaPrevia(reporte: reporte),
            ),
          );
        },
        backgroundColor: Colors.blue[800], // O tu color de app
        foregroundColor: Colors.white,
        tooltip: 'Generar Informe PDF',
        child: const Icon(Icons.picture_as_pdf_outlined), // Icono de PDF
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageFullScreenViewer(
                      imageUrl: reporte.imagenUrl,
                      objectName: reporte.nombre,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  reporte.imagenUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.broken_image,
                        size: 100,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            _DetalleItem(
              titulo: 'Nombre del objeto',
              valor: reporte.nombre,
              icono: Icons.widgets_outlined,
            ),
            _DetalleItem(
              titulo: 'Descripción',
              valor: reporte.descripcion.isEmpty
                  ? 'No se proporcionó descripción.'
                  : reporte.descripcion,
              icono: Icons.description_outlined,
            ),
            _DetalleItem(
              titulo: 'Fecha del reporte',
              valor:
                  "${reporte.fecha.day}/${reporte.fecha.month}/${reporte.fecha.year}",
              icono: Icons.calendar_today_outlined,
            ),
            _DetalleItem(
              titulo: 'Estado',
              valor: reporte.estado ? 'Encontrado' : 'Perdido',
              icono: reporte.estado
                  ? Icons.check_circle_outline
                  : Icons.search_outlined,
            ),
            _DetalleItem(
              titulo: 'Ubicación',
              valor: reporte.ubicacion,
              icono: Icons.add_location_alt,
            ),

            const Divider(height: 32),

            _DetalleItem(
              titulo: 'Reportado por',
              valor: reporte.nombreUsuario.isEmpty
                  ? 'No especificado'
                  : reporte.nombreUsuario,
              icono: Icons.person_outline,
            ),
            _DetalleItem(
              titulo: 'Contacto',
              valor: reporte.contactoUsuario.isEmpty
                  ? 'No especificado'
                  : reporte.contactoUsuario,
              icono: Icons.contact_phone_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetalleItem extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;

  const _DetalleItem({
    required this.titulo,
    required this.valor,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icono, color: Colors.blue[800]),
      title: Text(titulo, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(valor, style: TextStyle(fontSize: 16)),
    );
  }
}

class ImageFullScreenViewer extends StatelessWidget {
  final String imageUrl;
  final String objectName;

  const ImageFullScreenViewer({
    super.key,
    required this.imageUrl,
    required this.objectName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(objectName),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 50),
                    SizedBox(height: 10),
                    Text(
                      'No se pudo cargar la imagen',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
