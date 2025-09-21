import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../models/boleta_model.dart';

class PDFService {
  static Future<void> generateAndSharePDF(BoletaModel boleta) async {
    final pdf = pw.Document();

    // Crear el contenido del PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return _buildPDFContent(boleta);
        },
      ),
    );

    // Generar y compartir el PDF
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'boleta_${boleta.placa}_${DateFormat('yyyyMMdd_HHmm').format(boleta.fecha)}.pdf',
    );
  }

  static Future<Uint8List> generatePDFBytes(BoletaModel boleta) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return _buildPDFContent(boleta);
        },
      ),
    );

    return await pdf.save();
  }

  static pw.Widget _buildPDFContent(BoletaModel boleta) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Header
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(20),
          decoration: pw.BoxDecoration(
            color: PdfColors.red800,
            borderRadius: pw.BorderRadius.circular(12),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'LA JOYA AVANZA',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'MUNICIPALIDAD DISTRITAL DE LA JOYA',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 14,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                'Sistema de Fiscalización de Transporte - ClarityGov',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 24),

        // Título del documento
        pw.Center(
          child: pw.Text(
            'BOLETA DE FISCALIZACIÓN',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.red800,
            ),
          ),
        ),

        pw.SizedBox(height: 24),

        // Información básica
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Fecha: ${DateFormat('dd/MM/yyyy').format(boleta.fecha)}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    'Hora: ${DateFormat('HH:mm').format(boleta.fecha)}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Fiscalizador: ${boleta.codigoFiscalizador}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 20),

        // Datos del Vehículo
        _buildPDFSection(
          'DATOS DEL VEHÍCULO',
          [
            ['Placa:', boleta.placa.toUpperCase()],
            ['Empresa:', boleta.empresa],
          ],
        ),

        pw.SizedBox(height: 16),

        // Datos del Conductor
        _buildPDFSection(
          'DATOS DEL CONDUCTOR',
          [
            ['Conductor:', boleta.conductor],
            ['N° Licencia:', boleta.numeroLicencia],
          ],
        ),

        pw.SizedBox(height: 16),

        // Detalles de la Fiscalización
        _buildPDFSection(
          'DETALLES DE LA FISCALIZACIÓN',
          [
            ['Motivo:', boleta.motivo],
            ['Conforme:', boleta.conforme],
            if (boleta.descripciones != null) ['Descripciones:', boleta.descripciones!],
            if (boleta.observaciones != null) ['Observaciones:', boleta.observaciones!],
          ],
        ),

        pw.Spacer(),

        // Footer
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            children: [
              pw.Text(
                'Esta boleta fue generada electrónicamente por el sistema ClarityGov',
                style: const pw.TextStyle(fontSize: 10),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Municipalidad Distrital de La Joya - Área de Fiscalización',
                style: const pw.TextStyle(fontSize: 10),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Generado el ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 8),
                textAlign: pw.TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildPDFSection(String title, List<List<String>> data) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header de la sección
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey200,
              borderRadius: const pw.BorderRadius.only(
                topLeft: pw.Radius.circular(8),
                topRight: pw.Radius.circular(8),
              ),
            ),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          // Contenido de la sección
          pw.Padding(
            padding: const pw.EdgeInsets.all(12),
            child: pw.Column(
              children: data.map((row) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 120,
                        child: pw.Text(
                          row[0],
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(row[1]),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}