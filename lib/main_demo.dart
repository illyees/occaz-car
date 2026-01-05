import 'package:flutter/material.dart';

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

  final List<Map<String, dynamic>> _demoVehicles = [
    {
      'marque': 'Renault',
      'modele': 'Clio',
      'annee': 2020,
      'prix': 32000,
      'kilometrage': 45000,
      'carburant': 'Essence',
      'boite': 'Manuelle',
      'ville': 'Tunis',
      'image': 'https://via.placeholder.com/400x300.png?text=Renault+Clio',
    },
    {
      'marque': 'Peugeot',
      'modele': '208',
      'annee': 2021,
      'prix': 38000,
      'kilometrage': 28000,
      'carburant': 'Diesel',
      'boite': 'Automatique',
      'ville': 'Sfax',
      'image': 'https://via.placeholder.com/400x300.png?text=Peugeot+208',
    },
    {
      'marque': 'Volkswagen',
      'modele': 'Golf',
      'annee': 2019,
      'prix': 45000,
      'kilometrage': 62000,
      'carburant': 'Diesel',
      'boite': 'Manuelle',
      'ville': 'Sousse',
      'image': 'https://via.placeholder.com/400x300.png?text=VW+Golf',
    },
    {
      'marque': 'Toyota',
      'modele': 'Corolla',
      'annee': 2022,
      'prix': 55000,
      'kilometrage': 15000,
      'carburant': 'Hybride',
      'boite': 'Automatique',
      'ville': 'Tunis',
      'image': 'https://via.placeholder.com/400x300.png?text=Toyota+Corolla',
    },
    {
      'marque': 'BMW',
      'modele': 'Serie 3',
      'annee': 2021,
      'prix': 85000,
      'kilometrage': 35000,
      'carburant': 'Diesel',
      'boite': 'Automatique',
      'ville': 'Monastir',
      'image': 'https://via.placeholder.com/400x300.png?text=BMW+Serie+3',
    },
  ];

  Widget _buildLoginScreen() {
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
                            onPressed: () {},
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          Text(
            'Utilisateur Demo',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'demo@occazcar.tn',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () {
              setState(() {
                _isLoggedIn = false;
                _selectedIndex = 0;
              });
            },
            icon: const Icon(Icons.logout),
            label: const Text('Se déconnecter'),
          ),
        ],
      ),
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
      const Center(child: Text('Mes annonces (à venir)')),
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
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Publier une annonce'),
            )
          : null,
    );
  }
}
