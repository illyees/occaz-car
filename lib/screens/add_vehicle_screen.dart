import 'package:flutter/material.dart';
import '../utils/demo_data.dart';
import '../services/api_vehicle_service.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _marqueController = TextEditingController();
  final _modeleController = TextEditingController();
  final _anneeController = TextEditingController();
  final _prixController = TextEditingController();
  final _kilometrageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ApiVehicleService _vehicleService = ApiVehicleService();
  
  String? _carburant;
  String? _boite;
  String? _ville;
  bool _isLoading = false;

  @override
  void dispose() {
    _marqueController.dispose();
    _modeleController.dispose();
    _anneeController.dispose();
    _prixController.dispose();
    _kilometrageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final response = await _vehicleService.createVehicle(
          marque: _marqueController.text,
          modele: _modeleController.text,
          annee: int.parse(_anneeController.text),
          prix: double.parse(_prixController.text),
          kilometrage: int.parse(_kilometrageController.text),
          carburant: _carburant!,
          boite: _boite!,
          ville: _ville!,
          description: _descriptionController.text.isNotEmpty 
              ? _descriptionController.text 
              : '${_marqueController.text} ${_modeleController.text} ${_anneeController.text}',
        );

        if (mounted) {
          setState(() => _isLoading = false);

          if (response['success']) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Annonce publiée avec succès !'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response['message'] ?? 'Erreur lors de la publication'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une annonce'),
        backgroundColor: Colors.orange[700],
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Informations du véhicule',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey[600]),
                        const SizedBox(height: 8),
                        Text(
                          'Ajouter des photos',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _marqueController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'Marque *',
                prefixIcon: const Icon(Icons.car_rental),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Veuillez entrer la marque' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _modeleController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'Modèle *',
                prefixIcon: const Icon(Icons.directions_car),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Veuillez entrer le modèle' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _anneeController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'Année *',
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Veuillez entrer l\'année';
                final year = int.tryParse(value!);
                if (year == null || year < 1900 || year > 2026) return 'Année invalide';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _prixController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'Prix (DT) *',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Veuillez entrer le prix';
                if (int.tryParse(value!) == null) return 'Prix invalide';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _kilometrageController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'Kilométrage *',
                prefixIcon: const Icon(Icons.speed),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Veuillez entrer le kilométrage';
                if (int.tryParse(value!) == null) return 'Kilométrage invalide';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'Description',
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _carburant,
              decoration: InputDecoration(
                labelText: 'Carburant *',
                prefixIcon: const Icon(Icons.local_gas_station),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: DemoData.carburants.map((value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: _isLoading ? null : (value) => setState(() => _carburant = value),
              validator: (value) => value == null ? 'Veuillez sélectionner le type de carburant' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _boite,
              decoration: InputDecoration(
                labelText: 'Boîte de vitesse *',
                prefixIcon: const Icon(Icons.settings),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: DemoData.boites.map((value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: _isLoading ? null : (value) => setState(() => _boite = value),
              validator: (value) => value == null ? 'Veuillez sélectionner la boîte de vitesse' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _ville,
              decoration: InputDecoration(
                labelText: 'Ville *',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: DemoData.villes.map((value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: _isLoading ? null : (value) => setState(() => _ville = value),
              validator: (value) => value == null ? 'Veuillez sélectionner la ville' : null,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _submitForm,
                icon: _isLoading 
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.check),
                label: Text(_isLoading ? 'Publication...' : 'Publier l\'annonce'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
