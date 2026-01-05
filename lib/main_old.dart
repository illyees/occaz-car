import 'package:flutter/material.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/vehicles_list_screen.dart';
import 'screens/vehicle_details_screen.dart';
import 'screens/add_vehicle_screen.dart';
import 'screens/profile_settings_screen.dart';

// Widgets
import 'widgets/profile_screen.dart';
import 'widgets/my_vehicles_screen.dart';

// Utils
import 'utils/demo_data.dart';

void main() {
  runApp(const OccazCarDemo());
}

class OccazCarDemo extends StatelessWidget {
  const OccazCarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OccazCar - Demo UI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DemoHomeScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/vehicle-details': (context) => const VehicleDetailsScreen(),
        '/add-vehicle': (context) => const AddVehicleScreen(),
        '/profile-settings': (context) => const ProfileSettingsScreen(),
      },
    );
  }
}

class DemoHomeScreen extends StatefulWidget {
  const DemoHomeScreen({super.key});

  @override
  State<DemoHomeScreen> createState() => _DemoHomeScreenState();
}

class _DemoHomeScreenState extends State<DemoHomeScreen> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false;
  List<Map<String, dynamic>> _userVehicles = [];
  final List<Map<String, dynamic>> _demoVehicles = DemoData.vehiclesMaps;

  Future<void> _handleAddVehicle() async {
    final result = await Navigator.pushNamed(context, '/add-vehicle');
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _userVehicles.add(result);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Annonce ajoutée avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _handleDeleteVehicle(int index) {
    setState(() {
      _userVehicles.removeAt(index);
    });
  }

  void _handleLogin() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _handleLogout() {
    setState(() {
      _isLoggedIn = false;
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return LoginScreen(onLogin: _handleLogin);
    }

    final List<Widget> screens = [
      VehiclesListScreen(vehicles: _demoVehicles),
      const Center(child: Text('Recherche (à venir)')),
      MyVehiclesScreen(
        userVehicles: _userVehicles,
        onDelete: _handleDeleteVehicle,
        onAddVehicle: _handleAddVehicle,
      ),
      ProfileScreen(onLogout: _handleLogout),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('OccazCar'),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Rechercher',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Vendre',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _handleAddVehicle,
              icon: const Icon(Icons.add),
              label: const Text('Publier une annonce'),
            )
          : null,
    );
  }
}
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car, size: 100, color: Colors.blue[700]),
            const SizedBox(height: 24),
            Text(
              'OccazCar',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Votre plateforme de véhicules d\'occasion',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  setState(() {
                    _isLoggedIn = true;
                  });
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Se connecter'),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _isLoggedIn = true;
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehiclesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _demoVehicles.length,
      itemBuilder: (context, index) {
        final vehicle = _demoVehicles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    vehicle['image'],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.directions_car, size: 80),
                      );
                    },
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[700],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${vehicle['prix']} DT',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${vehicle['marque']} ${vehicle['modele']}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text('${vehicle['annee']}'),
                        const SizedBox(width: 16),
                        Icon(Icons.speed, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text('${vehicle['kilometrage']} km'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.local_gas_station, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(vehicle['carburant']),
                        const SizedBox(width: 16),
                        Icon(Icons.settings, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(vehicle['boite']),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(vehicle['ville']),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.phone),
                            label: const Text('Contacter'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/vehicle-details',
                                arguments: vehicle,
                              );
                            },
                            icon: const Icon(Icons.visibility),
                            label: const Text('Détails'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Stack(
            children: [
              const CircleAvatar(
                radius: 60,
                child: Icon(Icons.person, size: 60),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blue[700],
                  child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Utilisateur Demo',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'demo@occazcar.tn',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 32),
          _buildProfileOption(
            context,
            icon: Icons.settings,
            title: 'Paramètres du compte',
            onTap: () {
              Navigator.pushNamed(context, '/profile-settings');
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.notifications,
            title: 'Notifications',
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
          _buildProfileOption(
            context,
            icon: Icons.favorite,
            title: 'Mes favoris',
            badge: '3',
            onTap: () {},
          ),
          _buildProfileOption(
            context,
            icon: Icons.history,
            title: 'Historique des recherches',
            onTap: () {},
          ),
          _buildProfileOption(
            context,
            icon: Icons.help_outline,
            title: 'Aide et support',
            onTap: () {},
          ),
          _buildProfileOption(
            context,
            icon: Icons.info_outline,
            title: 'À propos',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoggedIn = false;
                  _selectedIndex = 0;
                });
              },
              icon: const Icon(Icons.logout),
              label: const Text('Se déconnecter'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? badge,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[700]),
        title: Text(title),
        trailing: trailing ??
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right),
              ],
            ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildMyVehiclesScreen() {
    if (_userVehicles.isEmpty) {
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
              onPressed: () async {
                final result = await Navigator.pushNamed(context, '/add-vehicle');
                if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                    _userVehicles.add(result);
                  });
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Ajouter une annonce'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _userVehicles.length,
      itemBuilder: (context, index) {
        final vehicle = _userVehicles[index];
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
                if (value == 'delete') {
                  setState(() {
                    _userVehicles.removeAt(index);
                  });
                }
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return Scaffold(
        body: _buildLoginScreen(),
      );
    }

    final List<Widget> screens = [
      _buildVehiclesList(),
      const Center(child: Text('Recherche (à venir)')),
      _buildMyVehiclesScreen(),
      _buildProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('OccazCar'),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Rechercher',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Vendre',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.pushNamed(context, '/add-vehicle');
                if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                    _userVehicles.add(result);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Annonce ajoutée avec succès !'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Publier une annonce'),
            )
          : null,
    );
  }
}

