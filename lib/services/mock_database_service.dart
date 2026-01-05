import '../models/vehicle_model.dart';

class MockDatabaseService {
  // Données de test hardcodées
  final List<Vehicle> _mockVehicles = [
    Vehicle(
      id: '1',
      sellerId: 'mock-user-123',
      sellerName: 'Ahmed Ben Ali',
      sellerPhone: '+216 98 765 432',
      brand: 'Renault',
      model: 'Clio 4',
      year: 2019,
      mileage: 45000,
      price: 28000,
      description: 'Voiture en excellent état, première main, entretien régulier.',
      images: [
        'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=800&q=80',
        'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=800&q=80',
        'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800&q=80',
      ],
      latitude: 36.8065,
      longitude: 10.1815,
      location: 'Tunis, Tunisie',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      status: 'active',
    ),
    Vehicle(
      id: '2',
      sellerId: 'mock-user-456',
      sellerName: 'Fatma Trabelsi',
      sellerPhone: '+216 22 123 456',
      brand: 'Peugeot',
      model: '208',
      year: 2020,
      mileage: 35000,
      price: 32000,
      description: 'Voiture économique, climatisation, GPS intégré.',
      images: [
        'https://images.unsplash.com/photo-1603584173870-7f23fdae1b7a?w=800&q=80',
        'https://images.unsplash.com/photo-1614200187524-dc4b892acf16?w=800&q=80',
      ],
      latitude: 36.8189,
      longitude: 10.1658,
      location: 'Ariana, Tunisie',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      status: 'active',
    ),
    Vehicle(
      id: '3',
      sellerId: 'mock-user-789',
      sellerName: 'Mohamed Gharbi',
      sellerPhone: '+216 55 987 654',
      brand: 'Volkswagen',
      model: 'Golf 7',
      year: 2018,
      mileage: 62000,
      price: 35000,
      description: 'Golf 7 GTI Line, full options, jantes alu 18".',
      images: [
        'https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=800&q=80',
        'https://images.unsplash.com/photo-1619405399517-d7fce0f13302?w=800&q=80',
        'https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=800&q=80',
      ],
      latitude: 35.8256,
      longitude: 10.6361,
      location: 'Sousse, Tunisie',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      status: 'active',
    ),
    Vehicle(
      id: '4',
      sellerId: 'mock-user-123',
      sellerName: 'Ahmed Ben Ali',
      sellerPhone: '+216 98 765 432',
      brand: 'Toyota',
      model: 'Corolla',
      year: 2021,
      mileage: 15000,
      price: 52000,
      description: 'Voiture quasi neuve, garantie constructeur, tous les équipements.',
      images: [
        'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=800&q=80',
        'https://images.unsplash.com/photo-1627454820516-eb49ba9d9e0e?w=800&q=80',
        'https://images.unsplash.com/photo-1629897048514-3dd7414fe72a?w=800&q=80',
      ],
      latitude: 36.8065,
      longitude: 10.1815,
      location: 'Tunis, Tunisie',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: 'active',
    ),
    Vehicle(
      id: '5',
      sellerId: 'mock-user-999',
      sellerName: 'Sami Mansour',
      sellerPhone: '+216 24 567 890',
      brand: 'BMW',
      model: 'Serie 3',
      year: 2017,
      mileage: 78000,
      price: 65000,
      description: 'BMW Série 3, cuir, toit panoramique, excellent état.',
      images: [
        'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=800&q=80',
        'https://images.unsplash.com/photo-1617814076367-b759c7d7e738?w=800&q=80',
        'https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=800&q=80',
      ],
      latitude: 33.8869,
      longitude: 10.0982,
      location: 'Sfax, Tunisie',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      status: 'active',
    ),
  ];

  Future<String?> addVehicle(Vehicle vehicle) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockVehicles.add(vehicle);
    return null;
  }

  Stream<List<Vehicle>> getAllVehicles() async* {
    await Future.delayed(const Duration(milliseconds: 300));
    yield _mockVehicles.where((v) => v.status == 'active').toList();
  }

  Stream<List<Vehicle>> getVehiclesBySeller(String sellerId) async* {
    await Future.delayed(const Duration(milliseconds: 300));
    yield _mockVehicles.where((v) => v.sellerId == sellerId).toList();
  }

  Stream<List<Vehicle>> searchVehicles({
    String? brand,
    String? model,
    double? maxPrice,
    int? minYear,
  }) async* {
    await Future.delayed(const Duration(milliseconds: 300));
    
    var filtered = _mockVehicles.where((v) {
      if (v.status != 'active') return false;
      if (brand != null && brand.isNotEmpty && v.brand != brand) return false;
      if (model != null && model.isNotEmpty && v.model != model) return false;
      if (maxPrice != null && v.price > maxPrice) return false;
      if (minYear != null && v.year < minYear) return false;
      return true;
    }).toList();
    
    yield filtered;
  }

  Future<String?> updateVehicle(String vehicleId, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockVehicles.indexWhere((v) => v.id == vehicleId);
    if (index != -1) {
      // Mise à jour des données (simplifié)
      print('Vehicle updated: $vehicleId');
    }
    return null;
  }

  Future<String?> deleteVehicle(String vehicleId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockVehicles.removeWhere((v) => v.id == vehicleId);
    return null;
  }
}
