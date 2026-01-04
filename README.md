# OccazCar - Application de Petites Annonces de Véhicules

Application mobile Flutter pour la vente et l'achat de véhicules d'occasion.

##  Fonctionnalités

### Pour les Acheteurs
-  Recherche avancée avec filtres (marque, prix, année)
-  Liste de véhicules avec photos
-  Localisation GPS des véhicules
-  Contact direct avec le vendeur (appel/SMS)
-  Carte interactive (Google Maps)

### Pour les Vendeurs
-  Publication d'annonces avec photos multiples
-  Modification des annonces
-  Suppression des annonces
-  Gestion de toutes ses annonces

### Général
-  Authentification sécurisée (Firebase Auth)
-  Gestion de profil
-  Interface moderne et intuitive
-  Design responsive

## Technologies Utilisées

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase
  - Authentication
  - Firestore Database
  - Storage
- **State Management**: Provider
- **Maps**: Google Maps Flutter
- **UI**: Material Design 3

##  Installation

### Prérequis

- Flutter SDK (>= 3.0.0)
- Dart SDK
- Android Studio 
- Compte Firebase

### Étapes d'installation

1. **Cloner le repository**
```bash
git clone https://github.com/VOTRE_USERNAME/occaz_car.git
cd occaz_car
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configuration Firebase**

Créez un projet Firebase et activez :
- Authentication (Email/Password)
- Firestore Database
- Storage

Puis configurez FlutterFire :
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

4. **Lancer l'application**
```bash
flutter run
```

##  Structure du Projet
```
lib/
├── main.dart
├── utils/
│   └── app_theme.dart
├── models/
│   ├── user_model.dart
│   └── vehicle_model.dart
├── services/
│   ├── auth_service.dart
│   ├── database_service.dart
│   └── storage_service.dart
└── screens/
    ├── auth/
    ├── buyer/
    ├── seller/
    └── profile/
```

## Configuration Firebase

### Règles Firestore
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if true;
      allow write: if request.auth.uid == userId;
    }
    match /vehicles/{vehicleId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.sellerId;
    }
  }
}
```
#### Règles Storage
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /vehicles/{userId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth.uid == userId;
    }
  }
}
