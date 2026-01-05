import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/demo_user.dart';

class ApiAuthService {
  // Configuration de l'API
  static const String baseUrl = 'http://localhost:3000/api';
  
  // Clés pour le stockage local
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  
  // Singleton
  static final ApiAuthService _instance = ApiAuthService._internal();
  factory ApiAuthService() => _instance;
  ApiAuthService._internal();
  
  // Token JWT actuel
  String? _token;
  DemoUser? _currentUser;
  
  // Getters
  String? get token => _token;
  DemoUser? get currentUser => _currentUser;
  bool get isAuthenticated => _token != null && _currentUser != null;
  
  /// Initialiser le service (charger le token et l'utilisateur du stockage local)
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    final userData = prefs.getString(_userKey);
    
    if (userData != null) {
      try {
        _currentUser = DemoUser.fromJson(jsonDecode(userData));
      } catch (e) {
        print('Erreur lors du chargement des données utilisateur: $e');
        await _clearStorage();
      }
    }
    
    // Vérifier que le token est toujours valide
    if (_token != null) {
      try {
        await getProfile();
      } catch (e) {
        print('Token invalide, déconnexion');
        await _clearStorage();
      }
    }
  }
  
  /// Inscription d'un nouvel utilisateur
  Future<Map<String, dynamic>> register({
    required String nom,
    required String email,
    required String password,
    String? telephone,
    String? ville,
    String role = 'both',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nom': nom,
          'email': email,
          'password': password,
          'telephone': telephone,
          'ville': ville,
          'role': role,
        }),
      );
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await _saveAuthData(data['token'], data['user']);
        
        return {
          'success': true,
          'message': data['message'],
          'user': _currentUser,
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Erreur lors de l\'inscription',
        };
      }
    } catch (e) {
      print('Erreur réseau lors de l\'inscription: $e');
      return {
        'success': false,
        'message': 'Impossible de se connecter au serveur',
      };
    }
  }
  
  /// Connexion d'un utilisateur
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveAuthData(data['token'], data['user']);
        
        return {
          'success': true,
          'message': data['message'],
          'user': _currentUser,
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Email ou mot de passe incorrect',
        };
      }
    } catch (e) {
      print('Erreur réseau lors de la connexion: $e');
      return {
        'success': false,
        'message': 'Impossible de se connecter au serveur',
      };
    }
  }
  
  /// Obtenir le profil utilisateur
  Future<DemoUser?> getProfile() async {
    if (_token == null) return null;
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentUser = DemoUser.fromJson(data['user']);
        await _saveUserData(data['user']);
        return _currentUser;
      } else {
        throw Exception('Erreur lors de la récupération du profil');
      }
    } catch (e) {
      print('Erreur lors de la récupération du profil: $e');
      return null;
    }
  }
  
  /// Mettre à jour le profil utilisateur
  Future<Map<String, dynamic>> updateProfile({
    required String nom,
    String? telephone,
    String? ville,
    String? photoUrl,
  }) async {
    if (_token == null) {
      return {
        'success': false,
        'message': 'Non authentifié',
      };
    }
    
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'nom': nom,
          'telephone': telephone,
          'ville': ville,
          'photo_url': photoUrl,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentUser = DemoUser.fromJson(data['user']);
        await _saveUserData(data['user']);
        
        return {
          'success': true,
          'message': data['message'],
          'user': _currentUser,
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Erreur lors de la mise à jour',
        };
      }
    } catch (e) {
      print('Erreur lors de la mise à jour du profil: $e');
      return {
        'success': false,
        'message': 'Impossible de se connecter au serveur',
      };
    }
  }
  
  /// Déconnexion
  Future<void> logout() async {
    await _clearStorage();
  }
  
  /// Sauvegarder les données d'authentification
  Future<void> _saveAuthData(String token, Map<String, dynamic> userData) async {
    _token = token;
    _currentUser = DemoUser.fromJson(userData);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(userData));
  }
  
  /// Sauvegarder les données utilisateur
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(userData));
  }
  
  /// Effacer le stockage local
  Future<void> _clearStorage() async {
    _token = null;
    _currentUser = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
  
  /// Obtenir les en-têtes avec authentification
  Map<String, String> getAuthHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }
}
