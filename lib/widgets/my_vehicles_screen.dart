import 'package:flutter/material.dart';

class MyVehiclesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> userVehicles;
  final Function(int) onDelete;
  final VoidCallback onAddVehicle;

  const MyVehiclesScreen({
    super.key,
    required this.userVehicles,
    required this.onDelete,
    required this.onAddVehicle,
  });

  @override
  Widget build(BuildContext context) {
    if (userVehicles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.car_rental, size: 100, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Aucune annonce',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Commencez à vendre vos véhicules',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAddVehicle,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter une annonce'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: userVehicles.length,
      itemBuilder: (context, index) {
        final vehicle = userVehicles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.directions_car),
            ),
            title: Text('${vehicle['marque']} ${vehicle['modele']}'),
            subtitle: Text('${vehicle['prix']} DT - ${vehicle['ville']}'),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Modifier')),
                const PopupMenuItem(value: 'delete', child: Text('Supprimer')),
              ],
              onSelected: (value) {
                if (value == 'delete') onDelete(index);
              },
            ),
          ),
        );
      },
    );
  }
}
