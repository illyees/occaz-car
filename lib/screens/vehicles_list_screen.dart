import 'package:flutter/material.dart';
import '../widgets/vehicle_card.dart';
import '../services/api_vehicle_service.dart';

class VehiclesListScreen extends StatefulWidget {
  const VehiclesListScreen({super.key});

  @override
  State<VehiclesListScreen> createState() => _VehiclesListScreenState();
}

class _VehiclesListScreenState extends State<VehiclesListScreen> {
  final ApiVehicleService _vehicleService = ApiVehicleService();
  
  Future<List<Map<String, dynamic>>> _loadVehicles() async {
    try {
      final vehicles = await _vehicleService.getVehicles();
      
      // Convert DemoVehicle objects to Maps for the VehicleCard widget
      return vehicles.map((vehicle) {
        return {
          'id': vehicle.id,
          'marque': vehicle.marque,
          'modele': vehicle.modele,
          'annee': vehicle.annee,
          'prix': vehicle.prix,
          'kilometrage': vehicle.kilometrage,
          'carburant': vehicle.carburant,
          'boite': vehicle.boite,
          'ville': vehicle.ville,
          'image': vehicle.image,
          'images': vehicle.images,
          'description': vehicle.description,
        };
      }).toList();
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadVehicles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Erreur de chargement',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => setState(() {}),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }
        
        final vehicles = snapshot.data ?? [];
        
        if (vehicles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.car_rental, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Aucun véhicule disponible',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Soyez le premier à publier une annonce !',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }
        
        return RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              return VehicleCard(vehicle: vehicles[index]);
            },
          ),
        );
      },
    );
  }
}
