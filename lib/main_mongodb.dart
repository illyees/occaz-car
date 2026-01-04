import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'services/mongodb_auth_service.dart';
import 'services/mongodb_database_service.dart';
import 'services/mongodb_storage_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';

/// Version MongoDB de l'application - Utilise MongoDB au lieu de Firebase
/// 
/// ⚠️ IMPORTANT : MongoDB ne fonctionne PAS sur le web (Chrome)
/// Utilisez Android, iOS, ou Windows Desktop pour tester MongoDB
/// 
/// Pour le web, utilisez : flutter run -t lib/main_demo.dart -d chrome
/// 
/// Pour lancer avec MongoDB :
/// flutter run -t lib/main_mongodb.dart -d android
/// flutter run -t lib/main_mongodb.dart -d ios
/// flutter run -t lib/main_mongodb.dart -d windows
void main() {
  // Vérifier si on est sur le web
  if (kIsWeb) {
    runApp(const _WebWarningApp());
  } else {
    runApp(const MyAppMongoDB());
  }
}

/// Application d'avertissement pour le web
class _WebWarningApp extends StatelessWidget {
  const _WebWarningApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OccazCar - Avertissement',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 80,
                  color: Colors.orange,
                ),
                const SizedBox(height: 24),
                const Text(
                  'MongoDB ne fonctionne pas sur le Web',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Le package mongo_dart utilise des opérations système qui ne sont pas disponibles dans le navigateur.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Solutions :',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '1. Utilisez le mode démo pour le web :\n'
                  '   flutter run -t lib/main_demo.dart -d chrome\n\n'
                  '2. Testez MongoDB sur Android/iOS :\n'
                  '   flutter run -t lib/main_mongodb.dart -d android',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // Rediriger vers le mode démo
                    // Note: Cela nécessiterait de relancer l'app, donc on affiche juste le message
                  },
                  child: const Text('Utiliser le Mode Démo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyAppMongoDB extends StatelessWidget {
  const MyAppMongoDB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Utiliser MongoDBAuthService au lieu de AuthService
        ChangeNotifierProvider(create: (_) => MongoDBAuthService()),
        // Fournir les services MongoDB pour les écrans
        Provider(create: (_) => MongoDBDatabaseService()),
        Provider(create: (_) => MongoDBStorageService()),
      ],
      child: MaterialApp(
        title: 'OccazCar (MongoDB)',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapperMongoDB(),
      ),
    );
  }
}

class AuthWrapperMongoDB extends StatelessWidget {
  const AuthWrapperMongoDB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<MongoDBAuthService>(context);

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomeScreen();
        }

        return const ModernLoginScreen();
      },
    );
  }
}