// ============ ÉCRAN DES DÉTAILS DU VÉHICULE ============
class VehicleDetailsScreen extends StatelessWidget {
  const VehicleDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicle = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    vehicle['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.directions_car, size: 100),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${vehicle['marque']} ${vehicle['modele']}',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue[700],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${vehicle['prix']} DT',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Caractéristiques',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(Icons.calendar_today, 'Année', '${vehicle['annee']}'),
                  _buildDetailRow(Icons.speed, 'Kilométrage', '${vehicle['kilometrage']} km'),
                  _buildDetailRow(Icons.local_gas_station, 'Carburant', vehicle['carburant']),
                  _buildDetailRow(Icons.settings, 'Boîte de vitesse', vehicle['boite']),
                  _buildDetailRow(Icons.location_on, 'Ville', vehicle['ville']),
                  const SizedBox(height: 24),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Véhicule en excellent état, entretien régulier, jamais accidenté. '
                    'Toutes les révisions effectuées chez le concessionnaire. '
                    'Prix négociable.',
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Équipements',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildEquipmentChip('Climatisation'),
                      _buildEquipmentChip('GPS'),
                      _buildEquipmentChip('Régulateur de vitesse'),
                      _buildEquipmentChip('Caméra de recul'),
                      _buildEquipmentChip('Sièges chauffants'),
                      _buildEquipmentChip('Bluetooth'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vendeur',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                child: Icon(Icons.person),
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mohamed Ali',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Membre depuis 2023',
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone),
                label: const Text('Appeler'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.message),
                label: const Text('Message'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue[700]),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentChip(String label) {
    return Chip(
      label: Text(label),
      avatar: const Icon(Icons.check, size: 16),
      backgroundColor: Colors.blue[50],
      labelStyle: TextStyle(color: Colors.blue[700]),
    );
  }
}

// ============ ÉCRAN D'AJOUT DE VÉHICULE ============
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
  
  String? _carburant;
  String? _boite;
  String? _ville;

  final List<String> _carburants = ['Essence', 'Diesel', 'Hybride', 'Électrique'];
  final List<String> _boites = ['Manuelle', 'Automatique'];
  final List<String> _villes = ['Tunis', 'Sfax', 'Sousse', 'Nabeul', 'Monastir', 'Bizerte', 'Kairouan'];

