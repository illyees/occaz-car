class DemoUser {
  final String nom;
  final String email;
  final String telephone;
  final String ville;

  DemoUser({
    required this.nom,
    required this.email,
    required this.telephone,
    required this.ville,
  });

  DemoUser copyWith({
    String? nom,
    String? email,
    String? telephone,
    String? ville,
  }) {
    return DemoUser(
      nom: nom ?? this.nom,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      ville: ville ?? this.ville,
    );
  }
}
