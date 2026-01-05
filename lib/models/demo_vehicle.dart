class DemoVehicle {
  final String marque;
  final String modele;
  final int annee;
  final int prix;
  final int kilometrage;
  final String carburant;
  final String boite;
  final String ville;
  final String image;
  final String vendeurNom;
  final String vendeurTel;

  DemoVehicle({
    required this.marque,
    required this.modele,
    required this.annee,
    required this.prix,
    required this.kilometrage,
    required this.carburant,
    required this.boite,
    required this.ville,
    required this.image,
    required this.vendeurNom,
    required this.vendeurTel,
  });

  factory DemoVehicle.fromMap(Map<String, dynamic> map) {
    return DemoVehicle(
      marque: map['marque'] as String,
      modele: map['modele'] as String,
      annee: map['annee'] as int,
      prix: map['prix'] as int,
      kilometrage: map['kilometrage'] as int,
      carburant: map['carburant'] as String,
      boite: map['boite'] as String,
      ville: map['ville'] as String,
      image: map['image'] as String,
      vendeurNom: map['vendeurNom'] as String,
      vendeurTel: map['vendeurTel'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'marque': marque,
      'modele': modele,
      'annee': annee,
      'prix': prix,
      'kilometrage': kilometrage,
      'carburant': carburant,
      'boite': boite,
      'ville': ville,
      'image': image,
      'vendeurNom': vendeurNom,
      'vendeurTel': vendeurTel,
    };
  }

  String get fullName => '$marque $modele';
  String get priceFormatted => '$prix DT';
  String get kmFormatted => '$kilometrage km';
}
