# 🍃 Guide Complet - Configuration MongoDB

## 📋 Vue d'ensemble

Ce guide vous explique comment migrer OccazCar de Firebase vers MongoDB.

---

## 🎯 Option 1 : MongoDB Atlas (Recommandé - Cloud)

### Étape 1 : Créer un compte MongoDB Atlas

1. Allez sur [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Cliquez sur **"Try Free"** ou **"Sign Up"**
3. Créez un compte (gratuit)

### Étape 2 : Créer un Cluster

1. Une fois connecté, cliquez sur **"Build a Database"**
2. Choisissez **"M0 FREE"** (gratuit)
3. Choisissez un **Provider** (AWS, Google Cloud, Azure)
4. Choisissez une **Région** proche de vous
5. Donnez un nom au cluster (ex: `Cluster0`)
6. Cliquez sur **"Create"**

### Étape 3 : Créer un Utilisateur Database

1. Dans **"Database Access"** (menu de gauche)
2. Cliquez sur **"Add New Database User"**
3. Choisissez **"Password"** comme méthode d'authentification
4. Entrez un **username** et **password** (notez-les !)
5. Donnez les permissions **"Atlas admin"** ou **"Read and write to any database"**
6. Cliquez sur **"Add User"**

### Étape 4 : Configurer l'Accès Réseau

1. Dans **"Network Access"** (menu de gauche)
2. Cliquez sur **"Add IP Address"**
3. Pour le développement, cliquez sur **"Allow Access from Anywhere"** (0.0.0.0/0)
   - ⚠️ **Attention** : Pour la production, ajoutez seulement votre IP
4. Cliquez sur **"Confirm"**

### Étape 5 : Obtenir la String de Connexion

1. Dans **"Database"** (menu de gauche)
2. Cliquez sur **"Connect"** sur votre cluster
3. Choisissez **"Connect your application"**
4. Sélectionnez **"Dart"** comme driver
5. Copiez la **connection string** (elle ressemble à) :
   ```
   mongodb+srv://<username>:<password>@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
   ```
6. Remplacez `<username>` et `<password>` par vos identifiants
7. Ajoutez le nom de la base de données :
   ```
   mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/occazcar?retryWrites=true&w=majority
   ```

---

## 🖥️ Option 2 : MongoDB Local (Développement)

### Installation MongoDB Local

#### Windows
1. Téléchargez MongoDB depuis [mongodb.com/download](https://www.mongodb.com/try/download/community)
2. Installez MongoDB
3. MongoDB démarrera automatiquement comme service Windows

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

## 📦 Étape 6 : Installer les Dépendances Flutter

### Mettre à jour pubspec.yaml

Ajoutez ces dépendances :

```yaml
dependencies:
  mongo_dart: ^0.7.0
  crypto: ^3.0.3
  http: ^1.1.0
```

Puis exécutez :
```bash
flutter pub get
```

---

## 🔧 Étape 7 : Configuration de l'Application

### Créer un fichier de configuration

Créez `lib/config/mongodb_config.dart` :

```dart
class MongoDBConfig {
  // Remplacez par votre connection string MongoDB
  static const String connectionString = 
    'mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/occazcar?retryWrites=true&w=majority';
  
  // Ou pour MongoDB local :
  // static const String connectionString = 'mongodb://localhost:27017/occazcar';
  
  static const String databaseName = 'occazcar';
}
```

---

## ✅ Checklist de Configuration

- [ ] Compte MongoDB Atlas créé (ou MongoDB local installé)
- [ ] Cluster créé
- [ ] Utilisateur database créé
- [ ] Accès réseau configuré
- [ ] String de connexion obtenue
- [ ] Dépendances Flutter installées
- [ ] Fichier de configuration créé

---

## 🚀 Prochaines Étapes

Une fois MongoDB configuré, les services MongoDB seront créés pour remplacer les services Firebase.

---

**MongoDB est maintenant prêt ! 🎉**



