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

// Services
import 'services/api_auth_service.dart';

// Utils
import 'utils/demo_data.dart';
import 'utils/modern_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize API service and load stored JWT token
  await ApiAuthService().initialize();
  
  runApp(const OccazCarDemo());
}

class OccazCarDemo extends StatelessWidget {
  const OccazCarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OccazCar - Voitures d\'occasion',
      theme: ModernTheme.lightTheme,
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

class _DemoHomeScreenState extends State<DemoHomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isLoggedIn = false;
  List<Map<String, dynamic>> _userVehicles = [];
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  Future<void> _handleAddVehicle() async {
    final result = await Navigator.pushNamed(context, '/add-vehicle');
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _userVehicles.add(result);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Annonce ajoutée avec succès !',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            backgroundColor: ModernTheme.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
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
      const VehiclesListScreen(),
      const Center(child: Text('Recherche (à venir)')),
      MyVehiclesScreen(
        userVehicles: _userVehicles,
        onDelete: _handleDeleteVehicle,
        onAddVehicle: _handleAddVehicle,
      ),
      ProfileScreen(onLogout: _handleLogout),
    ];

    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            gradient: ModernTheme.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: ModernTheme.primaryOrange.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.directions_car_rounded,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'OccazCar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                  tooltip: 'Notifications',
                ),
              ),
            ],
          ),
        ),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          height: 70,
          backgroundColor: Colors.white,
          indicatorColor: ModernTheme.primaryOrange.withOpacity(0.15),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: ModernTheme.darkGray,
              ),
              selectedIcon: ShaderMask(
                shaderCallback: (bounds) => ModernTheme.primaryGradient.createShader(bounds),
                child: const Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                ),
              ),
              label: 'Accueil',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.search_outlined,
                color: ModernTheme.darkGray,
              ),
              selectedIcon: ShaderMask(
                shaderCallback: (bounds) => ModernTheme.primaryGradient.createShader(bounds),
                child: const Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                ),
              ),
              label: 'Rechercher',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.add_circle_outline,
                color: ModernTheme.darkGray,
              ),
              selectedIcon: ShaderMask(
                shaderCallback: (bounds) => ModernTheme.primaryGradient.createShader(bounds),
                child: const Icon(
                  Icons.add_circle_rounded,
                  color: Colors.white,
                ),
              ),
              label: 'Vendre',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person_outline_rounded,
                color: ModernTheme.darkGray,
              ),
              selectedIcon: ShaderMask(
                shaderCallback: (bounds) => ModernTheme.primaryGradient.createShader(bounds),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                ),
              ),
              label: 'Profil',
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _handleAddVehicle,
              elevation: 6,
              backgroundColor: ModernTheme.primaryOrange,
              icon: const Icon(Icons.add_circle_rounded, color: Colors.white),
              label: const Text(
                'Vendre',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            )
          : null,
    );
  }
}
