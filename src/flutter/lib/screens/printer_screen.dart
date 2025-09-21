import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class PrinterScreen extends StatefulWidget {
  final VoidCallback onBack;

  const PrinterScreen({super.key, required this.onBack});

  @override
  State<PrinterScreen> createState() => _PrinterScreenState();
}

class _PrinterScreenState extends State<PrinterScreen>
    with TickerProviderStateMixin {
  List<Map<String, String>> _availablePrinters = [];
  String? _selectedPrinterId;
  bool _isScanning = false;
  bool _isConnecting = false;
  late AnimationController _scanAnimationController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _scanAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanAnimationController, curve: Curves.easeInOut),
    );
    _loadSavedPrinter();
    _loadMockPrinters();
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPrinterId = prefs.getString('selected_printer_id');
    if (savedPrinterId != null) {
      setState(() {
        _selectedPrinterId = savedPrinterId;
      });
    }
  }

  Future<void> _savePrinter(String printerId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_printer_id', printerId);
  }

  void _loadMockPrinters() {
    // Simular impresoras disponibles
    setState(() {
      _availablePrinters = [
        {
          'id': 'bt_printer_001',
          'name': 'EPSON TM-P20',
          'type': 'Bluetooth',
          'status': 'Disponible',
          'address': '00:11:22:33:44:55',
        },
        {
          'id': 'bt_printer_002',
          'name': 'Star TSP143IIIU',
          'type': 'Bluetooth',
          'status': 'Disponible',
          'address': '66:77:88:99:AA:BB',
        },
        {
          'id': 'wifi_printer_001',
          'name': 'Canon PIXMA TS3340',
          'type': 'WiFi',
          'status': 'Conectada',
          'address': '192.168.1.100',
        },
        {
          'id': 'wifi_printer_002',
          'name': 'HP DeskJet 2720',
          'type': 'WiFi',
          'status': 'Sin conexión',
          'address': '192.168.1.101',
        },
      ];
    });
  }

  Future<void> _scanForPrinters() async {
    setState(() {
      _isScanning = true;
    });

    _scanAnimationController.repeat();

    // Simular búsqueda de impresoras
    await Future.delayed(const Duration(seconds: 3));

    // Agregar una nueva impresora simulada
    setState(() {
      _availablePrinters.add({
        'id': 'bt_printer_new',
        'name': 'Zebra ZD220',
        'type': 'Bluetooth',
        'status': 'Disponible',
        'address': 'CC:DD:EE:FF:00:11',
      });
    });

    _scanAnimationController.stop();
    _scanAnimationController.reset();

    setState(() {
      _isScanning = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Búsqueda completada'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _connectToPrinter(String printerId) async {
    setState(() {
      _isConnecting = true;
    });

    // Simular conexión
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _selectedPrinterId = printerId;
      _isConnecting = false;
    });

    await _savePrinter(printerId);

    final printer = _availablePrinters.firstWhere((p) => p['id'] == printerId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conectado a ${printer['name']}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildPrinterCard(Map<String, String> printer) {
    final isSelected = printer['id'] == _selectedPrinterId;
    final isAvailable = printer['status'] == 'Disponible' || printer['status'] == 'Conectada';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 8 : 4,
      shadowColor: isSelected ? AppTheme.primaryRed.withOpacity(0.3) : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: isSelected 
              ? Border.all(color: AppTheme.primaryRed, width: 2)
              : null,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppTheme.primaryRed.withOpacity(0.1)
                  : AppTheme.mutedGray.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              printer['type'] == 'Bluetooth' ? Icons.bluetooth : Icons.wifi,
              color: isSelected ? AppTheme.primaryRed : AppTheme.mutedForeground,
              size: 24,
            ),
          ),
          title: Text(
            printer['name']!,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? AppTheme.primaryRed : AppTheme.foregroundDark,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                '${printer['type']} • ${printer['address']}',
                style: const TextStyle(
                  color: AppTheme.mutedForeground,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor(printer['status']!).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  printer['status']!,
                  style: TextStyle(
                    color: _getStatusColor(printer['status']!),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          trailing: isSelected
              ? const Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryRed,
                  size: 28,
                )
              : isAvailable
                  ? IconButton(
                      onPressed: _isConnecting 
                          ? null 
                          : () => _connectToPrinter(printer['id']!),
                      icon: _isConnecting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: AppTheme.primaryRed,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.link, color: AppTheme.primaryRed),
                    )
                  : const Icon(
                      Icons.error_outline,
                      color: Colors.orange,
                    ),
          onTap: isAvailable && !_isConnecting
              ? () => _connectToPrinter(printer['id']!)
              : null,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Disponible':
      case 'Conectada':
        return Colors.green;
      case 'Sin conexión':
        return Colors.orange;
      default:
        return AppTheme.mutedForeground;
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
                            'Configurar Impresora',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppTheme.primaryRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Gestiona tus dispositivos de impresión',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Botón de búsqueda
                    ElevatedButton.icon(
                      onPressed: _isScanning ? null : _scanForPrinters,
                      icon: _isScanning
                          ? AnimatedBuilder(
                              animation: _scanAnimation,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _scanAnimation.value * 2 * 3.141592653589793,
                                  child: const Icon(Icons.refresh, size: 18),
                                );
                              },
                            )
                          : const Icon(Icons.search, size: 18),
                      label: Text(_isScanning ? 'Buscando...' : 'Buscar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryRed,
                        side: const BorderSide(color: AppTheme.primaryRed),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Lista de impresoras
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Impresoras Disponibles',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.foregroundDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Expanded(
                        child: _availablePrinters.isEmpty
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.print_disabled,
                                      size: 64,
                                      color: AppTheme.mutedForeground,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No se encontraron impresoras',
                                      style: TextStyle(
                                        color: AppTheme.mutedForeground,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Presiona "Buscar" para encontrar dispositivos',
                                      style: TextStyle(
                                        color: AppTheme.mutedForeground,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: _availablePrinters.length,
                                itemBuilder: (context, index) {
                                  return _buildPrinterCard(_availablePrinters[index]);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // Información adicional
              if (_selectedPrinterId != null)
                Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Impresora Configurada',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              'Las boletas se imprimirán automáticamente',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
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
}