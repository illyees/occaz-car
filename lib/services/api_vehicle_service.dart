import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/demo_vehicle.dart';
import 'api_auth_service.dart';

class ApiVehicleService {
  static const String baseUrl = 'http://localhost:3000/api';
  
  final ApiAuthService _authService = ApiAuthService();
  
  /// Créer une nouvelle annonce de véhicule
  Future<Map<String, dynamic>> createVehicle({
    required String marque,
    required String modele,
    required int annee,
    required double prix,
    required int kilometrage,
    required String carburant,
    required String boite,
    required String ville,
    String? description,
    List<String>? images,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/vehicles'),
        headers: _authService.getAuthHeaders(),
        body: jsonEncode({
          'marque': marque,
          'modele': modele,
          'annee': annee,
          'prix': prix,
          'kilometrage': kilometrage,
          'carburant': carburant,
          'boite': boite,
          'ville': ville,
          'description': description,
          'images': images,
          'latitude': latitude,
          'longitude': longitude,
        }),
      );
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'],
          'vehicleId': data['vehicleId'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Erreur lors de la création de l\'annonce',
        };
      }
    } catch (e) {
      print('Erreur lors de la création du véhicule: $e');
      return {
        'success': false,
        'message': 'Impossible de se connecter au serveur',
      };
    }
  }
  
  /// Récupérer tous les véhicules avec filtres optionnels
  Future<List<DemoVehicle>> getVehicles({
    String? ville,
    String? marque,
    double? minPrix,
    double? maxPrix,
    String? carburant,
    String? boite,
  }) async {
    try {
      // Construire les paramètres de requête
      final queryParams = <String, String>{};
      if (ville != null) queryParams['ville'] = ville;
      if (marque != null) queryParams['marque'] = marque;
      if (minPrix != null) queryParams['minPrix'] = minPrix.toString();
      if (maxPrix != null) queryParams['maxPrix'] = maxPrix.toString();
      if (carburant != null) queryParams['carburant'] = carburant;
      if (boite != null) queryParams['boite'] = boite;
      
      final uri = Uri.parse('$baseUrl/vehicles').replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> vehiclesJson = data['vehicles'];
        return vehiclesJson.map((json) => DemoVehicle.fromJson(json)).toList();
      } else {
        print('Erreur lors de la récupération des véhicules: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erreur lors de la récupération des véhicules: $e');
      return [];
    }
  }
  
  /// Récupérer un véhicule par son ID
  Future<DemoVehicle?> getVehicleById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/vehicles/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DemoVehicle.fromJson(data['vehicle']);
      } else {
        print('Véhicule non trouvé');
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération du véhicule: $e');
      return null;
    }
  }
  
  /// Récupérer les véhicules de l'utilisateur connecté
  Future<List<DemoVehicle>> getMyVehicles() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/vehicles/user/me'),
        headers: _authService.getAuthHeaders(),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> vehiclesJson = data['vehicles'];
        return vehiclesJson.map((json) => DemoVehicle.fromJson(json)).toList();
      } else {
        print('Erreur lors de la récupération des véhicules: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erreur lors de la récupération des véhicules: $e');
      return [];
    }
  }
  
  /// Mettre à jour un véhicule
  Future<Map<String, dynamic>> updateVehicle({
    required int id,
    required String marque,
    required String modele,
    required int annee,
    required double prix,
    required int kilometrage,
    required String carburant,
    required String boite,
    required String ville,
    String? description,
    List<String>? images,
    String? status,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/vehicles/$id'),
        headers: _authService.getAuthHeaders(),
        body: jsonEncode({
          'marque': marque,
          'modele': modele,
          'annee': annee,
          'prix': prix,
          'kilometrage': kilometrage,
          'carburant': carburant,
          'boite': boite,
          'ville': ville,
          'description': description,
          'images': images,
          'status': status,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Erreur lors de la mise à jour',
        };
      }
    } catch (e) {
      print('Erreur lors de la mise à jour du véhicule: $e');
      return {
        'success': false,
        'message': 'Impossible de se connecter au serveur',
      };
    }
  }
  
  /// Supprimer un véhicule
  Future<Map<String, dynamic>> deleteVehicle(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/vehicles/$id'),
        headers: _authService.getAuthHeaders(),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Erreur lors de la suppression',
        };
      }
    } catch (e) {
      print('Erreur lors de la suppression du véhicule: $e');
      return {
        'success': false,
        'message': 'Impossible de se connecter au serveur',
      };
    }
  }
}
