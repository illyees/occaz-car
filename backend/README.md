# Backend MySQL - OccazCar

Backend Node.js avec Express et MySQL pour l'application OccazCar.

## 📋 Prérequis

- Node.js (v14 ou supérieur)
- MySQL (v5.7 ou supérieur)
- npm ou yarn

## 🚀 Installation

### 1. Installer les dépendances

```bash
cd backend
npm install
```

### 2. Configuration de la base de données MySQL

#### a. Créer la base de données

Connectez-vous à MySQL:

```bash
mysql -u root -p
```

Créer la base de données:

```sql
CREATE DATABASE occazcar_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

#### b. Importer le schéma

```bash
mysql -u root -p occazcar_db < database/schema.sql
```

Ou directement depuis MySQL:

```sql
USE occazcar_db;
SOURCE database/schema.sql;
```

### 3. Configuration de l'environnement

Créer un fichier `.env` à partir de `.env.example`:

```bash
cp .env.example .env
```

Éditer `.env` avec vos paramètres MySQL:

```env
# Configuration MySQL
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=votre_mot_de_passe
DB_NAME=occazcar_db
DB_PORT=3306

# Configuration JWT
JWT_SECRET=votre_secret_jwt_tres_securise

# Configuration serveur
PORT=3000
NODE_ENV=development
```

## 🏃 Lancer le serveur

### Mode développement

```bash
npm start
```

Le serveur démarre sur `http://localhost:3000`

### Mode production

```bash
NODE_ENV=production npm start
```

## 📡 API Endpoints

### Authentification

| Méthode | Endpoint             | Description             | Auth Required |
| ------- | -------------------- | ----------------------- | ------------- |
| POST    | `/api/auth/register` | Inscription utilisateur | Non           |
| POST    | `/api/auth/login`    | Connexion utilisateur   | Non           |
| GET     | `/api/auth/profile`  | Récupérer profil        | Oui           |
| PUT     | `/api/auth/profile`  | Modifier profil         | Oui           |

### Véhicules

| Méthode | Endpoint                | Description        | Auth Required |
| ------- | ----------------------- | ------------------ | ------------- |
| POST    | `/api/vehicles`         | Créer annonce      | Oui           |
| GET     | `/api/vehicles`         | Liste véhicules    | Non           |
| GET     | `/api/vehicles/:id`     | Détails véhicule   | Non           |
| GET     | `/api/vehicles/user/me` | Mes véhicules      | Oui           |
| PUT     | `/api/vehicles/:id`     | Modifier véhicule  | Oui           |
| DELETE  | `/api/vehicles/:id`     | Supprimer véhicule | Oui           |

## 📝 Exemples d'utilisation

### Inscription

```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "nom": "Ahmed Ben Ali",
    "email": "ahmed@example.com",
    "password": "motdepasse123",
    "telephone": "+216 20 123 456",
    "ville": "Tunis"
  }'
```

### Connexion

```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "ahmed@example.com",
    "password": "motdepasse123"
  }'
```

Réponse:

```json
{
  "message": "Connexion réussie",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "nom": "Ahmed Ben Ali",
    "email": "ahmed@example.com",
    "telephone": "+216 20 123 456",
    "ville": "Tunis",
    "role": "both"
  }
}
```

### Créer une annonce (avec token)

```bash
curl -X POST http://localhost:3000/api/vehicles \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "marque": "Renault",
    "modele": "Clio 4",
    "annee": 2018,
    "prix": 28000,
    "kilometrage": 85000,
    "carburant": "Diesel",
    "boite": "Manuelle",
    "ville": "Tunis",
    "description": "Voiture en excellent état",
    "images": ["url1.jpg", "url2.jpg"]
  }'
```

### Récupérer tous les véhicules

```bash
curl http://localhost:3000/api/vehicles
```

### Filtrer les véhicules

```bash
curl "http://localhost:3000/api/vehicles?ville=Tunis&carburant=Diesel&minPrix=20000&maxPrix=40000"
```

## 🗄️ Structure de la base de données

### Table `users`

- `id` - Identifiant unique
- `nom` - Nom de l'utilisateur
- `email` - Email (unique)
- `password` - Mot de passe hashé
- `telephone` - Numéro de téléphone
- `ville` - Ville de résidence
- `role` - Rôle (buyer, seller, both)
- `photo_url` - URL de la photo de profil
- `created_at` - Date de création
- `updated_at` - Date de modification

### Table `vehicles`

- `id` - Identifiant unique
- `user_id` - ID du vendeur (FK vers users)
- `marque` - Marque du véhicule
- `modele` - Modèle
- `annee` - Année
- `prix` - Prix en DT
- `kilometrage` - Kilométrage
- `carburant` - Type de carburant
- `boite` - Type de boîte
- `ville` - Localisation
- `description` - Description
- `images` - Array JSON des URLs d'images
- `latitude/longitude` - Coordonnées GPS
- `status` - Statut (active, sold, inactive)
- `created_at` - Date de création
- `updated_at` - Date de modification

### Table `favorites`

- `id` - Identifiant unique
- `user_id` - ID de l'utilisateur
- `vehicle_id` - ID du véhicule
- `created_at` - Date d'ajout

### Table `vehicle_history`

- `id` - Identifiant unique
- `vehicle_id` - ID du véhicule
- `type` - Type (maintenance, reparation, accident)
- `titre` - Titre de l'événement
- `description` - Description
- `date` - Date de l'événement
- `cout` - Coût
- `created_at` - Date de création

## 🔒 Sécurité

- Mots de passe hashés avec bcrypt (10 rounds)
- Authentification JWT (expiration 7 jours)
- Validation des données d'entrée
- Protection CORS
- Routes protégées par middleware d'authentification

## 🐛 Débogage

### Vérifier la connexion MySQL

```bash
mysql -u root -p -e "SELECT 1"
```

### Logs du serveur

Les logs s'affichent dans la console. Pour plus de détails:

```bash
DEBUG=* npm start
```

### Tester les endpoints

Utiliser Postman ou le fichier de test:

```bash
# Installer httpie
pip install httpie

# Tester l'API
http GET http://localhost:3000/
```

## 📚 Technologies utilisées

- **Express.js** - Framework web
- **MySQL2** - Driver MySQL avec support des Promises
- **bcryptjs** - Hachage de mots de passe
- **jsonwebtoken** - Authentification JWT
- **cors** - Gestion CORS
- **dotenv** - Variables d'environnement
- **body-parser** - Parsing des requêtes

## 👥 Support

Pour toute question ou problème, contactez l'équipe de développement.

## 📄 Licence

Ce projet est développé pour OccazCar © 2024
