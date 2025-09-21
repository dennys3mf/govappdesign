import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/boleta_model.dart';

class AdminDashboardScreen extends StatefulWidget {
  final VoidCallback onLogout;
  final String? userName;

  const AdminDashboardScreen({
    super.key,
    required this.onLogout,
    this.userName,
  });

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Estados para filtros
  String _searchTerm = '';
  String _selectedInspector = 'all';
  String _selectedStatus = 'all';
  String _photoSearchTerm = '';
  String _photoFilterInspector = 'all';
  String _photoFilterConforme = 'all';
  
  // Estados para modales
  bool _isPhotoViewerOpen = false;
  BoletaModel? _selectedPhoto;

  // Mock data - igual que en React
  final List<BoletaModel> _boletas = [
    BoletaModel(
      id: '1',
      placa: 'ABC-123',
      empresa: 'Transportes San Martín',
      conductor: 'Juan Carlos Pérez',
      numeroLicencia: 'B123456789',
      fiscalizador: 'FISC001',
      motivo: 'Revisión rutinaria de documentos',
      conforme: 'Sí',
      fecha: DateTime(2024, 1, 15, 10, 30),
      fotoLicencia: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=300&fit=crop',
      descripciones: 'Documentación completa y en regla',
      multa: 0,
      estado: 'Activa',
    ),
    BoletaModel(
      id: '2',
      placa: 'DEF-456',
      empresa: 'Express Arequipa',
      conductor: 'María Elena Rodriguez',
      numeroLicencia: 'B987654321',
      fiscalizador: 'FISC002',
      motivo: 'Verificación de licencia vencida',
      conforme: 'No',
      fecha: DateTime(2024, 1, 15, 11, 45),
      fotoLicencia: 'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=400&h=300&fit=crop',
      observaciones: 'Licencia vencida desde hace 3 meses',
      multa: 850.00,
      estado: 'Activa',
    ),
    BoletaModel(
      id: '3',
      placa: 'GHI-789',
      empresa: 'Turismo La Joya',
      conductor: 'Carlos Alberto Mendoza',
      numeroLicencia: 'B456789123',
      fiscalizador: 'FISC001',
      motivo: 'Control de seguridad vehicular',
      conforme: 'Parcialmente',
      fecha: DateTime(2024, 1, 15, 14, 20),
      fotoLicencia: 'https://images.unsplash.com/photo-1597223557154-721c1cecc4b0?w=400&h=300&fit=crop',
      descripciones: 'Licencia válida pero falta certificado de revisión técnica',
      multa: 425.00,
      estado: 'Pagada',
    ),
    BoletaModel(
      id: '4',
      placa: 'JKL-012',
      empresa: 'Servicios Unidos',
      conductor: 'Ana Patricia Flores',
      numeroLicencia: 'B789123456',
      fiscalizador: 'FISC003',
      motivo: 'Inspección de documentos de carga',
      conforme: 'Sí',
      fecha: DateTime(2024, 1, 15, 16, 10),
      fotoLicencia: 'https://images.unsplash.com/photo-1494790108755-2616c045c7d3?w=400&h=300&fit=crop',
      descripciones: 'Todo en orden, documentación completa',
      multa: 0,
      estado: 'Activa',
    ),
    BoletaModel(
      id: '5',
      placa: 'MNO-345',
      empresa: 'Transportes del Sur',
      conductor: 'Roberto Silva Vargas',
      numeroLicencia: 'B321654987',
      fiscalizador: 'FISC002',
      motivo: 'Verificación de permisos especiales',
      conforme: 'No',
      fecha: DateTime(2024, 1, 14, 9, 15),
      fotoLicencia: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=300&fit=crop',
      observaciones: 'Falta permiso para transporte de pasajeros',
      multa: 750.00,
      estado: 'Activa',
    ),
    BoletaModel(
      id: '6',
      placa: 'PQR-678',
      empresa: 'Turismo Regional',
      conductor: 'Carmen Rosa Gutiérrez',
      numeroLicencia: 'B654321098',
      fiscalizador: 'FISC001',
      motivo: 'Control de rutina',
      conforme: 'Sí',
      fecha: DateTime(2024, 1, 14, 14, 30),
      fotoLicencia: 'https://images.unsplash.com/photo-1607746882042-944635dfe10e?w=400&h=300&fit=crop',
      descripciones: 'Licencia vigente, documentos en orden',
      multa: 0,
      estado: 'Activa',
    ),
    BoletaModel(
      id: '7',
      placa: 'STU-901',
      empresa: 'Express Lima',
      conductor: 'Miguel Ángel Torres',
      numeroLicencia: 'B098765432',
      fiscalizador: 'FISC003',
      motivo: 'Verificación de documentos',
      conforme: 'Parcialmente',
      fecha: DateTime(2024, 1, 14, 11, 20),
      fotoLicencia: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop',
      descripciones: 'Licencia válida, falta certificado médico actualizado',
      multa: 200.00,
      estado: 'Pagada',
    ),
    BoletaModel(
      id: '8',
      placa: 'VWX-234',
      empresa: 'Carga Pesada SAC',
      conductor: 'Luis Alberto Ramírez',
      numeroLicencia: 'B567890123',
      fiscalizador: 'FISC002',
      motivo: 'Inspección de carga',
      conforme: 'No',
      fecha: DateTime(2024, 1, 13, 8, 45),
      fotoLicencia: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=300&fit=crop',
      observaciones: 'Licencia para categoría incorrecta',
      multa: 1200.00,
      estado: 'Anulada',
    ),
  ];

