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
      'images': [
        'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=800&q=80',
        'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=800&q=80',
        'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800&q=80',
        'https://images.unsplash.com/photo-1600705722909-15c174ac2eb0?w=800&q=80',
      ],
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
      'images': [
        'https://images.unsplash.com/photo-1603584173870-7f23fdae1b7a?w=800&q=80',
        'https://images.unsplash.com/photo-1614200187524-dc4b892acf16?w=800&q=80',
        'https://images.unsplash.com/photo-1502877338535-766e1452684a?w=800&q=80',
        'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=800&q=80',
      ],
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
      'images': [
        'https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=800&q=80',
        'https://images.unsplash.com/photo-1619405399517-d7fce0f13302?w=800&q=80',
        'https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=800&q=80',
        'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=800&q=80',
      ],
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
      'images': [
        'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=800&q=80',
        'https://images.unsplash.com/photo-1627454820516-eb49ba9d9e0e?w=800&q=80',
        'https://images.unsplash.com/photo-1629897048514-3dd7414fe72a?w=800&q=80',
        'https://images.unsplash.com/photo-1623869675781-80aa31012a5a?w=800&q=80',
      ],
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
      'images': [
        'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=800&q=80',
        'https://images.unsplash.com/photo-1617814076367-b759c7d7e738?w=800&q=80',
        'https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=800&q=80',
        'https://images.unsplash.com/photo-1617531653332-bd46c24f2068?w=800&q=80',
      ],
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
