import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'mock_service.dart';

/// Service d'authentification mock pour tester sans Firebase
class MockAuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoggedIn = false;

  UserModel? get currentUser => _currentUser;
  
  // Stream mocké pour simuler les changements d'état
  Stream<UserModel?> get authStateChanges {
    // Retourner un stream qui émet la valeur actuelle
    return Stream.value(_currentUser);
  }

  Future<String?> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required bool isSeller,
  }) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = UserModel(
      id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
      phone: phone,
      isSeller: isSeller,
      createdAt: DateTime.now(),
    );
    
    _isLoggedIn = true;
    notifyListeners();
    return null; // Pas d'erreur
  }

  Future<String?> login(String email, String password) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(seconds: 1));
    
    // Pour la démo, accepter n'importe quel email/mot de passe
    // ou utiliser des comptes prédéfinis
    if (email.contains('vendeur') || email.contains('seller')) {
      _currentUser = MockService.getMockUser(isSeller: true);
    } else {
      _currentUser = MockService.getMockUser(isSeller: false);
    }
    
    _isLoggedIn = true;
    notifyListeners();
    return null; // Pas d'erreur
  }

  Future<void> logout() async {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<UserModel?> getUserData(String uid) async {
    // Retourner immédiatement l'utilisateur actuel (pas de délai)
    return _currentUser;
  }
  
  // Méthode synchrone pour obtenir l'utilisateur directement
  UserModel? getUserDataSync() {
    return _currentUser;
  }
}






