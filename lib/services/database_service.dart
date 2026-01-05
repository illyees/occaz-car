import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> addVehicle(Vehicle vehicle) async {
    try {
      await _firestore.collection('vehicles').add(vehicle.toJson());
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Stream<List<Vehicle>> getAllVehicles() {
    return _firestore
        .collection('vehicles')
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Vehicle.fromFirestore(doc)).toList());
  }

  Stream<List<Vehicle>> getVehiclesBySeller(String sellerId) {
    return _firestore
        .collection('vehicles')
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Vehicle.fromFirestore(doc)).toList());
  }

  Stream<List<Vehicle>> searchVehicles({
    String? brand,
    String? model,
    double? maxPrice,
    int? minYear,
  }) {
    Query query =
        _firestore.collection('vehicles').where('status', isEqualTo: 'active');

    if (brand != null && brand.isNotEmpty) {
      query = query.where('brand', isEqualTo: brand);
    }
    if (maxPrice != null) {
      query = query.where('price', isLessThanOrEqualTo: maxPrice);
    }
    if (minYear != null) {
      query = query.where('year', isGreaterThanOrEqualTo: minYear);
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Vehicle.fromFirestore(doc)).toList());
  }

  Future<String?> updateVehicle(
      String vehicleId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('vehicles').doc(vehicleId).update(data);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteVehicle(String vehicleId) async {
    try {
      await _firestore.collection('vehicles').doc(vehicleId).delete();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
