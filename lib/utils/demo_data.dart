import '../models/demo_vehicle.dart';

class DemoData {
  static final List<Map<String, dynamic>> vehiclesMaps = [
    {
      'marque': 'Renault',
      'modele': 'Clio',
      'annee': 2020,
      'prix': 32000,
      'kilometrage': 45000,
      'carburant': 'Essence',
      'boite': 'Manuelle',
      'ville': 'Tunis',
      'image': 'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=800&q=80',
      'vendeurNom': 'Ahmed Ben Salah',
      'vendeurTel': '+216 98 765 432',
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
      'image': 'https://images.unsplash.com/photo-1603584173870-7f23fdae1b7a?w=800&q=80',
      'vendeurNom': 'Fatma Trabelsi',
      'vendeurTel': '+216 22 456 789',
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
      'image': 'https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=800&q=80',
      'vendeurNom': 'Mohamed Gharbi',
      'vendeurTel': '+216 55 123 456',
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
      'image': 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=800&q=80',
      'vendeurNom': 'Youssef Mansour',
      'vendeurTel': '+216 24 789 123',
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
      'image': 'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=800&q=80',
      'vendeurNom': 'Sami Bouazizi',
      'vendeurTel': '+216 52 345 678',
    },
  ];

  static List<DemoVehicle> getDemoVehicles() {
    return vehiclesMaps.map((map) => DemoVehicle.fromMap(map)).toList();
  }

  static const List<String> carburants = ['Essence', 'Diesel', 'Hybride', 'Électrique'];
  static const List<String> boites = ['Manuelle', 'Automatique'];
  static const List<String> villes = [
    'Tunis',
    'Sfax',
    'Sousse',
    'Nabeul',
    'Monastir',
    'Bizerte',
    'Kairouan'
  ];
}
