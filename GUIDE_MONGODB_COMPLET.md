# 🍃 Guide Complet - Migration vers MongoDB

## 📋 Vue d'ensemble

Ce guide vous explique comment migrer OccazCar de Firebase vers MongoDB.

---

## 🎯 Étape 1 : Créer un Compte MongoDB Atlas (Recommandé)

### 1.1 Inscription
1. Allez sur [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Cliquez sur **"Try Free"** ou **"Sign Up"**
3. Créez un compte (gratuit jusqu'à 512 MB)

### 1.2 Créer un Cluster
1. Une fois connecté, cliquez sur **"Build a Database"**
2. Choisissez **"M0 FREE"** (gratuit)
3. Choisissez un **Provider** (AWS, Google Cloud, Azure)
4. Choisissez une **Région** proche de vous
5. Donnez un nom au cluster (ex: `Cluster0`)
6. Cliquez sur **"Create"** (peut prendre 3-5 minutes)

### 1.3 Créer un Utilisateur Database
1. Dans **"Database Access"** (menu de gauche)
2. Cliquez sur **"Add New Database User"**
3. Choisissez **"Password"** comme méthode d'authentification
4. Entrez un **username** (ex: `occazcar_user`)
5. Générez un **password** (ou créez-en un) - **NOTEZ-LE BIEN !**
6. Donnez les permissions **"Atlas admin"** ou **"Read and write to any database"**
7. Cliquez sur **"Add User"**

### 1.4 Configurer l'Accès Réseau
1. Dans **"Network Access"** (menu de gauche)
2. Cliquez sur **"Add IP Address"**
3. Pour le développement, cliquez sur **"Allow Access from Anywhere"** (0.0.0.0/0)
   - ⚠️ **Attention** : Pour la production, ajoutez seulement votre IP
4. Cliquez sur **"Confirm"**

### 1.5 Obtenir la String de Connexion
1. Dans **"Database"** (menu de gauche)
2. Cliquez sur **"Connect"** sur votre cluster
3. Choisissez **"Connect your application"**
4. Sélectionnez **"Dart"** comme driver
5. Copiez la **connection string** (elle ressemble à) :
   ```
   mongodb+srv://<username>:<password>@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
   ```
6. **Remplacez** :
   - `<username>` par votre nom d'utilisateur
   - `<password>` par votre mot de passe
7. **Ajoutez** le nom de la base de données à la fin :
   ```
   mongodb+srv://occazcar_user:VOTRE_MOT_DE_PASSE@cluster0.xxxxx.mongodb.net/occazcar?retryWrites=true&w=majority
   ```

---

## 🖥️ Option 2 : MongoDB Local (Alternative)

### Installation MongoDB Local

#### Windows
1. Téléchargez depuis [mongodb.com/download](https://www.mongodb.com/try/download/community)
2. Installez MongoDB
3. MongoDB démarrera automatiquement comme service

#### macOS
```bash
brew tap mongodb/brew
brew install mongodb-community
brew services start mongodb-community
```

#### Linux
```bash
# Ubuntu/Debian
sudo apt-get install mongodb

# Ou avec Docker
docker run -d -p 27017:27017 --name mongodb mongo
```

### String de Connexion Locale
```
mongodb://localhost:27017/occazcar
```

---

## 📦 Étape 2 : Installer les Dépendances Flutter

### 2.1 Mettre à jour pubspec.yaml
Les dépendances MongoDB ont déjà été ajoutées. Exécutez :

```bash
cd occaz_car-main
flutter pub get
```

### 2.2 Vérifier l'installation
```bash
flutter pub get
```

---

## ⚙️ Étape 3 : Configurer la Connexion MongoDB

### 3.1 Modifier mongodb_config.dart
Ouvrez `lib/config/mongodb_config.dart` et remplacez la connection string :

```dart
class MongoDBConfig {
  // Remplacez par VOTRE connection string MongoDB Atlas
  static const String connectionString = 
    'mongodb+srv://VOTRE_USERNAME:VOTRE_PASSWORD@cluster0.xxxxx.mongodb.net/occazcar?retryWrites=true&w=majority';
  
  // OU pour MongoDB local, décommentez :
  // static const String connectionString = 'mongodb://localhost:27017/occazcar';
  
  static const String databaseName = 'occazcar';
}
```

**⚠️ IMPORTANT** : Remplacez `VOTRE_USERNAME` et `VOTRE_PASSWORD` par vos vrais identifiants !

---

## 🔄 Étape 4 : Mettre à jour les Écrans

Les écrans détectent automatiquement les services MongoDB. Assurez-vous que les écrans utilisent les services MongoDB quand disponibles.

---

## 🚀 Étape 5 : Lancer l'Application avec MongoDB

### 5.1 Lancer avec MongoDB
```bash
cd occaz_car-main
flutter run -t lib/main_mongodb.dart
```

### 5.2 Ou modifier main.dart
Vous pouvez aussi modifier `lib/main.dart` pour utiliser MongoDB par défaut :

```dart
import 'services/mongodb_auth_service.dart';
import 'services/mongodb_database_service.dart';
import 'services/mongodb_storage_service.dart';

// Dans MultiProvider :
ChangeNotifierProvider(create: (_) => MongoDBAuthService()),
Provider(create: (_) => MongoDBDatabaseService()),
Provider(create: (_) => MongoDBStorageService()),
```

---

## 📝 Étape 6 : Tester l'Application

### 6.1 Créer un compte
1. Lancer l'application
2. Cliquer sur "S'inscrire"
3. Remplir le formulaire
4. Vérifier dans MongoDB Atlas que l'utilisateur a été créé

### 6.2 Vérifier dans MongoDB Atlas
1. Dans MongoDB Atlas → **"Database"**
2. Cliquez sur **"Browse Collections"**
3. Vous devriez voir :
   - Collection `users` avec vos utilisateurs
   - Collection `vehicles` avec les véhicules

---

## 🖼️ Étape 7 : Configuration du Stockage d'Images

### Option A : MongoDB GridFS (Inclus)
Le service `MongoDBStorageService` utilise GridFS pour stocker les images.

### Option B : ImgBB (Recommandé - Gratuit)
1. Allez sur [imgbb.com](https://imgbb.com/)
2. Créez un compte gratuit
3. Obtenez votre clé API
4. Modifiez `lib/services/mongodb_storage_service.dart` :
   ```dart
   class ImgBBStorageService {
     static const String apiKey = 'VOTRE_CLE_API_IMGBB';
   }
   ```

### Option C : Cloudinary (Gratuit jusqu'à 25 GB)
1. Créez un compte sur [cloudinary.com](https://cloudinary.com/)
2. Obtenez vos credentials
3. Utilisez le package `cloudinary_flutter`

---

## ✅ Checklist de Configuration

- [ ] Compte MongoDB Atlas créé (ou MongoDB local installé)
- [ ] Cluster créé et démarré
- [ ] Utilisateur database créé
- [ ] Accès réseau configuré (0.0.0.0/0 pour dev)
- [ ] Connection string obtenue
- [ ] `mongodb_config.dart` configuré avec votre connection string
- [ ] Dépendances Flutter installées (`flutter pub get`)
- [ ] Application testée (`flutter run -t lib/main_mongodb.dart`)

---

## 🐛 Résolution de Problèmes

### Erreur : "Connection refused"
**Solution** : 
- Vérifiez que MongoDB Atlas est accessible (Network Access configuré)
- Vérifiez votre connection string
- Vérifiez que le cluster est démarré

### Erreur : "Authentication failed"
**Solution** :
- Vérifiez votre username et password dans la connection string
- Vérifiez que l'utilisateur database existe

### Erreur : "Package mongo_dart not found"
**Solution** :
```bash
flutter clean
flutter pub get
```

### Erreur : "Timeout"
**Solution** :
- Vérifiez votre connexion internet
- Vérifiez que MongoDB Atlas est accessible
- Essayez de redémarrer le cluster

---

## 📊 Structure des Collections MongoDB

### Collection `users`
```json
{
  "_id": ObjectId("..."),
  "email": "user@example.com",
  "password": "hashed_password",
  "name": "John Doe",
  "phone": "0612345678",
  "isSeller": false,
  "createdAt": "2025-01-04T21:00:00Z"
}
```

### Collection `vehicles`
```json
{
  "_id": ObjectId("..."),
  "sellerId": "user_id",
  "sellerName": "John Doe",
  "sellerPhone": "0612345678",
  "brand": "Renault",
  "model": "Clio",
  "year": 2020,
  "mileage": 50000,
  "price": 12000,
  "description": "...",
  "images": ["url1", "url2"],
  "latitude": 48.8566,
  "longitude": 2.3522,
  "location": "Paris",
  "createdAt": "2025-01-04T21:00:00Z",
  "status": "active"
}
```

---

## 🔒 Sécurité

### ⚠️ Important
- **Ne commitez JAMAIS** votre connection string avec le mot de passe dans Git
- Utilisez des variables d'environnement pour la production
- Changez les mots de passe régulièrement
- En production, limitez l'accès réseau à votre IP uniquement

### Variables d'Environnement (Recommandé)
Créez un fichier `.env` (ajoutez-le à `.gitignore`) :
```
MONGODB_CONNECTION_STRING=mongodb+srv://...
```

Puis utilisez le package `flutter_dotenv` pour le charger.

---

## 📚 Ressources

- [MongoDB Atlas Documentation](https://docs.atlas.mongodb.com/)
- [mongo_dart Package](https://pub.dev/packages/mongo_dart)
- [MongoDB University](https://university.mongodb.com/) (Cours gratuits)

---

## 🎯 Prochaines Étapes

1. **Tester toutes les fonctionnalités** avec MongoDB
2. **Configurer le stockage d'images** (ImgBB recommandé)
3. **Optimiser les requêtes** si nécessaire
4. **Configurer les index** dans MongoDB pour améliorer les performances

---

**Votre application est maintenant configurée avec MongoDB ! 🎉**



