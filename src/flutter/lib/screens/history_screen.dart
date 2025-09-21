import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/boleta_model.dart';
import '../services/pdf_service.dart';
import '../services/print_service.dart';

class HistoryScreen extends StatefulWidget {
  final VoidCallback onBack;

  const HistoryScreen({super.key, required this.onBack});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  late AnimationController _refreshAnimationController;

  @override
  void initState() {
    super.initState();
    _refreshAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshAnimationController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    _refreshAnimationController.forward();
    await Future.delayed(const Duration(seconds: 1));
    _refreshAnimationController.reset();
  }

  Widget _getConformeIcon(String conforme) {
    switch (conforme.toLowerCase()) {
      case 'sí':
        return const Icon(Icons.check_circle, color: Colors.green, size: 16);
      case 'no':
        return const Icon(Icons.cancel, color: Colors.red, size: 16);
      case 'parcialmente':
        return const Icon(Icons.warning, color: Colors.orange, size: 16);
      default:
        return const Icon(Icons.help, color: Colors.grey, size: 16);
    }
  }

  Color _getConformeColor(String conforme) {
    switch (conforme.toLowerCase()) {
      case 'sí':
        return Colors.green.withOpacity(0.1);
      case 'no':
        return Colors.red.withOpacity(0.1);
      case 'parcialmente':
        return Colors.orange.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yy').format(date);
  }

  String _formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  Future<void> _showBoletaDetail(BoletaModel boleta) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header del diálogo
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.description,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Detalles de Boleta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Contenido del diálogo
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Información del Vehículo
                      _buildDetailSection(
                        'Información del Vehículo',
                        Icons.directions_car,
                        [
                          _buildDetailRow('Placa', boleta.placa.toUpperCase()),
                          _buildDetailRow('Empresa', boleta.empresa),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Información del Conductor
                      _buildDetailSection(
                        'Información del Conductor',
                        Icons.person,
                        [
                          _buildDetailRow('Conductor', boleta.conductor),
                          _buildDetailRow('N° Licencia', boleta.numeroLicencia),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Detalles de Fiscalización
                      _buildDetailSection(
                        'Detalles de Fiscalización',
                        Icons.assignment,
                        [
                          _buildDetailRow('Fecha y Hora', _formatDateTime(boleta.fecha)),
                          _buildDetailRow('Fiscalizador', boleta.codigoFiscalizador),
                          _buildDetailRow('Motivo', boleta.motivo),
                          _buildConformeRow('Conforme', boleta.conforme),
                          if (boleta.descripciones != null)
                            _buildDetailRow('Descripciones', boleta.descripciones!),
                          if (boleta.observaciones != null)
                            _buildDetailRow('Observaciones', boleta.observaciones!),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Botones de acción
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          try {
                            await PDFService.generateAndSharePDF(boleta);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('PDF generado exitosamente'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al generar PDF: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('PDF'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            await PrintService.printBoleta(boleta);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Boleta enviada a impresión'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al imprimir: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.print),
                        label: const Text('Imprimir'),
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

  Widget _buildDetailSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.primaryRed, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.foregroundDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 26),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.mutedForeground,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.foregroundDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConformeRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.mutedForeground,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _getConformeColor(value),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _getConformeIcon(value),
                const SizedBox(width: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoletaCard(BoletaModel boleta, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shadowColor: AppTheme.primaryRed.withOpacity(0.1),
      child: InkWell(
        onTap: () => _showBoletaDetail(boleta),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Número de boleta
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Información principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Primera línea: Placa y estado conforme
                    Row(
                      children: [
                        Text(
                          'Placa: ${boleta.placa.toUpperCase()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppTheme.foregroundDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getConformeColor(boleta.conforme),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _getConformeIcon(boleta.conforme),
                              const SizedBox(width: 4),
                              Text(
                                boleta.conforme,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Empresa
                    Text(
                      boleta.empresa,
                      style: const TextStyle(
                        color: AppTheme.mutedForeground,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Información adicional
                    Row(
                      children: [
                        const Icon(Icons.person, size: 14, color: AppTheme.mutedForeground),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            boleta.conductor,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.mutedForeground,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.badge, size: 14, color: AppTheme.mutedForeground),
                        const SizedBox(width: 4),
                        Text(
                          boleta.codigoFiscalizador,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Fecha y hora
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: AppTheme.mutedForeground),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(boleta.fecha),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time, size: 14, color: AppTheme.mutedForeground),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('HH:mm').format(boleta.fecha),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.visibility, size: 20, color: AppTheme.mutedForeground),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
                child: Column(
                  children: [
                    Row(
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
                                'Historial de Boletas',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppTheme.primaryRed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Boletas emitidas y sincronizadas',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Botón de refresh
                        IconButton(
                          onPressed: _refreshData,
                          icon: AnimatedBuilder(
                            animation: _refreshAnimationController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _refreshAnimationController.value * 2 * 3.141592653589793,
                                child: const Icon(Icons.refresh),
                              );
                            },
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Barra de búsqueda
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar por placa, empresa o conductor...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchTerm = value.toLowerCase();
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Lista de boletas
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('boletas')
                      .orderBy('fecha', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: AppTheme.primaryRed),
                            SizedBox(height: 16),
                            Text(
                              'Cargando historial...',
                              style: TextStyle(color: AppTheme.mutedForeground),
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Error al cargar los datos',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: 64,
                              color: AppTheme.mutedForeground,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No hay boletas guardadas',
                              style: TextStyle(
                                color: AppTheme.mutedForeground,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Las boletas emitidas aparecerán aquí',
                              style: TextStyle(
                                color: AppTheme.mutedForeground,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final boletas = snapshot.data!.docs
                        .map((doc) => BoletaModel.fromMap({
                              'id': doc.id,
                              ...doc.data() as Map<String, dynamic>
                            }))
                        .where((boleta) {
                          if (_searchTerm.isEmpty) return true;
                          return boleta.placa.toLowerCase().contains(_searchTerm) ||
                                 boleta.empresa.toLowerCase().contains(_searchTerm) ||
                                 boleta.conductor.toLowerCase().contains(_searchTerm);
                        })
                        .toList();

                    if (boletas.isEmpty && _searchTerm.isNotEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: AppTheme.mutedForeground,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No se encontraron resultados',
                              style: TextStyle(
                                color: AppTheme.mutedForeground,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Intenta con otros términos de búsqueda',
                              style: TextStyle(
                                color: AppTheme.mutedForeground,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Contador de resultados
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              '${boletas.length} boleta${boletas.length != 1 ? 's' : ''} ${_searchTerm.isNotEmpty ? 'encontrada${boletas.length != 1 ? 's' : ''}' : ''}',
                              style: const TextStyle(
                                color: AppTheme.mutedForeground,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          // Lista de boletas
                          Expanded(
                            child: ListView.builder(
                              itemCount: boletas.length,
                              itemBuilder: (context, index) {
                                return _buildBoletaCard(boletas[index], index);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}