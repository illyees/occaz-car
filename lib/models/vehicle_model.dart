class Vehicle {
  final String id;
  final String sellerId;
  final String sellerName;
  final String sellerPhone;
  final String brand;
  final String model;
  final int year;
  final int mileage;
  final double price;
  final String description;
  final List<String> images;
  final double? latitude;
  final double? longitude;
  final String? location;
  final DateTime createdAt;
  final String status;

  Vehicle({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.sellerPhone,
    required this.brand,
    required this.model,
    required this.year,
    required this.mileage,
    required this.price,
    required this.description,
    required this.images,
    this.latitude,
    this.longitude,
    this.location,
    required this.createdAt,
    this.status = 'active',
  });

  // Factory pour créer depuis un document MongoDB
  factory Vehicle.fromMongo(Map<String, dynamic> doc) {
    return Vehicle(
      id: doc['_id']?.toString() ?? '',
      sellerId: doc['sellerId'] ?? '',
      sellerName: doc['sellerName'] ?? '',
      sellerPhone: doc['sellerPhone'] ?? '',
      brand: doc['brand'] ?? '',
      model: doc['model'] ?? '',
      year: doc['year'] ?? 0,
      mileage: doc['mileage'] ?? 0,
      price: (doc['price'] ?? 0).toDouble(),
      description: doc['description'] ?? '',
      images: List<String>.from(doc['images'] ?? []),
      latitude: doc['latitude']?.toDouble(),
      longitude: doc['longitude']?.toDouble(),
      location: doc['location'],
      createdAt: doc['createdAt'] != null 
          ? (doc['createdAt'] is String 
              ? DateTime.parse(doc['createdAt'])
              : doc['createdAt'])
          : DateTime.now(),
      status: doc['status'] ?? 'active',
    );
  }

  // Factory pour compatibilité Firestore (si nécessaire)
  factory Vehicle.fromFirestore(dynamic doc) {
    Map<String, dynamic> data;
    String docId;
    
    if (doc is Map<String, dynamic>) {
      data = doc;
      docId = doc['_id']?.toString() ?? '';
    } else {
      // Compatibilité avec Firestore DocumentSnapshot
      data = doc.data() as Map<String, dynamic>;
      docId = doc.id;
    }
    
    return Vehicle(
      id: docId,
      sellerId: data['sellerId'] ?? '',
      sellerName: data['sellerName'] ?? '',
      sellerPhone: data['sellerPhone'] ?? '',
      brand: data['brand'] ?? '',
      model: data['model'] ?? '',
      year: data['year'] ?? 0,
      mileage: data['mileage'] ?? 0,
      price: (data['price'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      location: data['location'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] is String
              ? DateTime.parse(data['createdAt'])
              : (data['createdAt'] as dynamic).toDate())
          : DateTime.now(),
      status: data['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerPhone': sellerPhone,
      'brand': brand,
      'model': model,
      'year': year,
      'mileage': mileage,
      'price': price,
      'description': description,
      'images': images,
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
      'createdAt': createdAt.toIso8601String(), // Format ISO pour MongoDB
      'status': status,
    };
  }
}
