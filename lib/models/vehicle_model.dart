import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory Vehicle.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Vehicle(
      id: doc.id,
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
      createdAt: (data['createdAt'] as Timestamp).toDate(),
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
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
    };
  }
}
