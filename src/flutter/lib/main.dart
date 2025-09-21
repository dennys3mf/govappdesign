import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/inspection_form_screen.dart';
import 'screens/printer_screen.dart';
import 'screens/history_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ClarityGovApp());
}

class ClarityGovApp extends StatelessWidget {
  const ClarityGovApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClarityGov - La Joya Avanza',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const AppNavigator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  String _currentScreen = 'login';
  Map<String, String>? _user;

  void _handleLogin() {
    setState(() {
      _user = {'name': 'Inspector Municipal'};
      _currentScreen = 'home';
    });
  }

  void _handleLogout() {
    setState(() {
      _user = null;
      _currentScreen = 'login';
    });
  }

  void _handleNavigate(String screen) {
    setState(() {
      switch (screen) {
        case 'inspection':
          _currentScreen = 'inspection';
          break;
        case 'printer':
          _currentScreen = 'printer';
          break;
        case 'history':
          _currentScreen = 'history';
          break;
        default:
          _currentScreen = 'home';
      }
    });
  }

  void _goBack() {
    setState(() {
      _currentScreen = 'home';
    });
  }

  Widget _renderScreen() {
    switch (_currentScreen) {
      case 'login':
        return LoginScreen(onLogin: _handleLogin);
      case 'home':
        return HomeScreen(
          onNavigate: _handleNavigate,
          onLogout: _handleLogout,
          userName: _user?['name'],
        );
      case 'inspection':
        return InspectionFormScreen(onBack: _goBack);
      case 'printer':
        return PrinterScreen(onBack: _goBack);
      case 'history':
        return HistoryScreen(onBack: _goBack);
      default:
        return LoginScreen(onLogin: _handleLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _renderScreen();
  }
}