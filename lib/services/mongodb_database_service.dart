import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongo_dart_query/mongo_dart_query.dart';
import '../config/mongodb_config.dart';
import '../models/vehicle_model.dart';

/// Service de base de données MongoDB pour remplacer Firestore
class MongoDBDatabaseService {
  Db? _db;
  bool _isConnected = false;

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

  /// Ajouter un véhicule
  Future<String?> addVehicle(Vehicle vehicle) async {
    try {
      await _ensureConnected();
      final collection = _db!.collection(MongoDBConfig.vehiclesCollection);
      
      final vehicleJson = vehicle.toJson();
      vehicleJson['_id'] = ObjectId();
      vehicleJson['createdAt'] = vehicle.createdAt.toIso8601String();
      
      await collection.insert(vehicleJson);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Obtenir tous les véhicules actifs
  Stream<List<Vehicle>> getAllVehicles() {
    return _getVehiclesStream({'status': 'active'});
  }

  /// Obtenir les véhicules d'un vendeur
  Stream<List<Vehicle>> getVehiclesBySeller(String sellerId) {
    return _getVehiclesStream({
      'sellerId': sellerId,
      'status': 'active',
    });
  }

  /// Stream de véhicules avec filtres
  Stream<List<Vehicle>> _getVehiclesStream(Map<String, dynamic> query) {
    final controller = StreamController<List<Vehicle>>();
    
    _ensureConnected().then((_) async {
      final collection = _db!.collection(MongoDBConfig.vehiclesCollection);
      
      // Polling pour simuler un stream (MongoDB n'a pas de streams temps réel natifs)
      Timer.periodic(const Duration(seconds: 2), (timer) async {
        try {
          final cursor = collection.find(query);
          
          final vehicles = <Vehicle>[];
          await for (var doc in cursor) {
            try {
              vehicles.add(_vehicleFromMongoDoc(doc));
            } catch (e) {
              // Ignorer les documents invalides
            }
          }
          
          // Trier par date de création (plus récent en premier)
          vehicles.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          
          if (!controller.isClosed) {
            controller.add(vehicles);
          } else {
            timer.cancel();
          }
        } catch (e) {
          if (!controller.isClosed) {
            controller.addError(e);
          }
        }
      });
    });

    return controller.stream;
  }

  /// Rechercher des véhicules
  Stream<List<Vehicle>> searchVehicles({
    String? brand,
    String? model,
    double? maxPrice,
    int? minYear,
  }) {
    final query = <String, dynamic>{'status': 'active'};

    if (brand != null && brand.isNotEmpty) {
      query['brand'] = brand;
    }
    if (maxPrice != null) {
      query['price'] = {'\$lte': maxPrice};
    }
    if (minYear != null) {
      query['year'] = {'\$gte': minYear};
    }

    return _getVehiclesStream(query);
  }

  /// Mettre à jour un véhicule
  Future<String?> updateVehicle(String vehicleId, Map<String, dynamic> data) async {
    try {
      await _ensureConnected();
      final collection = _db!.collection(MongoDBConfig.vehiclesCollection);
      
      // Construire le modifier avec tous les champs
      var modifierBuilder = modify;
      data.forEach((key, value) {
        modifierBuilder = modifierBuilder.set(key, value);
      });
      
      await collection.update(
        where.id(ObjectId.fromHexString(vehicleId)),
        modifierBuilder,
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Supprimer un véhicule
  Future<String?> deleteVehicle(String vehicleId) async {
    try {
      await _ensureConnected();
      final collection = _db!.collection(MongoDBConfig.vehiclesCollection);
      
      await collection.remove(where.id(ObjectId.fromHexString(vehicleId)));
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Convertir un document MongoDB en Vehicle
  Vehicle _vehicleFromMongoDoc(Map<String, dynamic> doc) {
    return Vehicle.fromMongo(doc);
  }

  /// Fermer la connexion
  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _isConnected = false;
    }
  }
}

