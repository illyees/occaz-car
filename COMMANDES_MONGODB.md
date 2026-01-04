# 🚀 Commandes Rapides - MongoDB

## 📦 Installation

### 1. Installer les dépendances
```bash
cd occaz_car-main
flutter pub get
```

### 2. Configurer la connection string
Éditez `lib/config/mongodb_config.dart` et remplacez :
```dart
static const String connectionString = 
  'mongodb+srv://VOTRE_USERNAME:VOTRE_PASSWORD@cluster0.xxxxx.mongodb.net/occazcar?retryWrites=true&w=majority';
```

### 3. Lancer l'application
```bash
flutter run -t lib/main_mongodb.dart
```

---

## 🔄 Basculer entre Firebase et MongoDB

### Mode MongoDB
```bash
flutter run -t lib/main_mongodb.dart
```

### Mode Firebase
```bash
flutter run -t lib/main.dart
```

### Mode Démo (Mock)
```bash
flutter run -t lib/main_demo.dart
```

---

## ✅ Vérification

### Vérifier la connexion MongoDB
L'application devrait se connecter automatiquement au démarrage.

### Vérifier les données
Dans MongoDB Atlas → Database → Browse Collections

---

**C'est tout ! 🎉**



