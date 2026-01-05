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
