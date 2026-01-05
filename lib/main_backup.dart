import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kIsWeb) {
    // Configuration Firebase pour Web
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB8Ndw3kkXV6ip1T7F5ic7OIj5tmqXsHoI",
        authDomain: "occazcar-e7978.firebaseapp.com",
        projectId: "occazcar-e7978",
        storageBucket: "occazcar-e7978.firebasestorage.app",
        messagingSenderId: "794233629740",
        appId: "1:794233629740:web:a66f5c5ffe5ae6b2607589",
      ),
    );
  } else {
    // Configuration pour Android/iOS (utilise google-services.json)
    await Firebase.initializeApp();
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'OccazCar',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

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
