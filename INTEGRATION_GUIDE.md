# 🚀 Guide d'Intégration MySQL - OccazCar

Ce guide vous aide à connecter l'application Flutter OccazCar avec le backend MySQL.

## 📦 Ce qui a été créé

### Backend (Node.js + Express + MySQL)

```
backend/
├── config/
│   └── database.js           # Configuration connexion MySQL
├── database/
│   └── schema.sql            # Schéma de base de données
├── server.js                 # API REST avec tous les endpoints
├── package.json              # Dépendances Node.js
├── .env.example              # Template configuration
├── README.md                 # Documentation backend
└── setup-guide.json          # Guide de dépannage
```

### Services Flutter (API Integration)

```
lib/services/
├── api_auth_service.dart     # Service d'authentification API
└── api_vehicle_service.dart  # Service de gestion des véhicules API
```

### Modèles mis à jour

```
lib/models/
├── demo_user.dart            # Modèle utilisateur avec JSON support
└── demo_vehicle.dart         # Modèle véhicule avec JSON support
```

## 🔧 Installation pas à pas

### Étape 1: Installer MySQL

#### Windows

1. Télécharger MySQL: https://dev.mysql.com/downloads/mysql/
2. Installer MySQL Server (noter le mot de passe root)
3. Démarrer le service MySQL:
   ```powershell
   net start MySQL80
   ```

#### Vérifier l'installation

```powershell
mysql --version
```

### Étape 2: Créer la base de données

1. Se connecter à MySQL:

   ```powershell
   mysql -u root -p
   ```

2. Créer la base de données:

   ```sql
   CREATE DATABASE occazcar_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   exit;
   ```

3. Importer le schéma:
   ```powershell
   cd backend
   mysql -u root -p occazcar_db < database/schema.sql
   ```

### Étape 3: Configurer le backend Node.js

1. Installer Node.js si nécessaire: https://nodejs.org/

2. Installer les dépendances:

   ```powershell
   cd backend
   npm install
   ```

3. Créer le fichier `.env`:

   ```powershell
   copy .env.example .env
   ```

4. Éditer `.env` avec vos paramètres:

   ```env
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=votre_mot_de_passe_mysql
   DB_NAME=occazcar_db
   DB_PORT=3306

   JWT_SECRET=occazcar_secret_key_2024
   PORT=3000
   ```

### Étape 4: Démarrer le serveur backend

```powershell
cd backend
npm start
```

Vous devriez voir:

```
✅ Serveur OccazCar démarré sur le port 3000
🔗 API disponible sur http://localhost:3000
✅ Connexion à la base de données MySQL réussie
```

### Étape 5: Installer les dépendances Flutter

```powershell
cd ..
flutter pub get
```

Cela installera:

- `http: ^1.1.0` - Pour les requêtes HTTP
- `shared_preferences: ^2.2.2` - Pour le stockage local du token

### Étape 6: Tester l'API

#### Tester avec curl (depuis PowerShell)

1. Test de santé du serveur:

   ```powershell
   curl http://localhost:3000
   ```

2. Inscription d'un utilisateur:

   ```powershell
   curl -X POST http://localhost:3000/api/auth/register -H "Content-Type: application/json" -d '{\"nom\":\"Test User\",\"email\":\"test@test.com\",\"password\":\"test123\",\"telephone\":\"+216 20 123 456\",\"ville\":\"Tunis\"}'
   ```

3. Connexion:
   ```powershell
   curl -X POST http://localhost:3000/api/auth/login -H "Content-Type: application/json" -d '{\"email\":\"test@test.com\",\"password\":\"test123\"}'
   ```

## 🔄 Prochaines étapes: Intégrer l'API dans Flutter

### Option 1: Modifier les écrans existants

Remplacer les services mock par les services API dans:

- `lib/screens/login_screen.dart`
- `lib/screens/add_vehicle_screen.dart`
- `lib/widgets/vehicles_list_screen.dart`
- etc.

Exemple pour `login_screen.dart`:

```dart
import '../services/api_auth_service.dart';

// Remplacer:
// final mockUser = DemoUser(...);

// Par:
final authService = ApiAuthService();
final result = await authService.login(
  email: emailController.text,
  password: passwordController.text,
);

if (result['success']) {
  Navigator.pushReplacement(...);
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(result['message'])),
  );
}
```

### Option 2: Configuration de l'URL de l'API

Pour tester depuis un appareil mobile, modifier dans les services:

```dart
// Dans api_auth_service.dart et api_vehicle_service.dart
static const String baseUrl = 'http://VOTRE_IP_LOCALE:3000/api';
// Par exemple: 'http://192.168.1.100:3000/api'
```

Pour trouver votre IP locale:

```powershell
ipconfig
```

Chercher "Adresse IPv4" dans la section WiFi ou Ethernet.

## 📊 Structure de la base de données

### Table `users`

| Champ      | Type         | Description                |
| ---------- | ------------ | -------------------------- |
| id         | INT          | ID unique (auto-increment) |
| nom        | VARCHAR(100) | Nom complet                |
| email      | VARCHAR(255) | Email (unique)             |
| password   | VARCHAR(255) | Mot de passe hashé         |
| telephone  | VARCHAR(20)  | Numéro de téléphone        |
| ville      | VARCHAR(100) | Ville de résidence         |
| role       | ENUM         | buyer, seller, both        |
| photo_url  | VARCHAR(500) | URL photo de profil        |
| created_at | TIMESTAMP    | Date de création           |
| updated_at | TIMESTAMP    | Date de modification       |

### Table `vehicles`

