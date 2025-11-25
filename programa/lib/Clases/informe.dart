import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/src/pdf/page_format.dart' as pfn;
import 'package:programa/Clases/reporte.dart';

class PantallaVistaPrevia extends StatelessWidget {
  final Reporte reporte;
  const PantallaVistaPrevia({super.key, required this.reporte});

  // La función es asincrónica y ahora recibe el reporte.
  Future<Uint8List> generarPdf(Reporte reporte) async {
    final pdfDoc = pw.Document();

    //Carga el logo de la UdeC desde los assets ---
    final logoImage = pw.MemoryImage(
      (await rootBundle.load(
        'assets/images/LogoUdec.png',
      )).buffer.asUint8List(),
    );

    // Cargamos fuentes
    final font = await PdfGoogleFonts.tinosRegular();
    final boldFont = await PdfGoogleFonts.tinosBold();

    final pdfTheme = pw.ThemeData.withFont(base: font, bold: boldFont);

    // Cargamos la imagen del reporte
    pw.ImageProvider? imageProvider;
    try {
      if (reporte.imagenUrl != null && reporte.imagenUrl.isNotEmpty) {
        imageProvider = await networkImage(reporte.imagenUrl);
      }
    } catch (e) {
      print('Error al cargar la imagen del PDF: $e');
      imageProvider = null;
    }

    // Usamos MultiPage para el layout formal
    pdfDoc.addPage(
      pw.MultiPage(
        pageFormat: pdf.PdfPageFormat.a4,
        theme: pdfTheme,

        // Encabezado de Página
        header: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerLeft,
            margin: pw.EdgeInsets.only(bottom: 3.0 * pdf.PdfPageFormat.mm),
            padding: pw.EdgeInsets.only(bottom: 3.0 * pdf.PdfPageFormat.cm),
            decoration: pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: pdf.PdfColors.grey, width: 0.5),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.SizedBox(height: 40, child: pw.Image(logoImage)),
                pw.Text(
                  'Informe de Objeto',
                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                    color: pdf.PdfColors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },

        // Pie de Página
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: pw.EdgeInsets.only(top: 1.0 * pdf.PdfPageFormat.cm),
            child: pw.Text(
              'Página ${context.pageNumber} de ${context.pagesCount}',
              style: pw.Theme.of(
                context,
              ).defaultTextStyle.copyWith(color: pdf.PdfColors.grey),
            ),
          );
        },

        build: (pw.Context context) {
          return [
            // Título principal
            pw.Header(
              level: 0,
              child: pw.Text(
                'Informe de pérdida/encuentro de objeto',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 1 * pdf.PdfPageFormat.cm),

            // Datos principales
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(
                  width: 150,
                  height: 150,
                  child: imageProvider != null
                      ? pw.Image(imageProvider, fit: pw.BoxFit.cover)
                      : pw.Container(
                          color: pdf.PdfColors.grey300,
                          child: pw.Center(
                            child: pw.Text(
                              'Sin Imagen',
                              style: pw.TextStyle(color: pdf.PdfColors.grey600),
                            ),
                          ),
                        ),
                ),
                pw.SizedBox(width: 1 * pdf.PdfPageFormat.cm),

                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildDetalleRow('Objeto:', reporte.nombre),
                      _buildDetalleRow(
                        'Estado:',
                        reporte.estado ? 'Encontrado' : 'Perdido',
                      ),
                      _buildDetalleRow(
                        'Fecha:',
                        "${reporte.fecha.day}/${reporte.fecha.month}/${reporte.fecha.year}",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 1 * pdf.PdfPageFormat.cm),

            // Descripción
            _buildSectionHeader('Descripción dada por el usuario'),
            pw.Text(
              (reporte.descripcion?.isEmpty ?? true)
                  ? 'No se proporcionó descripción.'
                  : reporte.descripcion ?? '',
              style: const pw.TextStyle(lineSpacing: 2),
            ),
            pw.SizedBox(height: 1 * pdf.PdfPageFormat.cm),

            // Contacto
            _buildSectionHeader('Información de Contacto'),
            _buildDetalleRow('Reportado por:', reporte.nombreUsuario),
            _buildDetalleRow('Contacto:', reporte.contactoUsuario),
          ];
        },
      ),
    );

    return pdfDoc.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vista Previa del PDF')),
      body: PdfPreview(build: (format) => generarPdf(reporte)),
    );
  }
}

pw.Widget _buildSectionHeader(String title) {
  return pw.Container(
    margin: pw.EdgeInsets.only(bottom: 0.5 * pdf.PdfPageFormat.mm),
    padding: pw.EdgeInsets.only(bottom: 2 * pdf.PdfPageFormat.mm),
    decoration: pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(color: pdf.PdfColors.blueGrey, width: 1.5),
      ),
    ),
    child: pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 16,
        fontWeight: pw.FontWeight.bold,
        color: pdf.PdfColors.blueGrey, // usa un color existente
      ),
    ),
  );
}

pw.Widget _buildDetalleRow(String titulo, String? valor) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 4),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 3,
          child: pw.Text(
            titulo,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(width: 10),
        pw.Expanded(
          flex: 7,
          child: pw.Text(
            valor == null || valor.isEmpty ? 'No especificado' : valor,
          ),
        ),
      ],
    ),
  );
}
