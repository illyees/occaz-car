import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../config/mongodb_config.dart';
import '../models/user_model.dart';

/// Service d'authentification MongoDB pour remplacer Firebase Auth
class MongoDBAuthService extends ChangeNotifier {
  Db? _db;
  bool _isConnected = false;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  
  Stream<UserModel?> get authStateChanges {
    return Stream.value(_currentUser);
  }

  /// Se connecter à MongoDB
  Future<void> _ensureConnected() async {
    if (_isConnected && _db != null) return;

    try {
      _db = await Db.create(MongoDBConfig.connectionString);
      await _db!.open();
      _isConnected = true;
    } catch (e) {
      throw Exception('Erreur de connexion MongoDB: $e');
    }
  }

  /// Hasher un mot de passe
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Inscription
  Future<String?> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required bool isSeller,
  }) async {
    try {
      await _ensureConnected();
      final collection = _db!.collection(MongoDBConfig.usersCollection);

      // Vérifier si l'email existe déjà
      final existingUser = await collection.findOne(where.eq('email', email));
      if (existingUser != null) {
        return 'Cet email est déjà utilisé';
      }

      // Créer le nouvel utilisateur
      final userId = ObjectId();
      final userJson = {
        '_id': userId,
        'email': email,
        'password': _hashPassword(password), // Hash du mot de passe
        'name': name,
        'phone': phone,
        'isSeller': isSeller,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await collection.insert(userJson);

      // Connecter automatiquement l'utilisateur
      _currentUser = UserModel(
        id: userId.toString(),
        email: email,
        name: name,
        phone: phone,
        isSeller: isSeller,
        createdAt: DateTime.now(),
      );

      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Connexion
  Future<String?> login(String email, String password) async {
    try {
      await _ensureConnected();
      final collection = _db!.collection(MongoDBConfig.usersCollection);

      // Chercher l'utilisateur
      final userDoc = await collection.findOne(where.eq('email', email));
      if (userDoc == null) {
        return 'Email ou mot de passe incorrect';
      }

      // Vérifier le mot de passe
      final hashedPassword = _hashPassword(password);
      if (userDoc['password'] != hashedPassword) {
        return 'Email ou mot de passe incorrect';
      }

      // Créer l'objet UserModel
      _currentUser = UserModel(
        id: userDoc['_id'].toString(),
        email: userDoc['email'] ?? '',
        name: userDoc['name'] ?? '',
        phone: userDoc['phone'] ?? '',
        isSeller: userDoc['isSeller'] ?? false,
        createdAt: userDoc['createdAt'] != null
            ? DateTime.parse(userDoc['createdAt'])
            : DateTime.now(),
      );

      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  /// Obtenir les données d'un utilisateur
  Future<UserModel?> getUserData(String uid) async {
    try {
      await _ensureConnected();
      final collection = _db!.collection(MongoDBConfig.usersCollection);

      final userDoc = await collection.findOne(where.id(ObjectId.fromHexString(uid)));
      if (userDoc == null) {
        return null;
      }

      return UserModel(
        id: userDoc['_id'].toString(),
        email: userDoc['email'] ?? '',
        name: userDoc['name'] ?? '',
        phone: userDoc['phone'] ?? '',
        isSeller: userDoc['isSeller'] ?? false,
        createdAt: userDoc['createdAt'] != null
            ? DateTime.parse(userDoc['createdAt'])
            : DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Fermer la connexion
  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _isConnected = false;
    }
  }
}



