# 🔥 Guide Complet - Configuration Firebase

## 📋 Vue d'ensemble

Ce guide vous explique comment configurer Firebase pour que l'application OccazCar fonctionne avec les vrais services (au lieu du mode démo).

---

## 🎯 Étape 1 : Créer un Projet Firebase

### 1.1 Aller sur Firebase Console
1. Allez sur [Firebase Console](https://console.firebase.google.com/)
2. Cliquez sur **"Ajouter un projet"** ou **"Créer un projet"**

### 1.2 Nommer le projet
- **Nom du projet** : `occazcar` (ou un nom de votre choix)
- Cliquez sur **"Continuer"**

### 1.3 Configurer Google Analytics (Optionnel)
- Vous pouvez activer ou désactiver Google Analytics
- Cliquez sur **"Créer le projet"**
- Attendez que le projet soit créé (quelques secondes)
- Cliquez sur **"Continuer"**

---

## 🔐 Étape 2 : Activer Authentication

### 2.1 Accéder à Authentication
1. Dans le menu de gauche, cliquez sur **"Authentication"**
2. Cliquez sur **"Commencer"**

### 2.2 Activer Email/Password
1. Cliquez sur l'onglet **"Sign-in method"** (Méthodes de connexion)
2. Cliquez sur **"Email/Password"**
3. Activez le premier bouton **"Email/Password"** (Enable)
4. Cliquez sur **"Enregistrer"**

✅ **Authentication est maintenant activé !**

---

## 💾 Étape 3 : Créer Firestore Database

### 3.1 Créer la base de données
1. Dans le menu de gauche, cliquez sur **"Firestore Database"**
2. Cliquez sur **"Créer une base de données"**

### 3.2 Choisir le mode
- **Sélectionnez "Mode test"** (pour commencer)
- Cliquez sur **"Suivant"**

### 3.3 Choisir la région
- Sélectionnez une région proche de vous (ex: `europe-west`)
- Cliquez sur **"Activer"**

### 3.4 Configurer les règles de sécurité
1. Cliquez sur l'onglet **"Règles"**
2. Remplacez le contenu par :

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

3. Cliquez sur **"Publier"**

✅ **Firestore est maintenant configuré !**

---

## 📦 Étape 4 : Activer Storage

### 4.1 Activer Storage
1. Dans le menu de gauche, cliquez sur **"Storage"**
2. Cliquez sur **"Commencer"**

### 4.2 Configurer Storage
1. Acceptez les règles par défaut (vous les modifierez après)
2. Choisissez la même région que Firestore
3. Cliquez sur **"Terminé"**

### 4.3 Configurer les règles Storage
1. Cliquez sur l'onglet **"Règles"**
2. Remplacez le contenu par :

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

3. Cliquez sur **"Publier"**

✅ **Storage est maintenant configuré !**

---

## 🔧 Étape 5 : Configurer FlutterFire CLI

### 5.1 Installer FlutterFire CLI
Ouvrez un terminal et exécutez :

```bash
dart pub global activate flutterfire_cli
```

### 5.2 Se connecter à Firebase
```bash
firebase login
```

Cela ouvrira votre navigateur pour vous connecter à votre compte Google.

### 5.3 Configurer le projet Flutter
1. Allez dans le dossier du projet :
```bash
cd occaz_car-main
```

2. Exécutez la configuration :
```bash
flutterfire configure
```

3. **Sélectionnez votre projet Firebase** dans la liste
4. **Sélectionnez les plateformes** que vous voulez configurer :
   - ✅ Android
   - ✅ iOS (si vous avez un Mac)
   - ✅ Web
   - ✅ Windows (optionnel)
   - ✅ Linux (optionnel)

5. FlutterFire CLI va :
   - Générer le fichier `lib/firebase_options.dart`
   - Configurer automatiquement les fichiers Android/iOS/Web

✅ **FlutterFire est maintenant configuré !**

---

## 📝 Étape 6 : Mettre à jour main.dart

### 6.1 Vérifier que firebase_options.dart existe
Le fichier `lib/firebase_options.dart` devrait avoir été généré automatiquement.

### 6.2 Modifier main.dart
Ouvrez `lib/main.dart` et modifiez :

**Avant :**
```dart
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```

**Après :**
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';  // Décommenter cette ligne

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // Ajouter cette ligne
  );
  runApp(const MyApp());
}
```

✅ **main.dart est maintenant configuré !**

---

## 🚀 Étape 7 : Tester l'Application

### 7.1 Installer les dépendances
```bash
flutter pub get
```

### 7.2 Lancer l'application
```bash
flutter run
```

**OU** pour une plateforme spécifique :
```bash
flutter run -d chrome    # Web
flutter run -d android   # Android
flutter run -d ios       # iOS (Mac uniquement)
```

### 7.3 Tester les fonctionnalités
1. **S'inscrire** : Créez un compte avec email/mot de passe
2. **Se connecter** : Connectez-vous avec vos identifiants
3. **Ajouter un véhicule** : Si vous êtes vendeur, ajoutez un véhicule
4. **Vérifier Firestore** : Dans Firebase Console → Firestore, vous devriez voir vos données

---

## ✅ Checklist de Configuration

- [ ] Projet Firebase créé
- [ ] Authentication activé (Email/Password)
- [ ] Firestore créé avec règles configurées
- [ ] Storage activé avec règles configurées
- [ ] FlutterFire CLI installé
- [ ] `flutterfire configure` exécuté
- [ ] `firebase_options.dart` généré
- [ ] `main.dart` mis à jour
- [ ] Application testée

---

## 🐛 Résolution de Problèmes

### Erreur : "FirebaseException: [core/no-app]"
**Solution** : Vérifiez que `firebase_options.dart` existe et que `main.dart` l'utilise correctement.

### Erreur : "Permission denied" (Firestore)
**Solution** : Vérifiez les règles Firestore dans Firebase Console.

### Erreur : "Permission denied" (Storage)
**Solution** : Vérifiez les règles Storage dans Firebase Console.

### Erreur : "No devices found"
**Solution** : 
- Vérifiez qu'un émulateur est lancé : `flutter devices`
- Ou connectez un appareil physique

### Erreur : "Package not found"
**Solution** :
```bash
flutter clean
flutter pub get
```

---

## 📚 Ressources Utiles

- [Documentation Firebase](https://firebase.google.com/docs)
- [Documentation FlutterFire](https://firebase.flutter.dev/)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)

---

## 🎯 Prochaines Étapes

Une fois Firebase configuré :

1. **Tester toutes les fonctionnalités** :
   - Inscription/Connexion
   - Ajout de véhicules
   - Recherche
   - Modification/Suppression

2. **Passer en mode production** :
   - Changer les règles Firestore/Storage pour la production
   - Configurer les domaines autorisés pour Web

3. **Déployer l'application** :
   - Build pour Android/iOS
   - Déployer sur le Web

---

**Votre application est maintenant prête à fonctionner avec Firebase ! 🎉**



