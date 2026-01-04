import '../models/vehicle_model.dart';
import '../models/user_model.dart';

/// Service mock pour tester l'application sans Firebase
class MockService {
  // Données mockées de véhicules
  static List<Vehicle> getMockVehicles() {
    return [
      Vehicle(
        id: '1',
        sellerId: 'seller1',
        sellerName: 'Jean Dupont',
        sellerPhone: '0612345678',
        brand: 'Renault',
        model: 'Clio',
        year: 2020,
        mileage: 50000,
        price: 12000,
        description: 'Véhicule en excellent état, bien entretenu. Première main, carnet d\'entretien à jour.',
        images: [
          'https://images.unsplash.com/photo-1605559424843-9e4c228bf1c2?w=800',
        ],
        latitude: 48.8566,
        longitude: 2.3522,
        location: 'Paris',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        status: 'active',
      ),
      Vehicle(
        id: '2',
        sellerId: 'seller2',
        sellerName: 'Marie Martin',
        sellerPhone: '0698765432',
        brand: 'Peugeot',
        model: '208',
        year: 2019,
        mileage: 35000,
        price: 15000,
        description: 'Peugeot 208 en très bon état, faible kilométrage. Idéal pour la ville.',
        images: [
          'https://images.unsplash.com/photo-1606664515524-ed2f786a0ad6?w=800',
        ],
        latitude: 45.7640,
        longitude: 4.8357,
        location: 'Lyon',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        status: 'active',
      ),
      Vehicle(
        id: '3',
        sellerId: 'seller3',
        sellerName: 'Pierre Durand',
        sellerPhone: '0611121314',
        brand: 'Citroën',
        model: 'C3',
        year: 2021,
        mileage: 20000,
        price: 18000,
        description: 'Citroën C3 récente, très peu utilisée. Garantie constructeur encore valable.',
        images: [
          'https://images.unsplash.com/photo-1606664515524-ed2f786a0ad6?w=800',
        ],
        latitude: 43.2965,
        longitude: 5.3698,
        location: 'Marseille',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        status: 'active',
      ),
      Vehicle(
        id: '4',
        sellerId: 'seller4',
        sellerName: 'Sophie Bernard',
        sellerPhone: '0655566677',
        brand: 'Toyota',
        model: 'Yaris',
        year: 2018,
        mileage: 60000,
        price: 11000,
        description: 'Toyota Yaris fiable et économique. Parfait pour les longs trajets.',
        images: [
          'https://images.unsplash.com/photo-1605559424843-9e4c228bf1c2?w=800',
        ],
        latitude: 44.8378,
        longitude: -0.5792,
        location: 'Bordeaux',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        status: 'active',
      ),
      Vehicle(
        id: '5',
        sellerId: 'seller5',
        sellerName: 'Thomas Petit',
        sellerPhone: '0688899900',
        brand: 'Volkswagen',
        model: 'Polo',
        year: 2020,
        mileage: 40000,
        price: 16000,
        description: 'Volkswagen Polo spacieuse et confortable. Équipements modernes.',
        images: [
          'https://images.unsplash.com/photo-1606664515524-ed2f786a0ad6?w=800',
        ],
        latitude: 50.6292,
        longitude: 3.0573,
        location: 'Lille',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        status: 'active',
      ),
    ];
  }

  // Utilisateur mocké
  static UserModel getMockUser({bool isSeller = false}) {
    return UserModel(
      id: 'mock_user_123',
      email: 'demo@occazcar.com',
      name: isSeller ? 'Vendeur Demo' : 'Acheteur Demo',
      phone: '0612345678',
      isSeller: isSeller,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  // Simuler une recherche
  static List<Vehicle> searchMockVehicles({
    String? brand,
    String? model,
    double? maxPrice,
    int? minYear,
  }) {
    var vehicles = getMockVehicles();

    if (brand != null && brand.isNotEmpty && brand != 'Toutes') {
      vehicles = vehicles.where((v) => v.brand.toLowerCase() == brand.toLowerCase()).toList();
    }

    if (maxPrice != null) {
      vehicles = vehicles.where((v) => v.price <= maxPrice).toList();
    }

    if (minYear != null) {
      vehicles = vehicles.where((v) => v.year >= minYear).toList();
    }

    if (model != null && model.isNotEmpty) {
      vehicles = vehicles.where((v) => v.model.toLowerCase().contains(model.toLowerCase())).toList();
    }

    return vehicles;
  }
}









