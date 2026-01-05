import 'package:flutter/material.dart';
import '../widgets/vehicle_card.dart';
import '../services/api_vehicle_service.dart';
import '../utils/modern_theme.dart';

class VehiclesListScreen extends StatefulWidget {
  const VehiclesListScreen({super.key});

  @override
  State<VehiclesListScreen> createState() => _VehiclesListScreenState();
}

class _VehiclesListScreenState extends State<VehiclesListScreen> with TickerProviderStateMixin {
  final ApiVehicleService _vehicleService = ApiVehicleService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Map<String, dynamic>> _allVehicles = [];
  List<Map<String, dynamic>> _filteredVehicles = [];
  String _selectedFuel = 'Tous';
  String _selectedTransmission = 'Tous';
  bool _isSearching = false;
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;
  
  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeInOut,
    );
    _fabController.forward();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _fabController.dispose();
    super.dispose();
  }
  
  Future<List<Map<String, dynamic>>> _loadVehicles() async {
    try {
      final vehicles = await _vehicleService.getVehicles();
      
      // Convert DemoVehicle objects to Maps for the VehicleCard widget
      _allVehicles = vehicles.map((vehicle) {
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
      
      _filteredVehicles = List.from(_allVehicles);
      return _filteredVehicles;
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
  
  void _filterVehicles(String query) {
    setState(() {
      _filteredVehicles = _allVehicles.where((vehicle) {
        final matchesSearch = query.isEmpty ||
            '${vehicle['marque']} ${vehicle['modele']}'.toLowerCase().contains(query.toLowerCase()) ||
            vehicle['ville'].toLowerCase().contains(query.toLowerCase());
        
        final matchesFuel = _selectedFuel == 'Tous' || vehicle['carburant'] == _selectedFuel;
        final matchesTransmission = _selectedTransmission == 'Tous' || vehicle['boite'] == _selectedTransmission;
        
        return matchesSearch && matchesFuel && matchesTransmission;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadVehicles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: ModernTheme.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Chargement des véhicules...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ModernTheme.darkGray,
                  ),
                ),
              ],
            ),
          );
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: ModernTheme.error.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: ModernTheme.error,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Erreur de chargement',
                    style: ModernTheme.headingMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Impossible de charger les véhicules. Vérifiez votre connexion.',
                    textAlign: TextAlign.center,
                    style: ModernTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ModernTheme.gradientButton(
                    text: 'Réessayer',
                    onPressed: () => setState(() {}),
                    icon: Icons.refresh_rounded,
                  ),
                ],
              ),
            ),
          );
        }
        
        if (_filteredVehicles.isEmpty && _allVehicles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ModernTheme.primaryOrange.withOpacity(0.1),
                        ModernTheme.secondaryOrange.withOpacity(0.05),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.directions_car_rounded,
                    size: 80,
                    color: ModernTheme.primaryOrange.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Aucun véhicule disponible',
                  style: ModernTheme.headingMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  'Soyez le premier à publier une annonce !',
                  style: ModernTheme.bodyMedium,
                ),
              ],
            ),
          );
        }
        
        return Stack(
          children: [
            Column(
              children: [
                // Modern Search Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Search Field
                      Container(
                        decoration: BoxDecoration(
                          color: ModernTheme.lightGray,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _filterVehicles,
                          decoration: InputDecoration(
                            hintText: 'Rechercher par marque, modèle ou ville...',
                            hintStyle: TextStyle(
                              color: ModernTheme.darkGray.withOpacity(0.6),
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: ModernTheme.primaryOrange,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded),
                                    onPressed: () {
                                      _searchController.clear();
                                      _filterVehicles('');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip(
                              label: 'Tous',
                              isSelected: _selectedFuel == 'Tous' && _selectedTransmission == 'Tous',
                              onTap: () {
                                setState(() {
                                  _selectedFuel = 'Tous';
                                  _selectedTransmission = 'Tous';
                                  _filterVehicles(_searchController.text);
                                });
                              },
                              icon: Icons.filter_list_rounded,
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                              label: 'Essence',
                              isSelected: _selectedFuel == 'Essence',
                              onTap: () {
                                setState(() {
                                  _selectedFuel = _selectedFuel == 'Essence' ? 'Tous' : 'Essence';
                                  _filterVehicles(_searchController.text);
                                });
                              },
                              icon: Icons.local_gas_station_rounded,
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                              label: 'Diesel',
                              isSelected: _selectedFuel == 'Diesel',
                              onTap: () {
                                setState(() {
                                  _selectedFuel = _selectedFuel == 'Diesel' ? 'Tous' : 'Diesel';
                                  _filterVehicles(_searchController.text);
                                });
                              },
                              icon: Icons.local_gas_station_rounded,
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                              label: 'Manuelle',
                              isSelected: _selectedTransmission == 'Manuelle',
                              onTap: () {
                                setState(() {
                                  _selectedTransmission = _selectedTransmission == 'Manuelle' ? 'Tous' : 'Manuelle';
                                  _filterVehicles(_searchController.text);
                                });
                              },
                              icon: Icons.settings_rounded,
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                              label: 'Automatique',
                              isSelected: _selectedTransmission == 'Automatique',
                              onTap: () {
                                setState(() {
                                  _selectedTransmission = _selectedTransmission == 'Automatique' ? 'Tous' : 'Automatique';
                                  _filterVehicles(_searchController.text);
                                });
                              },
                              icon: Icons.settings_rounded,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Results Count
                if (_filteredVehicles.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text(
                      '${_filteredVehicles.length} véhicule${_filteredVehicles.length > 1 ? 's' : ''} trouvé${_filteredVehicles.length > 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ModernTheme.darkGray,
                      ),
                    ),
                  ),
                // Vehicle List
                Expanded(
                  child: _filteredVehicles.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 64,
                                color: ModernTheme.darkGray.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Aucun résultat',
                                style: ModernTheme.headingSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Essayez avec d\'autres critères',
                                style: ModernTheme.bodyMedium,
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async => setState(() {}),
                          color: ModernTheme.primaryOrange,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                            itemCount: _filteredVehicles.length,
                            itemBuilder: (context, index) {
                              return VehicleCard(vehicle: _filteredVehicles[index]);
                            },
                          ),
                        ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? ModernTheme.primaryGradient : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.transparent : ModernTheme.mediumGray,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ModernTheme.primaryOrange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : ModernTheme.darkGray,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : ModernTheme.textDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
