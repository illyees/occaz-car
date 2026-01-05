import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../models/vehicle_model.dart';
import 'vehicle_detail_screen.dart';
import 'package:intl/intl.dart';

class ModernSearchScreen extends StatefulWidget {
  const ModernSearchScreen({Key? key}) : super(key: key);

  @override
  State<ModernSearchScreen> createState() => _ModernSearchScreenState();
}

class _ModernSearchScreenState extends State<ModernSearchScreen> {
  final DatabaseService _dbService = DatabaseService();
  final TextEditingController _searchController = TextEditingController();
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'fr_FR', symbol: '€', decimalDigits: 0);

  String? _selectedBrand;
  double _maxPrice = 100000;
  int _minYear = 2000;
  bool _showFilters = false;

  final List<String> brands = [
    'Toutes',
    'Renault',
    'Peugeot',
    'Citroën',
    'Toyota',
    'Volkswagen',
    'BMW',
    'Mercedes',
    'Audi',
    'Ford',
    'Nissan',
    'Hyundai',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Header avec barre de recherche
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
                  Row(
                    children: [
                      // Bouton retour
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Barre de recherche
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Rechercher une marque, modèle...',
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onChanged: (value) => setState(() {}),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Bouton filtres
                      Container(
                        decoration: BoxDecoration(
                          color: _showFilters
                              ? const Color(0xFF2196F3)
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.tune,
                            color: _showFilters ? Colors.white : Colors.black,
                          ),
                          onPressed: () {
                            setState(() => _showFilters = !_showFilters);
                          },
                        ),
                      ),
                    ],
                  ),

                  // Filtres (si affichés)
                  if (_showFilters) ...[
                    const SizedBox(height: 16),
                    _buildFiltersSection(),
                  ],
                ],
              ),
            ),

            // Résultats
            Expanded(
              child: StreamBuilder<List<Vehicle>>(
                stream: _dbService.searchVehicles(
                  brand: _selectedBrand == 'Toutes' ? null : _selectedBrand,
                  maxPrice: _maxPrice,
                  minYear: _minYear,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off,
                              size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun résultat trouvé',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Essayez d\'ajuster vos filtres',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    );
                  }

                  final vehicles = snapshot.data!.where((vehicle) {
                    if (_searchController.text.isEmpty) return true;
                    final query = _searchController.text.toLowerCase();
                    return vehicle.brand.toLowerCase().contains(query) ||
                        vehicle.model.toLowerCase().contains(query);
                  }).toList();

                  if (vehicles.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off,
                              size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun résultat',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          '${vehicles.length} véhicule${vehicles.length > 1 ? 's' : ''} trouvé${vehicles.length > 1 ? 's' : ''}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: vehicles.length,
                          itemBuilder: (context, index) {
                            return _buildSearchResultCard(vehicles[index]);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filtres',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),

        // Marque
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: _selectedBrand,
            hint: const Text('Sélectionnez une marque'),
            underline: const SizedBox(),
            items: brands.map((brand) {
              return DropdownMenuItem(value: brand, child: Text(brand));
            }).toList(),
            onChanged: (value) => setState(() => _selectedBrand = value),
          ),
        ),

        const SizedBox(height: 16),

        // Prix maximum
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Prix max',
                style: TextStyle(fontWeight: FontWeight.w500)),
            Text(
              currencyFormat.format(_maxPrice),
              style: const TextStyle(
                color: Color(0xFF2196F3),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: _maxPrice,
          min: 0,
          max: 100000,
          divisions: 100,
          activeColor: const Color(0xFF2196F3),
          onChanged: (value) => setState(() => _maxPrice = value),
        ),

        const SizedBox(height: 8),

        // Année minimum
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Année min',
                style: TextStyle(fontWeight: FontWeight.w500)),
            Text(
              '$_minYear',
              style: const TextStyle(
                color: Color(0xFF2196F3),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: _minYear.toDouble(),
          min: 2000,
          max: DateTime.now().year.toDouble(),
          divisions: DateTime.now().year - 2000,
          activeColor: const Color(0xFF2196F3),
          onChanged: (value) => setState(() => _minYear = value.toInt()),
        ),

        const SizedBox(height: 8),

        // Bouton réinitialiser
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _selectedBrand = null;
                _maxPrice = 100000;
                _minYear = 2000;
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Réinitialiser les filtres'),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResultCard(Vehicle vehicle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModernVehicleDetailScreen(vehicle: vehicle),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: vehicle.images.isNotEmpty
                    ? Image.network(
                        vehicle.images[0],
                        width: 100,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 80,
                            color: Colors.grey[200],
                            child: Icon(Icons.directions_car,
                                color: Colors.grey[400]),
                          );
                        },
                      )
                    : Container(
                        width: 100,
                        height: 80,
                        color: Colors.grey[200],
                        child:
                            Icon(Icons.directions_car, color: Colors.grey[400]),
                      ),
              ),

              const SizedBox(width: 12),

              // Infos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${vehicle.brand} ${vehicle.model}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${vehicle.year} • ${NumberFormat('#,###', 'fr_FR').format(vehicle.mileage)} km',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currencyFormat.format(vehicle.price),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                  ],
                ),
              ),

              // Flèche
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
