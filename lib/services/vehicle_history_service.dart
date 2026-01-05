import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle_history_model.dart';

class VehicleHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ajouter un historique
  Future<String?> addHistory(VehicleHistory history) async {
    try {
      await _firestore.collection('vehicleHistory').add(history.toJson());
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Récupérer l'historique d'un véhicule
  Stream<List<VehicleHistory>> getVehicleHistory(String vehicleId) {
    return _firestore
        .collection('vehicleHistory')
        .where('vehicleId', isEqualTo: vehicleId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VehicleHistory.fromFirestore(doc))
            .toList());
  }

  // Récupérer l'historique par type
  Stream<List<VehicleHistory>> getHistoryByType(
      String vehicleId, HistoryType type) {
    return _firestore
        .collection('vehicleHistory')
        .where('vehicleId', isEqualTo: vehicleId)
        .where('type', isEqualTo: type.toString().split('.').last)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VehicleHistory.fromFirestore(doc))
            .toList());
  }

  // Modifier un historique
  Future<String?> updateHistory(
      String historyId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('vehicleHistory').doc(historyId).update(data);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Supprimer un historique
  Future<String?> deleteHistory(String historyId) async {
    try {
      await _firestore.collection('vehicleHistory').doc(historyId).delete();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Obtenir des statistiques
  Future<Map<String, dynamic>> getHistoryStats(String vehicleId) async {
    try {
      final snapshot = await _firestore
          .collection('vehicleHistory')
          .where('vehicleId', isEqualTo: vehicleId)
          .get();

      int maintenanceCount = 0;
      int repairCount = 0;
      int damageCount = 0;
      double totalCost = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final type = data['type'];
        final cost = data['cost'] ?? 0.0;

        totalCost += cost;

        switch (type) {
          case 'maintenance':
            maintenanceCount++;
            break;
          case 'repair':
            repairCount++;
            break;
          case 'damage':
            damageCount++;
            break;
        }
      }

      return {
        'maintenanceCount': maintenanceCount,
        'repairCount': repairCount,
        'damageCount': damageCount,
        'totalCount': snapshot.docs.length,
        'totalCost': totalCost,
      };
    } catch (e) {
      return {};
    }
  }
}
