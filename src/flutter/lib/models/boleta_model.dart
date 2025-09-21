class BoletaModel {
  final String id;
  final String placa;
  final String empresa;
  final String conductor;
  final String numeroLicencia;
  final String codigoFiscalizador;
  final String motivo;
  final String conforme;
  final String? descripciones;
  final String? observaciones;
  final DateTime fecha;
  final String inspectorId;
  final String? inspectorEmail;
  final String? licensePhotoPath;

  BoletaModel({
    required this.id,
    required this.placa,
    required this.empresa,
    required this.conductor,
    required this.numeroLicencia,
    required this.codigoFiscalizador,
    required this.motivo,
    required this.conforme,
    this.descripciones,
    this.observaciones,
    required this.fecha,
    required this.inspectorId,
    this.inspectorEmail,
    this.licensePhotoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'placa': placa,
      'empresa': empresa,
      'conductor': conductor,
      'numeroLicencia': numeroLicencia,
      'codigoFiscalizador': codigoFiscalizador,
      'motivo': motivo,
      'conforme': conforme,
      'descripciones': descripciones,
      'observaciones': observaciones,
      'fecha': fecha.toIso8601String(),
      'inspectorId': inspectorId,
      'inspectorEmail': inspectorEmail,
      'licensePhotoPath': licensePhotoPath,
    };
  }

  factory BoletaModel.fromMap(Map<String, dynamic> map) {
    return BoletaModel(
      id: map['id'] ?? '',
      placa: map['placa'] ?? '',
      empresa: map['empresa'] ?? '',
      conductor: map['conductor'] ?? '',
      numeroLicencia: map['numeroLicencia'] ?? '',
      codigoFiscalizador: map['codigoFiscalizador'] ?? '',
      motivo: map['motivo'] ?? '',
      conforme: map['conforme'] ?? 'No',
      descripciones: map['descripciones'],
      observaciones: map['observaciones'],
      fecha: DateTime.parse(map['fecha']),
      inspectorId: map['inspectorId'] ?? '',
      inspectorEmail: map['inspectorEmail'],
      licensePhotoPath: map['licensePhotoPath'],
    );
  }

  BoletaModel copyWith({
    String? id,
    String? placa,
    String? empresa,
    String? conductor,
    String? numeroLicencia,
    String? codigoFiscalizador,
    String? motivo,
    String? conforme,
    String? descripciones,
    String? observaciones,
    DateTime? fecha,
    String? inspectorId,
    String? inspectorEmail,
    String? licensePhotoPath,
  }) {
    return BoletaModel(
      id: id ?? this.id,
      placa: placa ?? this.placa,
      empresa: empresa ?? this.empresa,
      conductor: conductor ?? this.conductor,
      numeroLicencia: numeroLicencia ?? this.numeroLicencia,
      codigoFiscalizador: codigoFiscalizador ?? this.codigoFiscalizador,
      motivo: motivo ?? this.motivo,
      conforme: conforme ?? this.conforme,
      descripciones: descripciones ?? this.descripciones,
      observaciones: observaciones ?? this.observaciones,
      fecha: fecha ?? this.fecha,
      inspectorId: inspectorId ?? this.inspectorId,
      inspectorEmail: inspectorEmail ?? this.inspectorEmail,
      licensePhotoPath: licensePhotoPath ?? this.licensePhotoPath,
    );
  }
}