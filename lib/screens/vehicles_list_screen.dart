import 'package:flutter/material.dart';
import '../widgets/vehicle_card.dart';

class VehiclesListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> vehicles;

  const VehiclesListScreen({super.key, required this.vehicles});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        return VehicleCard(vehicle: vehicles[index]);
      },
    );
  }
}
