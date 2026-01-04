import 'dart:async';
import '../models/vehicle_model.dart';
import 'mock_service.dart';

/// Service de base de données mock pour tester sans Firestore
class MockDatabaseService {
  List<Vehicle> _vehicles = MockService.getMockVehicles();

  Future<String?> addVehicle(Vehicle vehicle) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(seconds: 1));
    
    // Ajouter le véhicule à la liste mockée
    _vehicles.insert(0, vehicle);
    return null; // Pas d'erreur
  }

  Stream<List<Vehicle>> getAllVehicles() {
    // Retourner un stream qui émet la liste des véhicules
    return Stream.value(_vehicles);
  }

  Stream<List<Vehicle>> getVehiclesBySeller(String sellerId) {
    final sellerVehicles = _vehicles.where((v) => v.sellerId == sellerId).toList();
    return Stream.value(sellerVehicles);
  }

  Stream<List<Vehicle>> searchVehicles({
    String? brand,
    String? model,
    double? maxPrice,
    int? minYear,
  }) {
    final results = MockService.searchMockVehicles(
      brand: brand,
      model: model,
      maxPrice: maxPrice,
      minYear: minYear,
    );
    return Stream.value(results);
  }

  Future<String?> updateVehicle(String vehicleId, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final index = _vehicles.indexWhere((v) => v.id == vehicleId);
    if (index != -1) {
      final vehicle = _vehicles[index];
      // Créer un nouveau véhicule avec les données mises à jour
      _vehicles[index] = Vehicle(
        id: vehicle.id,
        sellerId: vehicle.sellerId,
        sellerName: data['sellerName'] ?? vehicle.sellerName,
        sellerPhone: data['sellerPhone'] ?? vehicle.sellerPhone,
        brand: data['brand'] ?? vehicle.brand,
        model: data['model'] ?? vehicle.model,
        year: data['year'] ?? vehicle.year,
        mileage: data['mileage'] ?? vehicle.mileage,
        price: data['price']?.toDouble() ?? vehicle.price,
        description: data['description'] ?? vehicle.description,
        images: data['images'] ?? vehicle.images,
        latitude: data['latitude'] ?? vehicle.latitude,
        longitude: data['longitude'] ?? vehicle.longitude,
        location: data['location'] ?? vehicle.location,
        createdAt: vehicle.createdAt,
        status: data['status'] ?? vehicle.status,
      );
    }
    return null;
  }

  Future<String?> deleteVehicle(String vehicleId) async {
    await Future.delayed(const Duration(seconds: 1));
    _vehicles.removeWhere((v) => v.id == vehicleId);
    return null;
  }
}









