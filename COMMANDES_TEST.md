# 📝 Commandes Essentielles pour Tester OccazCar

## 🚀 Démarrage en 5 minutes

```bash
# 1. Aller dans le dossier du projet
cd occaz_car-main

# 2. Installer les dépendances
flutter pub get

# 3. Configurer Firebase (IMPORTANT - une seule fois)
dart pub global activate flutterfire_cli
flutterfire configure

# 4. Lancer l'application
flutter run
```

---

## ✅ Checklist avant de lancer

- [ ] Flutter installé (`flutter doctor` OK)
- [ ] Projet Firebase créé
- [ ] Firebase configuré (`flutterfire configure` exécuté)
- [ ] Dépendances installées (`flutter pub get`)
- [ ] Émulateur/appareil connecté (`flutter devices`)

---

## 🔧 Commandes de dépannage

```bash
# Nettoyer et réinstaller
flutter clean
flutter pub get

# Vérifier les erreurs
flutter analyze

# Voir les appareils disponibles
flutter devices

# Vérifier la configuration Flutter
flutter doctor -v
```

---

## 🎯 Tests rapides

### Test 1 : Vérifier que l'app démarre
```bash
flutter run
```
**Résultat attendu** : Écran de connexion s'affiche

### Test 2 : Créer un compte
1. Cliquer sur "S'inscrire"
2. Remplir le formulaire
3. **Résultat attendu** : Redirection vers l'accueil

### Test 3 : Ajouter un véhicule (vendeur)
1. Se connecter en tant que vendeur
2. Cliquer sur "+" ou onglet "Ajouter"
3. Ajouter photos + détails
4. **Résultat attendu** : Annonce publiée

---

## 🐛 Erreurs courantes et solutions

### Erreur : "FirebaseException: [core/no-app] No Firebase App '[DEFAULT]' has been created"
**Solution** :
```bash
flutterfire configure
```
Puis vérifier que `lib/firebase_options.dart` existe.

### Erreur : "Permission denied" (Firestore)
**Solution** : Vérifier les règles Firestore dans Firebase Console (voir GUIDE_TEST.md)

### Erreur : "No devices found"
**Solution** :
- Lancer un émulateur Android/iOS
- Ou connecter un appareil physique
- Vérifier avec `flutter devices`

### Erreur : "Package not found"
**Solution** :
```bash
flutter clean
flutter pub get
```

---

## 📱 Lancer sur différentes plateformes

```bash
# Android
flutter run -d android

# iOS (Mac uniquement)
flutter run -d ios

# Web
flutter run -d chrome

# Windows
flutter run -d windows

# Linux
flutter run -d linux
```

---

## 🔍 Vérifications importantes

### Vérifier Firebase
- ✅ Authentication activé (Email/Password)
- ✅ Firestore créé
- ✅ Storage activé
- ✅ Règles configurées (voir GUIDE_TEST.md)

### Vérifier les permissions
- ✅ Android : `AndroidManifest.xml` contient les permissions
- ✅ iOS : `Info.plist` contient les descriptions de permissions

---

## 📚 Documentation complète

- **Guide détaillé** : `GUIDE_TEST.md`
- **Démarrage rapide** : `DEBUT_RAPIDE.md`
- **Ce fichier** : Commandes essentielles

---

**Bon test ! 🚗**









