class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final bool isSeller;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    this.isSeller = false,
    required this.createdAt,
  });

  // Factory pour créer depuis un document MongoDB
  factory UserModel.fromMongo(Map<String, dynamic> doc) {
    return UserModel(
      id: doc['_id']?.toString() ?? '',
      email: doc['email'] ?? '',
      name: doc['name'] ?? '',
      phone: doc['phone'] ?? '',
      isSeller: doc['isSeller'] ?? false,
      createdAt: doc['createdAt'] != null
          ? (doc['createdAt'] is String
              ? DateTime.parse(doc['createdAt'])
              : doc['createdAt'])
          : DateTime.now(),
    );
  }

  // Factory pour compatibilité Firestore (si nécessaire)
  factory UserModel.fromFirestore(dynamic doc) {
    Map<String, dynamic> data;
    String docId;
    
    if (doc is Map<String, dynamic>) {
      data = doc;
      docId = doc['_id']?.toString() ?? '';
    } else {
      // Compatibilité avec Firestore DocumentSnapshot
      data = doc.data() as Map<String, dynamic>;
      docId = doc.id;
    }
    
    return UserModel(
      id: docId,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      isSeller: data['isSeller'] ?? false,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] is String
              ? DateTime.parse(data['createdAt'])
              : (data['createdAt'] as dynamic).toDate())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'isSeller': isSeller,
      'createdAt': createdAt.toIso8601String(), // Format ISO pour MongoDB
    };
  }
}
