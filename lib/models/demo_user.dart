class DemoUser {
  final int? id;
  final String nom;
  final String email;
  final String telephone;
  final String ville;
  final String? role;
  final String? photoUrl;

  DemoUser({
    this.id,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.ville,
    this.role,
    this.photoUrl,
  });

  DemoUser copyWith({
    int? id,
    String? nom,
    String? email,
    String? telephone,
    String? ville,
    String? role,
    String? photoUrl,
  }) {
    return DemoUser(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      ville: ville ?? this.ville,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  // Conversion depuis JSON
  factory DemoUser.fromJson(Map<String, dynamic> json) {
    return DemoUser(
      id: json['id'] as int?,
      nom: json['nom'] as String,
      email: json['email'] as String,
      telephone: json['telephone'] as String? ?? '',
      ville: json['ville'] as String? ?? '',
      role: json['role'] as String?,
      photoUrl: json['photo_url'] as String?,
    );
  }

  // Conversion vers JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
      'telephone': telephone,
      'ville': ville,
      'role': role,
      'photo_url': photoUrl,
    };
  }
}
