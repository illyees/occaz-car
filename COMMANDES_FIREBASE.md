# 🚀 Commandes Rapides - Configuration Firebase

## 📦 Installation et Configuration

### 1. Installer FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### 2. Se connecter à Firebase
```bash
firebase login
```

### 3. Configurer le projet
```bash
cd occaz_car-main
flutterfire configure
```

**Sélectionnez :**
- Votre projet Firebase
- Les plateformes (Android, iOS, Web, etc.)

### 4. Installer les dépendances
```bash
flutter pub get
```

### 5. Lancer l'application
```bash
flutter run
```

---

## ✅ Vérification

### Vérifier que firebase_options.dart existe
```bash
ls lib/firebase_options.dart
```

### Vérifier la configuration
```bash
flutter doctor
```

---

## 🔄 Retour au Mode Démo

Si vous voulez revenir au mode démo :
```bash
flutter run -t lib/main_demo.dart
```

---

**C'est tout ! 🎉**



