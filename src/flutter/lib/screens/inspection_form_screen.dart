import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../theme/app_theme.dart';
import '../models/boleta_model.dart';

class InspectionFormScreen extends StatefulWidget {
  final VoidCallback onBack;

  const InspectionFormScreen({super.key, required this.onBack});

  @override
  State<InspectionFormScreen> createState() => _InspectionFormScreenState();
}

class _InspectionFormScreenState extends State<InspectionFormScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _placaController = TextEditingController();
  final _empresaController = TextEditingController();
  final _conductorController = TextEditingController();
  final _licenciaController = TextEditingController();
  final _fiscalizadorController = TextEditingController();
  final _motivoController = TextEditingController();
  final _descripcionesController = TextEditingController();
  final _observacionesController = TextEditingController();

  String _conforme = 'No';
  File? _licensePhoto;
  bool _isSubmitting = false;
  int _currentSection = 0;

  late TabController _tabController;
  final ImagePicker _picker = ImagePicker();

  final List<String> _conformeOptions = ['Sí', 'No', 'Parcialmente'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _placaController.dispose();
    _empresaController.dispose();
    _conductorController.dispose();
    _licenciaController.dispose();
    _fiscalizadorController.dispose();
    _motivoController.dispose();
    _descripcionesController.dispose();
    _observacionesController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _takeLicensePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          _licensePhoto = File(photo.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al tomar la foto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final boleta = BoletaModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        placa: _placaController.text.trim(),
        empresa: _empresaController.text.trim(),
        conductor: _conductorController.text.trim(),
        numeroLicencia: _licenciaController.text.trim(),
        codigoFiscalizador: _fiscalizadorController.text.trim(),
        motivo: _motivoController.text.trim(),
        conforme: _conforme,
        descripciones: _descripcionesController.text.trim().isEmpty 
            ? null 
            : _descripcionesController.text.trim(),
        observaciones: _observacionesController.text.trim().isEmpty 
            ? null 
            : _observacionesController.text.trim(),
        fecha: DateTime.now(),
        inspectorId: 'inspector_001',
        inspectorEmail: 'inspector@lajoya.gob.pe',
        licensePhotoPath: _licensePhoto?.path,
      );

      // Guardar en Firestore
      await FirebaseFirestore.instance
          .collection('boletas')
          .doc(boleta.id)
          .set(boleta.toMap());

      // Mostrar confirmación
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Boleta guardada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );

        // Mostrar diálogo de éxito
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 12),
                Text('¡Éxito!'),
              ],
            ),
            content: const Text(
              'La boleta de fiscalización ha sido guardada correctamente en la nube.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onBack();
                },
                child: const Text('Continuar'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: widget.onBack,
                      icon: const Icon(Icons.arrow_back),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nueva Fiscalización',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppTheme.primaryRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Complete todos los campos requeridos',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Tabs
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppTheme.primaryRed,
                  unselectedLabelColor: AppTheme.mutedForeground,
                  indicator: BoxDecoration(
                    color: AppTheme.primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  indicatorPadding: const EdgeInsets.all(4),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.directions_car, size: 20),
                      text: 'Vehículo',
                    ),
                    Tab(
                      icon: Icon(Icons.person, size: 20),
                      text: 'Conductor',
                    ),
                    Tab(
                      icon: Icon(Icons.assignment, size: 20),
                      text: 'Fiscalización',
                    ),
                  ],
                ),
              ),

              // Form Content
              Expanded(
                child: Form(
                  key: _formKey,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildVehicleSection(),
                      _buildDriverSection(),
                      _buildInspectionSection(),
                    ],
                  ),
                ),
              ),

              // Submit Button
              Container(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryRed,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Guardar Boleta',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.directions_car, color: AppTheme.primaryRed),
                  SizedBox(width: 12),
                  Text(
                    'Datos del Vehículo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.foregroundDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _placaController,
                decoration: const InputDecoration(
                  labelText: 'Placa del Vehículo *',
                  hintText: 'Ej: ABC-123',
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La placa es requerida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              TextFormField(
                controller: _empresaController,
                decoration: const InputDecoration(
                  labelText: 'Empresa de Transporte *',
                  hintText: 'Nombre de la empresa',
                  prefixIcon: Icon(Icons.business),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La empresa es requerida';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDriverSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.person, color: AppTheme.primaryRed),
                  SizedBox(width: 12),
                  Text(
                    'Información del Conductor',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.foregroundDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _conductorController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Conductor *',
                  hintText: 'Nombres y apellidos completos',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre del conductor es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              TextFormField(
                controller: _licenciaController,
                decoration: const InputDecoration(
                  labelText: 'Número de Licencia *',
                  hintText: 'Ej: B1234567',
                  prefixIcon: Icon(Icons.badge),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El número de licencia es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Foto de licencia
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.borderColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    if (_licensePhoto != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _licensePhoto!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    ElevatedButton.icon(
                      onPressed: _takeLicensePhoto,
                      icon: const Icon(Icons.camera_alt),
                      label: Text(_licensePhoto == null 
                          ? 'Tomar Foto de Licencia' 
                          : 'Cambiar Foto'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryRed,
                        side: const BorderSide(color: AppTheme.primaryRed),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInspectionSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.assignment, color: AppTheme.primaryRed),
                  SizedBox(width: 12),
                  Text(
                    'Detalles de Fiscalización',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.foregroundDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _fiscalizadorController,
                decoration: const InputDecoration(
                  labelText: 'Código de Fiscalizador *',
                  hintText: 'Ej: FISC001',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El código de fiscalizador es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              TextFormField(
                controller: _motivoController,
                decoration: const InputDecoration(
                  labelText: 'Motivo de la Fiscalización *',
                  hintText: 'Descripción del motivo',
                  prefixIcon: Icon(Icons.warning_amber),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El motivo es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Conforme dropdown
              DropdownButtonFormField<String>(
                value: _conforme,
                decoration: const InputDecoration(
                  labelText: 'Estado de Conformidad *',
                  prefixIcon: Icon(Icons.check_circle_outline),
                ),
                items: _conformeOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _conforme = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              
              TextFormField(
                controller: _descripcionesController,
                decoration: const InputDecoration(
                  labelText: 'Descripciones',
                  hintText: 'Detalles adicionales (opcional)',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              
              TextFormField(
                controller: _observacionesController,
                decoration: const InputDecoration(
                  labelText: 'Observaciones',
                  hintText: 'Observaciones adicionales (opcional)',
                  prefixIcon: Icon(Icons.note_alt),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}