  final List<Map<String, dynamic>> _inspectores = [
    {
      'id': 'FISC001',
      'nombre': 'Carlos Mendoza',
      'codigo': 'FISC001',
      'email': 'c.mendoza@lajoya.gob.pe',
      'telefono': '+51 987 654 321',
      'estado': 'Activo',
      'fechaIngreso': DateTime(2023, 6, 15),
      'boletas': 15,
      'conformes': 12,
      'noConformes': 3,
      'ultimaActividad': DateTime(2024, 1, 15, 16, 45),
    },
    {
      'id': 'FISC002',
      'nombre': 'Ana Rodriguez',
      'codigo': 'FISC002',
      'email': 'a.rodriguez@lajoya.gob.pe',
      'telefono': '+51 987 654 322',
      'estado': 'Activo',
      'fechaIngreso': DateTime(2023, 3, 10),
      'boletas': 22,
      'conformes': 18,
      'noConformes': 4,
      'ultimaActividad': DateTime(2024, 1, 15, 15, 20),
    },
    {
      'id': 'FISC003',
      'nombre': 'Miguel Torres',
      'codigo': 'FISC003',
      'email': 'm.torres@lajoya.gob.pe',
      'telefono': '+51 987 654 323',
      'estado': 'Inactivo',
      'fechaIngreso': DateTime(2023, 8, 20),
      'boletas': 8,
      'conformes': 6,
      'noConformes': 2,
      'ultimaActividad': DateTime(2024, 1, 10, 14, 10),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Filtros para boletas
  List<BoletaModel> get _filteredBoletas {
    return _boletas.where((boleta) {
      final matchesSearch = boleta.placa.toLowerCase().contains(_searchTerm.toLowerCase()) ||
          boleta.empresa.toLowerCase().contains(_searchTerm.toLowerCase()) ||
          boleta.conductor.toLowerCase().contains(_searchTerm.toLowerCase()) ||
          boleta.fiscalizador.toLowerCase().contains(_searchTerm.toLowerCase());
      
      final matchesInspector = _selectedInspector == 'all' || boleta.fiscalizador == _selectedInspector;
      final matchesStatus = _selectedStatus == 'all' || boleta.estado == _selectedStatus;
      
      return matchesSearch && matchesInspector && matchesStatus;
    }).toList();
  }

  // Filtros para fotos
  List<BoletaModel> get _filteredPhotos {
    return _boletas.where((boleta) {
      if (boleta.fotoLicencia == null || boleta.fotoLicencia!.isEmpty) return false;
      
      final matchesSearch = boleta.placa.toLowerCase().contains(_photoSearchTerm.toLowerCase()) ||
          boleta.empresa.toLowerCase().contains(_photoSearchTerm.toLowerCase()) ||
          boleta.conductor.toLowerCase().contains(_photoSearchTerm.toLowerCase()) ||
          boleta.fiscalizador.toLowerCase().contains(_photoSearchTerm.toLowerCase());
      
      final matchesInspector = _photoFilterInspector == 'all' || boleta.fiscalizador == _photoFilterInspector;
      final matchesConforme = _photoFilterConforme == 'all' || boleta.conforme == _photoFilterConforme;
      
      return matchesSearch && matchesInspector && matchesConforme;
    }).toList();
  }

  // Estadísticas calculadas
  int get _totalBoletas => _boletas.length;
  int get _totalConformes => _boletas.where((b) => b.conforme == 'Sí').length;
  int get _totalNoConformes => _boletas.where((b) => b.conforme == 'No').length;
  int get _totalParciales => _boletas.where((b) => b.conforme == 'Parcialmente').length;
  int get _totalInspectores => _inspectores.length;
  int get _inspectoresActivos => _inspectores.where((i) => i['estado'] == 'Activo').length;
  double get _totalMultas => _boletas.fold(0.0, (sum, b) => sum + (b.multa ?? 0));
  int get _totalFotos => _boletas.where((b) => b.fotoLicencia != null && b.fotoLicencia!.isNotEmpty).length;

  Color _getConformeColor(String conforme) {
    switch (conforme) {
      case 'Sí':
        return const Color(0xFFDCFCE7);
      case 'No':
        return const Color(0xFFFEE2E2);
      case 'Parcialmente':
        return const Color(0xFFFEF3C7);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color _getConformeTextColor(String conforme) {
    switch (conforme) {
      case 'Sí':
        return const Color(0xFF166534);
      case 'No':
        return const Color(0xFF991B1B);
      case 'Parcialmente':
        return const Color(0xFF92400E);
      default:
        return const Color(0xFF374151);
    }
  }

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'Activa':
        return const Color(0xFFDBEAFE);
      case 'Pagada':
        return const Color(0xFFDCFCE7);
      case 'Anulada':
        return const Color(0xFFFEE2E2);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color _getEstadoTextColor(String estado) {
    switch (estado) {
      case 'Activa':
        return const Color(0xFF1E40AF);
      case 'Pagada':
        return const Color(0xFF166534);
      case 'Anulada':
        return const Color(0xFF991B1B);
      default:
        return const Color(0xFF374151);
    }
  }

  IconData _getConformeIcon(String conforme) {
    switch (conforme) {
      case 'Sí':
        return Icons.check_circle;
      case 'No':
        return Icons.cancel;
      case 'Parcialmente':
        return Icons.warning;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryRed.withOpacity(0.05),
              const Color(0xFFFDEDED).withOpacity(0.5),
              AppTheme.primaryRed.withOpacity(0.10),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              // Stats Cards
              _buildStatsCards(),
              
              // Tabs
              Expanded(child: _buildTabsContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.primaryRed.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo y título
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 24,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    color: AppTheme.primaryRed,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Panel Administrativo',
                      style: TextStyle(
                        color: AppTheme.primaryRed,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Gestión de Fiscalización - ${widget.userName ?? "Administrador"}',
                      style: TextStyle(
                        color: AppTheme.mutedForeground,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Actions
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.shield,
                      color: Color(0xFF166534),
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Administrador',
                      style: TextStyle(
                        color: Color(0xFF166534),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Exportar'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: widget.onLogout,
                icon: const Icon(Icons.logout),
                color: AppTheme.mutedForeground,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 1200 ? 6 
                              : constraints.maxWidth > 800 ? 3 
                              : constraints.maxWidth > 600 ? 2 
                              : 1;
          
          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.5,
            children: [
              _buildStatCard(
                'Total Boletas',
                _totalBoletas.toString(),
                Icons.description,
                const Color(0xFF3B82F6),
                const Color(0xFFEFF6FF),
              ),
              _buildStatCard(
                'Conformes',
                _totalConformes.toString(),
                Icons.check_circle,
                const Color(0xFF10B981),
                const Color(0xFFECFDF5),
              ),
              _buildStatCard(
                'No Conformes',
                _totalNoConformes.toString(),
                Icons.cancel,
                const Color(0xFFEF4444),
                const Color(0xFFFEF2F2),
              ),
              _buildStatCard(
                'Inspectores',
                '$_inspectoresActivos/$_totalInspectores',
                Icons.people,
                const Color(0xFF8B5CF6),
                const Color(0xFFF5F3FF),
              ),
              _buildStatCard(
                'Total Multas',
                'S/ ${_totalMultas.toInt()}',
                Icons.trending_up,
                const Color(0xFFF59E0B),
                const Color(0xFFFFFBEB),
              ),
              _buildStatCard(
                'Fotos Licencias',
                _totalFotos.toString(),
                Icons.camera_alt,
                const Color(0xFF14B8A6),
                const Color(0xFFF0FDFA),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color iconColor, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Colors.white,
            backgroundColor.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.mutedForeground,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [iconColor, iconColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsContent() {
    return Column(
      children: [
        // Tab Bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppTheme.primaryRed.withOpacity(0.1),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: AppTheme.primaryRed,
            unselectedLabelColor: AppTheme.mutedForeground,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            tabs: const [
              Tab(text: 'Gestión de Boletas'),
              Tab(text: 'Fotos de Licencias'),
              Tab(text: 'Gestión de Inspectores'),
              Tab(text: 'Reportes y Análisis'),
            ],
          ),
        ),
        
        // Tab Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBoletasTab(),
                _buildFotosTab(),
                _buildInspectoresTab(),
                _buildReportesTab(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBoletasTab() {
    return Column(
      children: [
        // Filtros y acciones
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryRed.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Buscador
                  Expanded(
                    flex: 3,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar por placa, empresa, conductor...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppTheme.mutedGray.withOpacity(0.3),
                      ),
                      onChanged: (value) => setState(() => _searchTerm = value),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Filtro Inspector
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _selectedInspector,
                      decoration: InputDecoration(
                        labelText: 'Inspector',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppTheme.mutedGray.withOpacity(0.3),
                      ),
                      items: [
                        const DropdownMenuItem(value: 'all', child: Text('Todos')),
                        ..._inspectores.map((inspector) =>
                          DropdownMenuItem(
                            value: inspector['codigo'],
                            child: Text(inspector['nombre']),
                          ),
                        ),
                      ],
                      onChanged: (value) => setState(() => _selectedInspector = value!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Filtro Estado
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: InputDecoration(
                        labelText: 'Estado',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppTheme.mutedGray.withOpacity(0.3),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('Todos')),
                        DropdownMenuItem(value: 'Activa', child: Text('Activa')),
                        DropdownMenuItem(value: 'Pagada', child: Text('Pagada')),
                        DropdownMenuItem(value: 'Anulada', child: Text('Anulada')),
                      ],
                      onChanged: (value) => setState(() => _selectedStatus = value!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Botón Nueva Boleta
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Nueva Boleta'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Lista de boletas
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryRed.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              itemCount: _filteredBoletas.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => _buildBoletaCard(_filteredBoletas[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBoletaCard(BoletaModel boleta) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.mutedGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primaryRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.description,
                  color: AppTheme.primaryRed,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Placa: ${boleta.placa}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      boleta.empresa,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Badges
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getConformeColor(boleta.conforme),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getConformeIcon(boleta.conforme),
                      size: 14,
                      color: _getConformeTextColor(boleta.conforme),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      boleta.conforme,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getConformeTextColor(boleta.conforme),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getEstadoColor(boleta.estado),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  boleta.estado,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getEstadoTextColor(boleta.estado),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              // Acciones
              const SizedBox(width: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Detalles
          LayoutBuilder(
            builder: (context, constraints) {
              int columns = constraints.maxWidth > 800 ? 5 : constraints.maxWidth > 500 ? 3 : 2;
              
              return Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildDetailItem('Conductor:', boleta.conductor, flex: 2),
                  _buildDetailItem('Licencia:', boleta.numeroLicencia),
                  _buildDetailItem('Inspector:', boleta.fiscalizador),
                  _buildDetailItem('Fecha:', 
                    '${boleta.fecha.day.toString().padLeft(2, '0')}/${boleta.fecha.month.toString().padLeft(2, '0')} ${boleta.fecha.hour.toString().padLeft(2, '0')}:${boleta.fecha.minute.toString().padLeft(2, '0')}'
                  ),
                  _buildDetailItem('Multa:', 
                    (boleta.multa != null && boleta.multa! > 0) 
                      ? 'S/ ${boleta.multa!.toStringAsFixed(2)}' 
                      : 'Sin multa',
                    textColor: (boleta.multa != null && boleta.multa! > 0) 
                      ? Colors.red 
                      : Colors.green,
                  ),
                ],
              );
            },
          ),
          
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          
          // Motivo y foto
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Motivo:',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.mutedForeground,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                boleta.motivo,
                style: const TextStyle(fontSize: 12),
              ),
              
              if (boleta.fotoLicencia != null && boleta.fotoLicencia!.isNotEmpty) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _showPhotoViewer(boleta),
                  icon: const Icon(Icons.camera_alt, size: 14),
                  label: const Text('Ver Foto de Licencia'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {int flex = 1, Color? textColor}) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.mutedForeground,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFotosTab() {
    return Column(
      children: [
        // Header y filtros para fotos
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryRed.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.camera_alt, color: AppTheme.primaryRed),
                  const SizedBox(width: 8),
                  const Text(
                    'Galería de Fotos de Licencias',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryGray.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_filteredPhotos.length} fotos',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondaryGray,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  // Buscador para fotos
                  Expanded(
                    flex: 3,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar por placa, conductor, empresa...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppTheme.mutedGray.withOpacity(0.3),
                      ),
                      onChanged: (value) => setState(() => _photoSearchTerm = value),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Filtro Inspector para fotos
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _photoFilterInspector,
                      decoration: InputDecoration(
                        labelText: 'Inspector',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppTheme.mutedGray.withOpacity(0.3),
                      ),
                      items: [
                        const DropdownMenuItem(value: 'all', child: Text('Todos')),
                        ..._inspectores.map((inspector) =>
                          DropdownMenuItem(
                            value: inspector['codigo'],
                            child: Text(inspector['nombre']),
                          ),
                        ),
                      ],
                      onChanged: (value) => setState(() => _photoFilterInspector = value!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Filtro Conformidad para fotos
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _photoFilterConforme,
                      decoration: InputDecoration(
                        labelText: 'Conformidad',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppTheme.mutedGray.withOpacity(0.3),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('Todas')),
                        DropdownMenuItem(value: 'Sí', child: Text('Conforme')),
                        DropdownMenuItem(value: 'No', child: Text('No Conforme')),
                        DropdownMenuItem(value: 'Parcialmente', child: Text('Parcialmente')),
                      ],
                      onChanged: (value) => setState(() => _photoFilterConforme = value!),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Galería de fotos
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryRed.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _filteredPhotos.isNotEmpty
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 1200 ? 4 
                                          : constraints.maxWidth > 800 ? 3 
                                          : constraints.maxWidth > 500 ? 2 
                                          : 1;
                      
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: _filteredPhotos.length,
                        itemBuilder: (context, index) => _buildPhotoCard(_filteredPhotos[index]),
                      );
                    },
                  )
                : _buildEmptyPhotosState(),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoCard(BoletaModel boleta) {
    return GestureDetector(
      onTap: () => _showPhotoViewer(boleta),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.grey[200],
                      child: Image.network(
                        boleta.fotoLicencia!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.image_not_supported, size: 48),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  // Badges superpuestos
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: _getConformeColor(boleta.conforme),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getConformeIcon(boleta.conforme),
                            size: 12,
                            color: _getConformeTextColor(boleta.conforme),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            boleta.conforme,
                            style: TextStyle(
                              fontSize: 10,
                              color: _getConformeTextColor(boleta.conforme),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: _getEstadoColor(boleta.estado),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        boleta.estado,
                        style: TextStyle(
                          fontSize: 10,
                          color: _getEstadoTextColor(boleta.estado),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  // Overlay de hover
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.center,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.zoom_in,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Información
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      boleta.conductor,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    Expanded(
                      child: Column(
                        children: [
                          _buildPhotoDetailRow('Placa:', boleta.placa),
                          _buildPhotoDetailRow('Licencia:', boleta.numeroLicencia),
                          _buildPhotoDetailRow('Inspector:', boleta.fiscalizador),
                          _buildPhotoDetailRow('Fecha:', 
                            '${boleta.fecha.day.toString().padLeft(2, '0')}/${boleta.fecha.month.toString().padLeft(2, '0')}/${boleta.fecha.year.toString().substring(2)}'
                          ),
                          _buildPhotoDetailRow('Empresa:', boleta.empresa, maxLines: 1),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _showPhotoViewer(boleta),
                        icon: const Icon(Icons.visibility, size: 14),
                        label: const Text('Ver Detalles'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoDetailRow(String label, String value, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.mutedForeground,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPhotosState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt,
            size: 64,
            color: AppTheme.mutedForeground,
          ),
          const SizedBox(height: 16),
          Text(
            'No se encontraron fotos',
            style: TextStyle(
              color: AppTheme.mutedForeground,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No hay fotos de licencias que coincidan con los filtros seleccionados',
            style: TextStyle(
              color: AppTheme.mutedForeground,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInspectoresTab() {
    return Column(
      children: [
        // Header con botón
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryRed.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.people, color: AppTheme.primaryRed),
              const SizedBox(width: 8),
              const Text(
                'Gestión de Inspectores',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Nuevo Inspector'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Grid de inspectores
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 900 ? 3 
                                  : constraints.maxWidth > 600 ? 2 
                                  : 1;
              
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.1,
                ),
                itemCount: _inspectores.length,
                itemBuilder: (context, index) => _buildInspectorCard(_inspectores[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInspectorCard(Map<String, dynamic> inspector) {
    final double conformidad = inspector['boletas'] > 0 
        ? (inspector['conformes'] / inspector['boletas']) * 100 
        : 0;
        
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.mutedGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header con avatar y estado
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.primaryRed,
                child: Text(
                  inspector['nombre'].split(' ').map((n) => n[0]).take(2).join(''),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inspector['nombre'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      inspector['codigo'],
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: inspector['estado'] == 'Activo' 
                      ? const Color(0xFFDCFCE7) 
                      : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  inspector['estado'],
                  style: TextStyle(
                    fontSize: 12,
                    color: inspector['estado'] == 'Activo' 
                        ? const Color(0xFF166534) 
                        : const Color(0xFF991B1B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Detalles del inspector
          Expanded(
            child: Column(
              children: [
                _buildInspectorDetail('Email:', inspector['email']),
                _buildInspectorDetail('Teléfono:', inspector['telefono']),
                _buildInspectorDetail('Boletas:', inspector['boletas'].toString()),
                _buildInspectorDetail('Conformes:', inspector['conformes'].toString(), 
                  textColor: Colors.green),
                _buildInspectorDetail('No Conformes:', inspector['noConformes'].toString(),
                  textColor: Colors.red),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Barra de progreso de conformidad
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tasa de Conformidad',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.mutedForeground,
                    ),
                  ),
                  Text(
                    '${conformidad.round()}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: conformidad / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  conformidad >= 80 ? Colors.green : 
                  conformidad >= 60 ? Colors.orange : Colors.red,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Acciones
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInspectorDetail(String label, String value, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.mutedForeground,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportesTab() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 800;
        
        return SingleChildScrollView(
          child: Column(
            children: [
              // Gráficos en grid
              isWide ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildConformidadChart()),
                  const SizedBox(width: 24),
                  Expanded(child: _buildMultasStats()),
                ],
              ) : Column(
                children: [
                  _buildConformidadChart(),
                  const SizedBox(height: 24),
                  _buildMultasStats(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConformidadChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bar_chart, color: AppTheme.primaryRed),
              SizedBox(width: 8),
              Text(
                'Distribución de Conformidad',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Barras de conformidad
          _buildConformidadBar('Conforme', _totalConformes, const Color(0xFF10B981)),
          const SizedBox(height: 16),
          _buildConformidadBar('No Conforme', _totalNoConformes, const Color(0xFFEF4444)),
          const SizedBox(height: 16),
          _buildConformidadBar('Parcialmente', _totalParciales, const Color(0xFFF59E0B)),
        ],
      ),
    );
  }

  Widget _buildConformidadBar(String label, int value, Color color) {
    double percentage = _totalBoletas > 0 ? (value / _totalBoletas) * 100 : 0;
    
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Text(
              '$value (${percentage.round()}%)',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildMultasStats() {
    final multasActivas = _boletas.where((b) => b.estado == 'Activa' && (b.multa ?? 0) > 0).length;
    final multasPagadas = _boletas.where((b) => b.estado == 'Pagada' && (b.multa ?? 0) > 0).length;
    final multasConMulta = _boletas.where((b) => (b.multa ?? 0) > 0).length;
    final promedioMulta = multasConMulta > 0 ? _totalMultas / multasConMulta : 0;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.trending_up, color: AppTheme.primaryRed),
              SizedBox(width: 8),
              Text(
                'Estadísticas de Multas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildMultaStat(
            'Total Recaudado', 
            'S/ ${_totalMultas.toStringAsFixed(2)}', 
            const Color(0xFFFEE2E2),
            const Color(0xFF991B1B),
          ),
          const SizedBox(height: 16),
          _buildMultaStat(
            'Multas Activas', 
            multasActivas.toString(), 
            const Color(0xFFDBEAFE),
            const Color(0xFF1E40AF),
          ),
          const SizedBox(height: 16),
          _buildMultaStat(
            'Multas Pagadas', 
            multasPagadas.toString(), 
            const Color(0xFFDCFCE7),
            const Color(0xFF166534),
          ),
          const SizedBox(height: 16),
          _buildMultaStat(
            'Promedio por Multa', 
            'S/ ${promedioMulta.toStringAsFixed(2)}', 
            const Color(0xFFFFFBEB),
            const Color(0xFF92400E),
          ),
        ],
      ),
    );
  }

  Widget _buildMultaStat(String label, String value, Color backgroundColor, Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showPhotoViewer(BoletaModel boleta) {
    setState(() {
      _selectedPhoto = boleta;
      _isPhotoViewerOpen = true;
    });
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _buildPhotoViewerDialog(),
    );
  }

  Widget _buildPhotoViewerDialog() {
    if (_selectedPhoto == null) return const SizedBox();
    
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            // Header del modal
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  const Icon(Icons.camera_alt, color: AppTheme.primaryRed),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Licencia de Conducir - ${_selectedPhoto!.conductor}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // Contenido del modal
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Imagen principal
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              _selectedPhoto!.fotoLicencia!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.image_not_supported, size: 48),
                                );
                              },
                            ),
                          ),
                          
                          // Badges superpuestos
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getConformeColor(_selectedPhoto!.conforme),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _getConformeIcon(_selectedPhoto!.conforme),
                                        size: 16,
                                        color: _getConformeTextColor(_selectedPhoto!.conforme),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _selectedPhoto!.conforme,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _getConformeTextColor(_selectedPhoto!.conforme),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getEstadoColor(_selectedPhoto!.estado),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _selectedPhoto!.estado,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _getEstadoTextColor(_selectedPhoto!.estado),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Información detallada
                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool isWide = constraints.maxWidth > 600;
                        
                        return isWide ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildConductorInfo()),
                            const SizedBox(width: 24),
                            Expanded(child: _buildFiscalizacionInfo()),
                          ],
                        ) : Column(
                          children: [
                            _buildConductorInfo(),
                            const SizedBox(height: 24),
                            _buildFiscalizacionInfo(),
                          ],
                        );
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Motivo y observaciones
                    _buildMotivoYObservaciones(),
                    
                    const SizedBox(height: 24),
                    
                    // Acciones
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download, size: 16),
                          label: const Text('Descargar Foto'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cerrar'),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConductorInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info, size: 16),
              SizedBox(width: 4),
              Text(
                'Información del Conductor',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Nombre Completo', _selectedPhoto!.conductor),
          _buildDetailRow('Número de Licencia', _selectedPhoto!.numeroLicencia),
          _buildDetailRow('Empresa', _selectedPhoto!.empresa),
          _buildDetailRow('Placa del Vehículo', _selectedPhoto!.placa),
        ],
      ),
    );
  }

  Widget _buildFiscalizacionInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.description, size: 16),
              SizedBox(width: 4),
              Text(
                'Información de la Fiscalización',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Inspector', _selectedPhoto!.fiscalizador),
          _buildDetailRow('Fecha y Hora', 
            '${_selectedPhoto!.fecha.day.toString().padLeft(2, '0')}/${_selectedPhoto!.fecha.month.toString().padLeft(2, '0')}/${_selectedPhoto!.fecha.year} ${_selectedPhoto!.fecha.hour.toString().padLeft(2, '0')}:${_selectedPhoto!.fecha.minute.toString().padLeft(2, '0')}'
          ),
          _buildDetailRowWithWidget('Estado de la Boleta', 
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getEstadoColor(_selectedPhoto!.estado),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _selectedPhoto!.estado,
                style: TextStyle(
                  fontSize: 12,
                  color: _getEstadoTextColor(_selectedPhoto!.estado),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          _buildDetailRowWithWidget('Conformidad',
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getConformeColor(_selectedPhoto!.conforme),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getConformeIcon(_selectedPhoto!.conforme),
                    size: 16,
                    color: _getConformeTextColor(_selectedPhoto!.conforme),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _selectedPhoto!.conforme,
                    style: TextStyle(
                      fontSize: 12,
                      color: _getConformeTextColor(_selectedPhoto!.conforme),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_selectedPhoto!.multa != null && _selectedPhoto!.multa! > 0)
            _buildDetailRow('Monto de Multa', 
              'S/ ${_selectedPhoto!.multa!.toStringAsFixed(2)}',
              textColor: Colors.red,
            ),
        ],
      ),
    );
  }

  Widget _buildMotivoYObservaciones() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.mutedGray.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Motivo de la Fiscalización',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.mutedForeground,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _selectedPhoto!.motivo,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        
        if (_selectedPhoto!.descripciones?.isNotEmpty == true) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Descripciones',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.mutedForeground,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedPhoto!.descripciones!,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
        
        if (_selectedPhoto!.observaciones?.isNotEmpty == true) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Observaciones',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.mutedForeground,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedPhoto!.observaciones!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF991B1B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.mutedForeground,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithWidget(String label, Widget widget) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.mutedForeground,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          widget,
        ],
      ),
    );
  }
}