  @override
  void dispose() {
    _marqueController.dispose();
    _modeleController.dispose();
    _anneeController.dispose();
    _prixController.dispose();
    _kilometrageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final vehicle = {
        'marque': _marqueController.text,
        'modele': _modeleController.text,
        'annee': int.parse(_anneeController.text),
        'prix': int.parse(_prixController.text),
        'kilometrage': int.parse(_kilometrageController.text),
        'carburant': _carburant,
        'boite': _boite,
        'ville': _ville,
        'image': 'https://via.placeholder.com/400x300.png?text=${_marqueController.text}+${_modeleController.text}',
      };

      Navigator.pop(context, vehicle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une annonce'),
        backgroundColor: Colors.blue[700],
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
                child: Column(
                  children: [
                    Container(
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _marqueController,
              decoration: InputDecoration(
                labelText: 'Marque *',
                prefixIcon: const Icon(Icons.car_rental),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer la marque';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _modeleController,
              decoration: InputDecoration(
                labelText: 'Modèle *',
                prefixIcon: const Icon(Icons.directions_car),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le modèle';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _anneeController,
              decoration: InputDecoration(
                labelText: 'Année *',
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer l\'année';
                }
                final year = int.tryParse(value);
                if (year == null || year < 1900 || year > 2026) {
                  return 'Année invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _prixController,
              decoration: InputDecoration(
                labelText: 'Prix (DT) *',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le prix';
                }
                if (int.tryParse(value) == null) {
                  return 'Prix invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _kilometrageController,
              decoration: InputDecoration(
                labelText: 'Kilométrage *',
                prefixIcon: const Icon(Icons.speed),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le kilométrage';
                }
                if (int.tryParse(value) == null) {
                  return 'Kilométrage invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _carburant,
              decoration: InputDecoration(
                labelText: 'Carburant *',
                prefixIcon: const Icon(Icons.local_gas_station),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _carburants.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _carburant = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Veuillez sélectionner le type de carburant';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _boite,
              decoration: InputDecoration(
                labelText: 'Boîte de vitesse *',
                prefixIcon: const Icon(Icons.settings),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _boites.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _boite = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Veuillez sélectionner la boîte de vitesse';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _ville,
              decoration: InputDecoration(
                labelText: 'Ville *',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _villes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _ville = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Veuillez sélectionner la ville';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.check),
                label: const Text('Publier l\'annonce'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ============ ÉCRAN DES PARAMÈTRES DU PROFIL ============
class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _nomController = TextEditingController(text: 'Utilisateur Demo');
  final _emailController = TextEditingController(text: 'demo@occazcar.tn');
  final _telephoneController = TextEditingController(text: '+216 20 123 456');
  final _villeController = TextEditingController(text: 'Tunis');
  
  bool _notificationsEmail = true;
  bool _notificationsPush = true;
  bool _profilPublic = true;

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _villeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres du compte'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Paramètres enregistrés'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Informations personnelles',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nomController,
            decoration: InputDecoration(
              labelText: 'Nom complet',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _telephoneController,
            decoration: InputDecoration(
              labelText: 'Téléphone',
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _villeController,
            decoration: InputDecoration(
              labelText: 'Ville',
              prefixIcon: const Icon(Icons.location_on),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Notifications',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Notifications par email'),
            subtitle: const Text('Recevoir des alertes par email'),
            value: _notificationsEmail,
            onChanged: (value) {
              setState(() {
                _notificationsEmail = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Notifications push'),
            subtitle: const Text('Recevoir des notifications sur l\'application'),
            value: _notificationsPush,
            onChanged: (value) {
              setState(() {
                _notificationsPush = value;
              });
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Confidentialité',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Profil public'),
            subtitle: const Text('Permettre aux autres de voir votre profil'),
            value: _profilPublic,
            onChanged: (value) {
              setState(() {
                _profilPublic = value;
              });
            },
          ),
          const SizedBox(height: 32),
          Text(
            'Sécurité',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Changer le mot de passe'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Mot de passe actuel',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Nouveau mot de passe',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Confirmer le mot de passe',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annuler'),
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Mot de passe modifié'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: const Text('Confirmer'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.key),
            label: const Text('Changer le mot de passe'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Supprimer le compte'),
                  content: const Text(
                    'Êtes-vous sûr de vouloir supprimer votre compte ? '
                    'Cette action est irréversible.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annuler'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Supprimer'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete_forever),
            label: const Text('Supprimer mon compte'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
