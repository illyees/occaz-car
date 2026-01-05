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
