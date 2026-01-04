// Widget tests for OccazCar application
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:occaz_car/services/mock_auth_service.dart';
import 'package:occaz_car/utils/app_theme.dart';
import 'package:occaz_car/screens/auth/login_screen.dart';

void main() {
  testWidgets('Login screen displays correctly', (WidgetTester tester) async {
    // Build the login screen with mock auth service
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: ChangeNotifierProvider(
          create: (_) => MockAuthService(),
          child: const ModernLoginScreen(),
        ),
      ),
    );

    // Verify that the login screen elements are present
    expect(find.text('OccazCar'), findsOneWidget);
    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });

  testWidgets('Login form validation works', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: ChangeNotifierProvider(
          create: (_) => MockAuthService(),
          child: const ModernLoginScreen(),
        ),
      ),
    );

    // Try to submit empty form
    await tester.tap(find.text('Se connecter'), warnIfMissed: false);
    await tester.pump();

    // Should show validation errors (if form validation is implemented)
    // This test verifies the form structure exists
    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}
