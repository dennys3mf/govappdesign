import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;
  final String? userName;

  const HomeScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
    this.userName,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _cardAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _cardAnimations = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.2,
            0.6 + (index * 0.2),
            curve: Curves.easeOutBack,
          ),
        ),
      );
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
                    // Logo y título
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'La Joya Avanza',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppTheme.primaryRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Bienvenido, ${widget.userName ?? 'Inspector'}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Botón de logout
                    IconButton(
                      onPressed: widget.onLogout,
                      icon: const Icon(Icons.logout),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Tarjetas de acción principales
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Nueva Fiscalización
                      AnimatedBuilder(
                        animation: _cardAnimations[0],
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _cardAnimations[0].value,
                            child: _buildActionCard(
                              title: 'Nueva Fiscalización',
                              subtitle: 'Crear una nueva boleta de fiscalización',
                              icon: Icons.assignment_add,
                              gradient: const LinearGradient(
                                colors: [AppTheme.primaryRed, AppTheme.accentRed],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              onTap: () => widget.onNavigate('inspection'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Configurar Impresora
                      AnimatedBuilder(
                        animation: _cardAnimations[1],
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _cardAnimations[1].value,
                            child: _buildActionCard(
                              title: 'Configurar Impresora',
                              subtitle: 'Gestionar impresoras Bluetooth',
                              icon: Icons.print,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              onTap: () => widget.onNavigate('printer'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Historial de Boletas
                      AnimatedBuilder(
                        animation: _cardAnimations[2],
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _cardAnimations[2].value,
                            child: _buildActionCard(
                              title: 'Historial de Boletas',
                              subtitle: 'Ver boletas emitidas anteriormente',
                              icon: Icons.history,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF059669), Color(0xFF10B981)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              onTap: () => widget.onNavigate('history'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Footer con información
              Container(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Sistema de Fiscalización de Transporte\nMunicipalidad Distrital de La Joya',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.mutedForeground,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}