import 'package:flutter/material.dart';
import '../models/user_model.dart';

class MockAuthService extends ChangeNotifier {
  UserModel? _currentUser;
  
  UserModel? get currentUser => _currentUser;
  
  Stream<UserModel?> get authStateChanges async* {
    await Future.delayed(const Duration(milliseconds: 500));
    yield _currentUser;
  }

  Future<String?> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required bool isSeller,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = UserModel(
      id: 'mock-user-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
      phone: phone,
      isSeller: isSeller,
      createdAt: DateTime.now(),
    );
    notifyListeners();
    return null;
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock user pour test
    _currentUser = UserModel(
      id: 'mock-user-123',
      email: email,
      name: 'Utilisateur Test',
      phone: '+216 12 345 678',
      isSeller: true,
      createdAt: DateTime.now(),
    );
    notifyListeners();
    return null;
  }

  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
  }

  Future<String?> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return null;
  }

  Future<String?> updateProfile({
    required String name,
    required String phone,
  }) async {
    if (_currentUser != null) {
      _currentUser = UserModel(
        id: _currentUser!.id,
        email: _currentUser!.email,
        name: name,
        phone: phone,
        isSeller: _currentUser!.isSeller,
        createdAt: _currentUser!.createdAt,
      );
      notifyListeners();
    }
    return null;
  }

  Future<UserModel?> getUserData(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }
}
