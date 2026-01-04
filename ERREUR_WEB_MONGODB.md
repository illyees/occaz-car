# ⚠️ Erreur MongoDB sur le Web

## 🔴 Problème

L'erreur `Platform._operatingSystem` indique que **`mongo_dart` ne fonctionne pas sur le web** (Chrome).

Le package `mongo_dart` utilise des opérations système qui ne sont **pas disponibles dans le navigateur**.

---

## ✅ Solutions

### Solution 1 : Utiliser le Mode Démo pour le Web (RECOMMANDÉ)

Pour tester sur Chrome, utilisez le mode démo qui fonctionne parfaitement :

```bash
flutter run -t lib/main_demo.dart -d chrome
```

Le mode démo utilise des services mockés et fonctionne sur toutes les plateformes.

---

### Solution 2 : Tester sur une Plateforme Native

MongoDB fonctionne parfaitement sur **Android** et **iOS** :

#### Android (Émulateur ou Appareil)
```bash
flutter run -t lib/main_mongodb.dart -d android
```

#### iOS (Simulateur ou Appareil)
```bash
flutter run -t lib/main_mongodb.dart -d ios
```

#### Windows Desktop
```bash
flutter run -t lib/main_mongodb.dart -d windows
```

---

### Solution 3 : Créer un Backend API REST (Pour Production Web)

Pour utiliser MongoDB sur le web en production, vous devez créer un **backend API** qui se connecte à MongoDB.

#### Architecture recommandée :

```
Flutter Web App (Chrome)
    ↓ HTTP Requests
Backend API (Node.js / Dart / Python)
    ↓ mongo_dart / mongodb driver
MongoDB Atlas
```

#### Exemple de backend simple (Node.js + Express) :

```javascript
// server.js
const express = require('express');
const { MongoClient } = require('mongodb');
const app = express();

app.use(express.json());

const uri = 'VOTRE_MONGODB_CONNECTION_STRING';
const client = new MongoClient(uri);

app.post('/api/login', async (req, res) => {
  const { email, password } = req.body;
  // Logique de connexion MongoDB
  // ...
});

app.listen(3000, () => {
  console.log('Server running on port 3000');
});
```

Puis dans Flutter, utilisez `http` ou `dio` pour appeler ces endpoints.

---

## 📋 Résumé

| Plateforme | MongoDB Direct | Mode Démo | Backend API |
|------------|---------------|-----------|-------------|
| **Web (Chrome)** | ❌ Ne fonctionne pas | ✅ Fonctionne | ✅ Recommandé |
| **Android** | ✅ Fonctionne | ✅ Fonctionne | ✅ Optionnel |
| **iOS** | ✅ Fonctionne | ✅ Fonctionne | ✅ Optionnel |
| **Windows** | ✅ Fonctionne | ✅ Fonctionne | ✅ Optionnel |

---

## 🚀 Action Immédiate

Pour tester maintenant sur Chrome, utilisez :

```bash
flutter run -t lib/main_demo.dart -d chrome
```

Pour tester MongoDB, utilisez Android/iOS :

```bash
flutter run -t lib/main_mongodb.dart -d android
```

---

**Note** : Pour une application web en production avec MongoDB, créez un backend API REST.



