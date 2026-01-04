# 🚀 Démarrage Rapide - MongoDB

## ⚡ Configuration en 5 minutes

### 1. Créer un compte MongoDB Atlas
1. Allez sur [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Créez un compte gratuit
3. Créez un cluster M0 (gratuit)

### 2. Configurer MongoDB Atlas
1. **Database Access** → Créez un utilisateur (username/password)
2. **Network Access** → Ajoutez `0.0.0.0/0` (accès depuis partout)
3. **Database** → Cliquez sur "Connect" → "Connect your application"
4. Copiez la connection string

### 3. Configurer l'application
1. Ouvrez `lib/config/mongodb_config.dart`
2. Remplacez la connection string par la vôtre :
```dart
static const String connectionString = 
  'mongodb+srv://VOTRE_USERNAME:VOTRE_PASSWORD@cluster0.xxxxx.mongodb.net/occazcar?retryWrites=true&w=majority';
```

### 4. Installer les dépendances
```bash
cd occaz_car-main
flutter pub get
```

### 5. Lancer l'application
```bash
flutter run -t lib/main_mongodb.dart
```

---

## ✅ C'est tout !

L'application devrait maintenant fonctionner avec MongoDB.

---

## 📚 Guide Complet

Pour plus de détails, consultez `GUIDE_MONGODB_COMPLET.md`

---

**Profitez de MongoDB ! 🍃**



