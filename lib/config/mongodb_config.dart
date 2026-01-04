/// Configuration MongoDB
///
/// Remplacez la connectionString par votre propre string de connexion MongoDB
class MongoDBConfig {
  // MongoDB Atlas (Cloud) - Remplacez par votre connection string
  static const String connectionString =
      'mongodb+srv://ilyessellami_db_user:Tjv6A7Vs2ACnhGMe@cluster0.gzwsvtz.mongodb.net/occazcar?retryWrites=true&w=majority&appName=Cluster0';

  // MongoDB Local - Décommentez si vous utilisez MongoDB local
  // static const String connectionString = 'mongodb://localhost:27017/occazcar';

  static const String databaseName = 'occazcar';

  // Collections
  static const String usersCollection = 'users';
  static const String vehiclesCollection = 'vehicles';
}


