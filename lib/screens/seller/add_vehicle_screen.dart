import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../services/storage_service.dart';
import '../../models/vehicle_model.dart';
// ignore: unused_import
import '../../models/user_model.dart';

class ModernAddVehicleScreen extends StatefulWidget {
  const ModernAddVehicleScreen({Key? key}) : super(key: key);

  @override
  State<ModernAddVehicleScreen> createState() => _ModernAddVehicleScreenState();
}

class _ModernAddVehicleScreenState extends State<ModernAddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _mileageController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  final DatabaseService _dbService = DatabaseService();
  final StorageService _storageService = StorageService();
  final ImagePicker _picker = ImagePicker();

  List<File> _selectedImages = [];
  bool _isLoading = false;
  Position? _currentPosition;
  int _currentStep = 0;

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages = images.map((img) => File(img.path)).toList();
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar('Veuillez activer la localisation', isError: true);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() => _currentPosition = position);
      _showSnackBar('Localisation récupérée !', isError: false);
    } catch (e) {
      _showSnackBar('Erreur: $e', isError: true);
    }
  }

  Future<void> _submitVehicle() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Veuillez remplir tous les champs', isError: true);
      return;
    }

    if (_selectedImages.isEmpty) {
      _showSnackBar('Ajoutez au moins une photo', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = await authService.getUserData(authService.currentUser!.uid);

      List<String> imageUrls = await _storageService.uploadMultipleImages(
        _selectedImages,
        'vehicles/${authService.currentUser!.uid}',
      );

      Vehicle vehicle = Vehicle(
        id: '',
        sellerId: authService.currentUser!.uid,
        sellerName: user?.name ?? '',
        sellerPhone: user?.phone ?? '',
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
        year: int.parse(_yearController.text),
        mileage: int.parse(_mileageController.text),
        price: double.parse(_priceController.text),
        description: _descriptionController.text.trim(),
        images: imageUrls,
        latitude: _currentPosition?.latitude,
        longitude: _currentPosition?.longitude,
        location: _locationController.text.trim(),
        createdAt: DateTime.now(),
      );

      String? error = await _dbService.addVehicle(vehicle);

      setState(() => _isLoading = false);

      if (error != null) {
        _showSnackBar('Erreur: $error', isError: true);
      } else {
        _showSnackBar('Annonce publiée avec succès !', isError: false);
        _clearForm();
        setState(() => _currentStep = 0);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Erreur: $e', isError: true);
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _brandController.clear();
    _modelController.clear();
    _yearController.clear();
    _mileageController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _locationController.clear();
    setState(() {
      _selectedImages.clear();
      _currentPosition = null;
    });
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Ajouter un véhicule'),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 2) {
              setState(() => _currentStep++);
            } else {
              _submitVehicle();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(_currentStep == 2 ? 'Publier' : 'Suivant'),
                    ),
                  ),
                  if (_currentStep > 0) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Retour'),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Photos'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: _buildPhotosStep(),
            ),
            Step(
              title: const Text('Détails'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: _buildDetailsStep(),
            ),
            Step(
              title: const Text('Infos'),
              isActive: _currentStep >= 2,
              content: _buildInfoStep(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ajoutez des photos de votre véhicule',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          'Minimum 1 photo, maximum 10',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: _pickImages,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!, width: 2),
            ),
            child: _selectedImages.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate,
                          size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      Text('Ajouter des photos',
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_selectedImages[index],
                                fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() => _selectedImages.removeAt(index));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close,
                                    size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsStep() {
    return Column(
      children: [
        TextFormField(
          controller: _brandController,
          decoration: InputDecoration(
            labelText: 'Marque *',
            prefixIcon: const Icon(Icons.directions_car),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _modelController,
          decoration: InputDecoration(
            labelText: 'Modèle *',
            prefixIcon: const Icon(Icons.car_rental),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _yearController,
                decoration: InputDecoration(
                  labelText: 'Année *',
                  prefixIcon: const Icon(Icons.calendar_today),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _mileageController,
                decoration: InputDecoration(
                  labelText: 'Km *',
                  prefixIcon: const Icon(Icons.speed),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _priceController,
          decoration: InputDecoration(
            labelText: 'Prix (€) *',
            prefixIcon: const Icon(Icons.euro),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          keyboardType: TextInputType.number,
          validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
        ),
      ],
    );
  }

  Widget _buildInfoStep() {
    return Column(
      children: [
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: 'Description *',
            alignLabelWithHint: true,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          maxLines: 5,
          validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _locationController,
          decoration: InputDecoration(
            labelText: 'Ville/Région',
            prefixIcon: const Icon(Icons.location_on),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _getCurrentLocation,
            icon: Icon(_currentPosition == null
                ? Icons.my_location
                : Icons.check_circle),
            label: Text(_currentPosition == null
                ? 'Récupérer ma position GPS'
                : 'Position GPS enregistrée'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}
