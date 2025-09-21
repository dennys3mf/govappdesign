class BoletaModel {
  final String id;
  final String placa;
  final String empresa;
  final String conductor;
  final String numeroLicencia;
  final String fiscalizador; // Cambiado para coincidir con React
  final String motivo;
  final String conforme;
  final String? descripciones;
  final String? observaciones;
  final DateTime fecha;
  final String? fotoLicencia; // Cambiado para coincidir con React
  final double? multa; // Agregado para multas
  final String estado; // Agregado para estado de boleta

  BoletaModel({
    required this.id,
    required this.placa,
    required this.empresa,
    required this.conductor,
    required this.numeroLicencia,
    required this.fiscalizador,
    required this.motivo,
    required this.conforme,
    this.descripciones,
    this.observaciones,
    required this.fecha,
    this.fotoLicencia,
    this.multa,
    required this.estado,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'placa': placa,
      'empresa': empresa,
      'conductor': conductor,
      'numeroLicencia': numeroLicencia,
      'fiscalizador': fiscalizador,
      'motivo': motivo,
      'conforme': conforme,
      'descripciones': descripciones,
      'observaciones': observaciones,
      'fecha': fecha.toIso8601String(),
      'fotoLicencia': fotoLicencia,
      'multa': multa,
      'estado': estado,
    };
  }

  factory BoletaModel.fromMap(Map<String, dynamic> map) {
    return BoletaModel(
      id: map['id'] ?? '',
      placa: map['placa'] ?? '',
      empresa: map['empresa'] ?? '',
      conductor: map['conductor'] ?? '',
      numeroLicencia: map['numeroLicencia'] ?? '',
      fiscalizador: map['fiscalizador'] ?? map['codigoFiscalizador'] ?? '', // Compatibilidad con versión anterior
      motivo: map['motivo'] ?? '',
      conforme: map['conforme'] ?? 'No',
      descripciones: map['descripciones'],
      observaciones: map['observaciones'],
      fecha: DateTime.parse(map['fecha']),
      fotoLicencia: map['fotoLicencia'] ?? map['licensePhotoPath'], // Compatibilidad con versión anterior
      multa: map['multa']?.toDouble(),
      estado: map['estado'] ?? 'Activa',
    );
  }

  BoletaModel copyWith({
    String? id,
    String? placa,
    String? empresa,
    String? conductor,
    String? numeroLicencia,
    String? fiscalizador,
    String? motivo,
    String? conforme,
    String? descripciones,
    String? observaciones,
    DateTime? fecha,
    String? fotoLicencia,
    double? multa,
    String? estado,
  }) {
    return BoletaModel(
      id: id ?? this.id,
      placa: placa ?? this.placa,
      empresa: empresa ?? this.empresa,
      conductor: conductor ?? this.conductor,
      numeroLicencia: numeroLicencia ?? this.numeroLicencia,
      fiscalizador: fiscalizador ?? this.fiscalizador,
      motivo: motivo ?? this.motivo,
      conforme: conforme ?? this.conforme,
      descripciones: descripciones ?? this.descripciones,
      observaciones: observaciones ?? this.observaciones,
      fecha: fecha ?? this.fecha,
      fotoLicencia: fotoLicencia ?? this.fotoLicencia,
      multa: multa ?? this.multa,
      estado: estado ?? this.estado,
    );
  }

  // Getters para compatibilidad con código anterior
  String get codigoFiscalizador => fiscalizador;
  String? get licensePhotoPath => fotoLicencia;
  String get inspectorId => fiscalizador;
}