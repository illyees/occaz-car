class DemoVehicle {
  final int? id;
  final String marque;
  final String modele;
  final int annee;
  final double prix;
  final int kilometrage;
  final String carburant;
  final String boite;
  final String ville;
  final String? description;
  final List<String> images;
  final double? latitude;
  final double? longitude;
  final String? status;
  final String? vendeurNom;
  final String? vendeurTelephone;
  final String? vendeurVille;

  DemoVehicle({
    this.id,
    required this.marque,
    required this.modele,
    required this.annee,
    required this.prix,
    required this.kilometrage,
    required this.carburant,
    required this.boite,
    required this.ville,
    this.description,
    this.images = const [],
    this.latitude,
    this.longitude,
    this.status,
    this.vendeurNom,
    this.vendeurTelephone,
    this.vendeurVille,
  });

  // Getter pour l'image principale (compatibilité avec l'ancien code)
  String get image => images.isNotEmpty ? images.first : '';

  factory DemoVehicle.fromMap(Map<String, dynamic> map) {
    return DemoVehicle(
      id: map['id'] as int?,
      marque: map['marque'] as String,
      modele: map['modele'] as String,
      annee: map['annee'] as int,
      prix: (map['prix'] as num).toDouble(),
      kilometrage: map['kilometrage'] as int,
      carburant: map['carburant'] as String,
      boite: map['boite'] as String,
      ville: map['ville'] as String,
      description: map['description'] as String?,
      images: map['image'] != null ? [map['image'] as String] : [],
      status: map['status'] as String?,
    );
  }

  factory DemoVehicle.fromJson(Map<String, dynamic> json) {
    List<String> imageList = [];
    
    // Gérer les images (peut être un array ou un champ image unique)
    if (json['images'] != null) {
      if (json['images'] is List) {
        imageList = (json['images'] as List).map((e) => e.toString()).toList();
      }
    } else if (json['image'] != null) {
      imageList = [json['image'] as String];
    }
    
    return DemoVehicle(
      id: json['id'] as int?,
      marque: json['marque'] as String,
      modele: json['modele'] as String,
      annee: json['annee'] as int,
      prix: (json['prix'] is String) 
          ? double.parse(json['prix']) 
          : (json['prix'] as num).toDouble(),
      kilometrage: json['kilometrage'] as int,
      carburant: json['carburant'] as String,
      boite: json['boite'] as String,
      ville: json['ville'] as String,
      description: json['description'] as String?,
      images: imageList,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      status: json['status'] as String?,
      vendeurNom: json['vendeur_nom'] as String?,
      vendeurTelephone: json['vendeur_telephone'] as String?,
      vendeurVille: json['vendeur_ville'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'marque': marque,
      'modele': modele,
      'annee': annee,
      'prix': prix,
      'kilometrage': kilometrage,
      'carburant': carburant,
      'boite': boite,
      'ville': ville,
      'description': description,
      'image': image,
      'images': images,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'marque': marque,
      'modele': modele,
      'annee': annee,
      'prix': prix,
      'kilometrage': kilometrage,
      'carburant': carburant,
      'boite': boite,
      'ville': ville,
      'description': description,
      'images': images,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
    };
  }

  String get fullName => '$marque $modele';
  String get priceFormatted => '${prix.toStringAsFixed(0)} DT';
  String get kmFormatted => '$kilometrage km';
}