| Champ       | Type          | Description                          |
| ----------- | ------------- | ------------------------------------ |
| id          | INT           | ID unique                            |
| user_id     | INT           | FK vers users                        |
| marque      | VARCHAR(100)  | Marque du véhicule                   |
| modele      | VARCHAR(100)  | Modèle                               |
| annee       | INT           | Année de fabrication                 |
| prix        | DECIMAL(10,2) | Prix en DT                           |
| kilometrage | INT           | Kilométrage                          |
| carburant   | ENUM          | Essence, Diesel, Hybride, Électrique |
| boite       | ENUM          | Manuelle, Automatique                |
| ville       | VARCHAR(100)  | Localisation                         |
| description | TEXT          | Description détaillée                |
| images      | TEXT          | JSON array des URLs d'images         |
| latitude    | DECIMAL(10,8) | Coordonnée GPS                       |
| longitude   | DECIMAL(11,8) | Coordonnée GPS                       |
| status      | ENUM          | active, sold, inactive               |
| created_at  | TIMESTAMP     | Date de création                     |

## 🔒 Authentification JWT

### Comment ça marche ?

1. **Inscription/Connexion**: L'utilisateur s'inscrit ou se connecte
2. **Token JWT**: Le serveur génère un token JWT (valide 7 jours)
3. **Stockage local**: Le token est sauvegardé avec `shared_preferences`
4. **Requêtes protégées**: Le token est envoyé dans l'en-tête `Authorization: Bearer {token}`

### Exemple de token décodé

```json
{
  "id": 1,
  "email": "user@example.com",
  "iat": 1234567890,
  "exp": 1235172690
}
```

## 🧪 Tests et Débogage

### Vérifier la connexion MySQL

```sql
mysql -u root -p
USE occazcar_db;
SHOW TABLES;
SELECT * FROM users;
```

### Tester les endpoints avec Postman

1. Télécharger Postman: https://www.postman.com/downloads/
2. Importer la collection (créer les requêtes)
3. Tester chaque endpoint

### Logs du serveur

Le serveur affiche tous les logs dans la console. En cas d'erreur:

- Vérifier la connexion MySQL
- Vérifier le format des données JSON
- Vérifier le token JWT pour les routes protégées

## ⚠️ Problèmes courants

### "ECONNREFUSED" - Connexion refusée

**Cause**: MySQL n'est pas démarré ou mauvais port

**Solution**:

```powershell
net start MySQL80
# Vérifier le port dans .env (par défaut 3306)
```

### "Access denied for user"

**Cause**: Mauvais identifiants MySQL

**Solution**: Vérifier `DB_USER` et `DB_PASSWORD` dans `.env`

### "Cannot find module 'express'"

**Cause**: Dépendances non installées

**Solution**:

```powershell
cd backend
npm install
```

### "ER_BAD_DB_ERROR: Unknown database"

**Cause**: Base de données non créée

**Solution**:

```powershell
mysql -u root -p -e "CREATE DATABASE occazcar_db;"
mysql -u root -p occazcar_db < database/schema.sql
```

## 📱 Configuration pour Web/Mobile

### Pour tester sur Chrome (localhost)

L'URL `http://localhost:3000` fonctionne directement.

### Pour tester sur Android Emulator

Utiliser l'IP spéciale de l'émulateur:

```dart
static const String baseUrl = 'http://10.0.2.2:3000/api';
```

### Pour tester sur appareil physique

1. Trouver l'IP de votre PC:

   ```powershell
   ipconfig
   ```

2. Utiliser cette IP dans les services:

   ```dart
   static const String baseUrl = 'http://192.168.1.X:3000/api';
   ```

3. Autoriser le firewall Windows:
   - Chercher "Pare-feu Windows"
   - Ajouter une règle entrante pour le port 3000

## 🎯 Fonctionnalités disponibles

### Authentification

- ✅ Inscription avec validation email unique
- ✅ Connexion avec JWT
- ✅ Récupération/Modification du profil
- ✅ Stockage sécurisé du token

### Gestion des véhicules

- ✅ Créer une annonce (avec authentification)
- ✅ Lister tous les véhicules (public)
- ✅ Filtrer par ville, marque, prix, carburant, boîte
- ✅ Détails d'un véhicule
- ✅ Mes véhicules (utilisateur connecté)
- ✅ Modifier/Supprimer mes véhicules

### Sécurité

- ✅ Mots de passe hashés avec bcrypt
- ✅ Tokens JWT avec expiration
- ✅ Middleware d'authentification
- ✅ Validation des données
- ✅ Protection CORS

## 📚 Ressources additionnelles

- [Documentation Express.js](https://expressjs.com/)
- [Documentation MySQL](https://dev.mysql.com/doc/)
- [Documentation JWT](https://jwt.io/)
- [Documentation Flutter HTTP](https://pub.dev/packages/http)
- [Documentation Shared Preferences](https://pub.dev/packages/shared_preferences)

## 🤝 Support

Si vous rencontrez des problèmes:

1. Vérifier les logs du serveur backend
2. Vérifier la console de l'application Flutter
3. Consulter le fichier `backend/setup-guide.json`
4. Relire cette documentation

## ✅ Checklist de vérification

Avant de lancer l'application complète:

- [ ] MySQL est installé et démarré
- [ ] Base de données `occazcar_db` créée avec le schéma
- [ ] Dépendances Node.js installées (`npm install`)
- [ ] Fichier `.env` configuré avec les bons identifiants
- [ ] Serveur backend démarré et accessible sur port 3000
- [ ] Dépendances Flutter installées (`flutter pub get`)
- [ ] Services API créés et importés dans les écrans
- [ ] URL de l'API correcte selon votre environnement (localhost/IP)

Bon développement ! 🚀
