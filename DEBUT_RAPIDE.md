# 🚀 Démarrage Rapide - OccazCar

## Étapes rapides pour tester l'application

### 1️⃣ Vérifier Flutter
```bash
flutter doctor
```

### 2️⃣ Installer les dépendances
```bash
cd occaz_car-main
flutter pub get
```

### 3️⃣ Configurer Firebase (IMPORTANT)

#### Option A : Configuration automatique (Recommandé)
```bash
# Installer FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurer Firebase
flutterfire configure
```

Suivez les instructions :
- Sélectionnez votre projet Firebase
- Choisissez les plateformes (Android, iOS, Web, etc.)

#### Option B : Configuration manuelle
Si vous avez déjà un projet Firebase configuré, assurez-vous que :
- `android/app/google-services.json` existe
- `ios/Runner/GoogleService-Info.plist` existe (pour iOS)
- Le fichier `lib/firebase_options.dart` est généré

### 4️⃣ Lancer l'application
```bash
# Voir les appareils disponibles
flutter devices

# Lancer l'app
flutter run
```

---

## ⚡ Commandes utiles

```bash
# Nettoyer le projet
flutter clean

# Réinstaller les dépendances
flutter pub get

# Vérifier les erreurs
flutter analyze

# Construire l'APK (Android)
flutter build apk

# Construire pour iOS
flutter build ios
```

---

## 🔥 Configuration Firebase minimale

### Dans Firebase Console :

1. **Authentication** → Activer "Email/Password"
2. **Firestore** → Créer en mode test
3. **Storage** → Activer

### Règles Firestore (copier-coller) :
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

### Règles Storage (copier-coller) :
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /vehicles/{userId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth.uid == userId;
    }
  }
}
```

---

## ✅ Test rapide

1. **Lancer l'app** : `flutter run`
2. **Créer un compte** : Email + Mot de passe
3. **Ajouter un véhicule** (si vendeur) : Bouton + → Photos → Détails → Publier
4. **Parcourir les véhicules** : Liste principale
5. **Rechercher** : Icône de recherche → Filtres

---

## 🐛 Problème courant : "Firebase not initialized"

**Solution** :
```bash
flutterfire configure
```

Si ça ne marche pas :
1. Vérifiez que vous êtes connecté à Firebase
2. Vérifiez que le projet Firebase existe
3. Vérifiez que `lib/firebase_options.dart` existe après la configuration

---

## 📱 Tester sur différents appareils

```bash
# Android
flutter run -d android

# iOS (Mac uniquement)
flutter run -d ios

# Web
flutter run -d chrome

# Windows
flutter run -d windows
```

---

**Besoin d'aide ?** Consultez `GUIDE_TEST.md` pour plus de détails.









