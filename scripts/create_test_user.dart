import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Script pour créer un utilisateur de test dans MongoDB
/// 
/// Usage: dart scripts/create_test_user.dart
void main() async {
  // Remplacez par votre connection string MongoDB
  const connectionString = 
    'mongodb+srv://ilyessellami_db_user:Tjv6A7Vs2ACnhGMe@cluster0.gzwsvtz.mongodb.net/occazcar?retryWrites=true&w=majority&appName=Cluster0';
  
  const dbName = 'occazcar';
  const usersCollection = 'users';
  
  // Informations de l'utilisateur de test
  const testEmail = 'test@occazcar.com';
  const testPassword = 'test123';
  const testName = 'Utilisateur Test';
  const testPhone = '+33612345678';
  const isSeller = false; // true pour un vendeur
  
  try {
    print('🔌 Connexion à MongoDB...');
    final db = await Db.create(connectionString);
    await db.open();
    print('✅ Connecté à MongoDB');
    
    final collection = db.collection(usersCollection);
    
    // Vérifier si l'utilisateur existe déjà
    final existingUser = await collection.findOne(where.eq('email', testEmail));
    if (existingUser != null) {
      print('⚠️  L\'utilisateur $testEmail existe déjà !');
      print('   Vous pouvez vous connecter avec :');
      print('   Email: $testEmail');
      print('   Mot de passe: $testPassword');
      await db.close();
      exit(0);
    }
    
    // Hasher le mot de passe
    final bytes = utf8.encode(testPassword);
    final digest = sha256.convert(bytes);
    final hashedPassword = digest.toString();
    
    // Créer l'utilisateur
    final userId = ObjectId();
    final userJson = {
      '_id': userId,
      'email': testEmail,
      'password': hashedPassword,
      'name': testName,
      'phone': testPhone,
      'isSeller': isSeller,
      'createdAt': DateTime.now().toIso8601String(),
    };
    
    await collection.insert(userJson);
    print('✅ Utilisateur créé avec succès !');
    print('');
    print('📧 Informations de connexion :');
    print('   Email: $testEmail');
    print('   Mot de passe: $testPassword');
    print('   Type: ${isSeller ? "Vendeur" : "Acheteur"}');
    print('');
    print('🚀 Vous pouvez maintenant vous connecter à l\'application !');
    
    await db.close();
  } catch (e) {
    print('❌ Erreur: $e');
    exit(1);
  }
}



