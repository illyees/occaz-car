import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/mock_auth_service.dart';
import 'services/mock_database_service.dart';
import 'services/mock_storage_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';
import 'utils/demo_helper.dart';

/// Version DEMO de l'application - Utilise des données mockées au lieu de Firebase
/// Pour tester l'application sans configurer Firebase
///
/// Pour lancer en mode démo :
/// flutter run -t lib/main_demo.dart
void main() async {
  DemoHelper.enableDemoMode(); // Activer le mode démo
  WidgetsFlutterBinding.ensureInitialized();

  // Créer et connecter automatiquement un utilisateur mocké
  final mockAuth = MockAuthService();
  await mockAuth.login('demo@occazcar.com', 'demo123');

  runApp(MyAppDemo(mockAuth: mockAuth));
}

class MyAppDemo extends StatelessWidget {
  final MockAuthService? mockAuth;

  const MyAppDemo({Key? key, this.mockAuth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Utiliser MockAuthService au lieu de AuthService
        ChangeNotifierProvider(create: (_) => mockAuth ?? MockAuthService()),
        // Fournir les services mock pour les écrans
        Provider(create: (_) => MockDatabaseService()),
        Provider(create: (_) => MockStorageService()),
      ],
      child: MaterialApp(
        title: 'OccazCar (Mode Démo)',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapperDemo(),
      ),
    );
  }
}

class AuthWrapperDemo extends StatefulWidget {
  const AuthWrapperDemo({Key? key}) : super(key: key);

  @override
  State<AuthWrapperDemo> createState() => _AuthWrapperDemoState();
}

class _AuthWrapperDemoState extends State<AuthWrapperDemo> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<MockAuthService>(context);

    // En mode démo, aller directement à HomeScreen si connecté
    // Sinon afficher l'écran de login
    if (authService.currentUser != null) {
      return const HomeScreen();
    }

    // Si pas connecté, afficher l'écran de login directement
    return const ModernLoginScreen();
  }
}
