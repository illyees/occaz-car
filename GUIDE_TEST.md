# Guide de Test - OccazCar

## 📋 Prérequis

### 1. Installer Flutter
- Téléchargez Flutter depuis [flutter.dev](https://flutter.dev/docs/get-started/install)
- Vérifiez l'installation :
```bash
flutter doctor
```

### 2. Installer les outils nécessaires
- **Android Studio** (pour Android) ou **Xcode** (pour iOS/Mac)
- **VS Code** ou **Android Studio** comme IDE
- **Git** (déjà installé normalement)

### 3. Configurer un émulateur/appareil
- **Android** : Créez un AVD (Android Virtual Device) dans Android Studio
- **iOS** : Utilisez le simulateur iOS (Mac uniquement)
- **Physique** : Activez le mode développeur et le débogage USB

---

## 🔥 Configuration Firebase

### Étape 1 : Créer un projet Firebase

1. Allez sur [Firebase Console](https://console.firebase.google.com/)
2. Cliquez sur "Ajouter un projet"
3. Nommez-le (ex: "occazcar-test")
4. Suivez les étapes de configuration

### Étape 2 : Activer les services Firebase

#### A. Authentication
1. Dans Firebase Console → **Authentication**
2. Cliquez sur "Commencer"
3. Activez **Email/Password** dans l'onglet "Sign-in method"

#### B. Firestore Database
1. Dans Firebase Console → **Firestore Database**
2. Cliquez sur "Créer une base de données"
3. Choisissez **Mode test** (pour les tests)
4. Sélectionnez une région (ex: europe-west)

**Règles Firestore** (à configurer dans l'onglet "Règles") :
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

#### C. Storage
1. Dans Firebase Console → **Storage**
2. Cliquez sur "Commencer"
3. Utilisez les règles par défaut pour commencer

**Règles Storage** (à configurer dans l'onglet "Règles") :
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

### Étape 3 : Configurer FlutterFire CLI

1. **Installer FlutterFire CLI** :
```bash
dart pub global activate flutterfire_cli
```

2. **Se placer dans le dossier du projet** :
```bash
cd occaz_car-main
```

3. **Configurer Firebase** :
```bash
flutterfire configure
```

Cette commande va :
- Vous demander de sélectionner votre projet Firebase
- Générer le fichier `lib/firebase_options.dart`
- Configurer les fichiers Android/iOS automatiquement

**Note** : Si vous avez déjà un `google-services.json`, vous pouvez le garder, mais `flutterfire configure` est recommandé.

---

## 📦 Installation des dépendances

1. **Installer les packages Flutter** :
```bash
flutter pub get
```

2. **Vérifier que tout est OK** :
```bash
flutter doctor
```

---

## 🚀 Lancer l'application

### Option 1 : Sur un émulateur/appareil connecté

1. **Vérifier les appareils disponibles** :
```bash
flutter devices
```

2. **Lancer l'application** :
```bash
flutter run
```

### Option 2 : Sur un appareil spécifique

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

## 🧪 Scénarios de test

### Test 1 : Inscription d'un utilisateur

1. **Lancer l'application**
2. **Cliquer sur "S'inscrire"**
3. **Remplir le formulaire** :
   - Nom complet : "Test User"
   - Email : "test@example.com"
   - Téléphone : "0612345678"
   - Mot de passe : "test123"
   - Confirmer le mot de passe : "test123"
   - Optionnel : Activer "Je suis un vendeur"
4. **Cliquer sur "S'inscrire"**
5. **Vérifier** : Vous devriez être redirigé vers l'écran d'accueil

### Test 2 : Connexion

1. **Se déconnecter** (si connecté) : Menu profil → Déconnexion
2. **Se connecter** avec les identifiants créés
3. **Vérifier** : Connexion réussie

### Test 3 : Parcourir les véhicules (Acheteur)

1. **Se connecter en tant qu'acheteur** (sans activer "Je suis un vendeur")
2. **Vérifier** : Liste des véhicules affichée
3. **Cliquer sur un véhicule** : Voir les détails
4. **Tester la recherche** : Icône de recherche → Filtrer par marque/prix/année

### Test 4 : Ajouter un véhicule (Vendeur)

1. **Créer un compte vendeur** ou **se connecter en tant que vendeur**
2. **Cliquer sur l'onglet "Ajouter"** (ou le bouton +)
3. **Étape 1 - Photos** :
   - Cliquer sur "Ajouter des photos"
   - Sélectionner 1-10 photos depuis la galerie
   - Vérifier l'affichage des miniatures
4. **Cliquer sur "Suivant"**
5. **Étape 2 - Détails** :
   - Marque : "Renault"
   - Modèle : "Clio"
   - Année : "2020"
   - Kilométrage : "50000"
   - Prix : "12000"
6. **Cliquer sur "Suivant"**
7. **Étape 3 - Infos** :
   - Description : "Véhicule en excellent état..."
   - Ville/Région : "Paris"
   - Optionnel : Cliquer sur "Récupérer ma position GPS"
8. **Cliquer sur "Publier"**
9. **Vérifier** : Message de succès et retour à la liste

### Test 5 : Modifier une annonce

1. **Aller dans "Mes Annonces"** (onglet vendeur)
2. **Cliquer sur le menu (3 points)** d'une annonce
3. **Sélectionner "Modifier"**
4. **Modifier les informations** (ex: prix)
5. **Cliquer sur "Enregistrer les modifications"**
6. **Vérifier** : Modifications sauvegardées

### Test 6 : Supprimer une annonce

1. **Dans "Mes Annonces"**
2. **Cliquer sur le menu (3 points)** d'une annonce
3. **Sélectionner "Supprimer"**
4. **Confirmer la suppression**
5. **Vérifier** : Annonce supprimée de la liste

### Test 7 : Contacter un vendeur

1. **Parcourir les véhicules**
2. **Cliquer sur un véhicule**
3. **Vérifier les informations du vendeur**
4. **Tester "Appeler"** : Devrait ouvrir l'appel téléphonique
5. **Tester "Message"** : Devrait ouvrir l'application SMS

### Test 8 : Profil utilisateur

1. **Cliquer sur l'icône profil** (en haut à droite)
2. **Sélectionner "Mon profil"**
3. **Vérifier** : Informations affichées (email, téléphone, type)
4. **Tester "À propos"** : Dialog avec informations de l'app

---

## 🐛 Résolution de problèmes

### Erreur : "Firebase not initialized"

**Solution** : Vérifiez que `firebase_options.dart` existe et que Firebase est bien configuré :
```bash
flutterfire configure
```

### Erreur : "Permission denied" sur Firestore

**Solution** : Vérifiez les règles Firestore dans Firebase Console (voir Étape 2.B)

### Erreur : "No devices found"

**Solution** :
- Vérifiez qu'un émulateur est lancé ou qu'un appareil est connecté
- Utilisez `flutter devices` pour voir les appareils disponibles

### Erreur : "Package not found"

**Solution** :
```bash
flutter clean
flutter pub get
```

### Erreur : "Image picker not working"

**Solution** : Vérifiez les permissions dans :
- **Android** : `android/app/src/main/AndroidManifest.xml` (ajouter les permissions)
- **iOS** : `ios/Runner/Info.plist` (ajouter les permissions)

### L'application se bloque au chargement

**Solution** :
1. Vérifiez la console Firebase pour les erreurs
2. Vérifiez la connexion internet
3. Vérifiez les règles Firestore/Storage

---

## 📱 Permissions nécessaires

### Android (`android/app/src/main/AndroidManifest.xml`)

Ajoutez ces permissions si elles n'existent pas :
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.CAMERA"/>
```

### iOS (`ios/Runner/Info.plist`)

Ajoutez ces clés :
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Nous avons besoin de votre localisation pour afficher les véhicules à proximité</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Nous avons besoin d'accéder à vos photos pour ajouter des images de véhicules</string>
<key>NSCameraUsageDescription</key>
<string>Nous avons besoin d'accéder à votre caméra pour prendre des photos de véhicules</string>
```

---

## ✅ Checklist de test complète

- [ ] Installation Flutter OK
- [ ] Firebase configuré
- [ ] Dépendances installées
- [ ] Application lancée sans erreur
- [ ] Inscription fonctionne
- [ ] Connexion fonctionne
- [ ] Liste des véhicules s'affiche
- [ ] Recherche fonctionne
- [ ] Détails d'un véhicule s'affichent
- [ ] Ajout d'un véhicule fonctionne (vendeur)
- [ ] Modification d'une annonce fonctionne
- [ ] Suppression d'une annonce fonctionne
- [ ] Contact vendeur fonctionne (appel/SMS)
- [ ] Profil utilisateur s'affiche
- [ ] Déconnexion fonctionne

---

## 🎯 Tests avancés

### Test de performance
- Ajouter plusieurs véhicules et vérifier la fluidité de la liste
- Tester avec une connexion lente

### Test de sécurité
- Vérifier qu'un utilisateur ne peut pas modifier/supprimer les annonces d'un autre
- Vérifier les règles Firestore

### Test multi-appareils
- Tester sur différents appareils/émulateurs
- Tester sur différentes tailles d'écran

---

## 📞 Support

Si vous rencontrez des problèmes :
1. Vérifiez les logs : `flutter run` affiche les erreurs
2. Vérifiez Firebase Console pour les erreurs backend
3. Consultez la documentation Flutter : [flutter.dev](https://flutter.dev/docs)

---

**Bon test ! 🚗✨**









