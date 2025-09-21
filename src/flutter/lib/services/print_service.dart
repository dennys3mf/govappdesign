import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/boleta_model.dart';

class PrintService {
  static const MethodChannel _channel = MethodChannel('print_service');

  static Future<void> printBoleta(BoletaModel boleta) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final selectedPrinterId = prefs.getString('selected_printer_id');
      
      if (selectedPrinterId == null) {
        throw Exception('No hay una impresora configurada');
      }

      final printData = _formatBoletaForPrinting(boleta);
      
      await _channel.invokeMethod('printText', {
        'printerId': selectedPrinterId,
        'text': printData,
      });
    } catch (e) {
      throw Exception('Error al imprimir: $e');
    }
  }

  static String _formatBoletaForPrinting(BoletaModel boleta) {
    final StringBuffer buffer = StringBuffer();
    
    // Header
    buffer.writeln('================================');
    buffer.writeln('        LA JOYA AVANZA');
    buffer.writeln('   MUNICIPALIDAD DISTRITAL');
    buffer.writeln('================================');
    buffer.writeln('  BOLETA DE FISCALIZACION');
    buffer.writeln('================================');
    buffer.writeln();
    
    // Fecha y hora
    buffer.writeln('Fecha: ${DateFormat('dd/MM/yyyy').format(boleta.fecha)}');
    buffer.writeln('Hora:  ${DateFormat('HH:mm').format(boleta.fecha)}');
    buffer.writeln('Fiscalizador: ${boleta.codigoFiscalizador}');
    buffer.writeln();
    
    // Separador
    buffer.writeln('--------------------------------');
    buffer.writeln('    DATOS DEL VEHICULO');
    buffer.writeln('--------------------------------');
    buffer.writeln('Placa:   ${boleta.placa.toUpperCase()}');
    buffer.writeln('Empresa: ${_truncateText(boleta.empresa, 24)}');
    buffer.writeln();
    
    // Datos del conductor
    buffer.writeln('--------------------------------');
    buffer.writeln('    DATOS DEL CONDUCTOR');
    buffer.writeln('--------------------------------');
    buffer.writeln('Conductor: ${_truncateText(boleta.conductor, 22)}');
    buffer.writeln('Licencia:  ${boleta.numeroLicencia}');
    buffer.writeln();
    
    // Detalles de fiscalización
    buffer.writeln('--------------------------------');
    buffer.writeln('    DETALLES FISCALIZACION');
    buffer.writeln('--------------------------------');
    buffer.writeln('Motivo:');
    buffer.writeln(_wrapText(boleta.motivo, 32));
    buffer.writeln();
    buffer.writeln('Conforme: ${boleta.conforme}');
    buffer.writeln();
    
    if (boleta.descripciones != null && boleta.descripciones!.isNotEmpty) {
      buffer.writeln('Descripciones:');
      buffer.writeln(_wrapText(boleta.descripciones!, 32));
      buffer.writeln();
    }
    
    if (boleta.observaciones != null && boleta.observaciones!.isNotEmpty) {
      buffer.writeln('Observaciones:');
      buffer.writeln(_wrapText(boleta.observaciones!, 32));
      buffer.writeln();
    }
    
    // Footer
    buffer.writeln('================================');
    buffer.writeln('Sistema ClarityGov');
    buffer.writeln('Generado: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}');
    buffer.writeln('================================');
    buffer.writeln();
    buffer.writeln();
    buffer.writeln();
    
    return buffer.toString();
  }

  static String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }

  static String _wrapText(String text, int lineLength) {
    if (text.length <= lineLength) return text;
    
    final StringBuffer buffer = StringBuffer();
    int start = 0;
    
    while (start < text.length) {
      int end = start + lineLength;
      if (end > text.length) end = text.length;
      
      // Buscar el último espacio antes del límite para no cortar palabras
      if (end < text.length) {
        int lastSpace = text.lastIndexOf(' ', end);
        if (lastSpace > start) {
          end = lastSpace;
        }
      }
      
      buffer.writeln(text.substring(start, end));
      start = end;
      if (start < text.length && text[start] == ' ') {
        start++; // Saltar el espacio al inicio de la nueva línea
      }
    }
    
    return buffer.toString();
  }

  static Future<List<Map<String, String>>> getAvailablePrinters() async {
    try {
      final result = await _channel.invokeMethod('getAvailablePrinters');
      return List<Map<String, String>>.from(result);
    } catch (e) {
      return [];
    }
  }

  static Future<bool> connectToPrinter(String printerId) async {
    try {
      final result = await _channel.invokeMethod('connectToPrinter', {
        'printerId': printerId,
      });
      return result as bool;
    } catch (e) {
      return false;
    }
  }
}