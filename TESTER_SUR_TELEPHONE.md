# 📱 Tester sur Téléphone (Android/iOS)

## 🎯 Guide Complet pour Tester MongoDB sur Votre Téléphone

---

## 📱 Android (via USB)

### Étape 1 : Activer le Mode Développeur

1. **Allez dans Paramètres** → **À propos du téléphone**
2. **Tapez 7 fois** sur **"Numéro de build"** ou **"Version MIUI"**
3. Un message apparaîtra : **"Vous êtes maintenant développeur"** ✅

### Étape 2 : Activer le Débogage USB

1. **Retournez dans Paramètres** → **Paramètres système** → **Options pour les développeurs**
2. **Activez "Options pour les développeurs"**
3. **Activez "Débogage USB"**
4. **Activez "Installer via USB"** (optionnel)

### Étape 3 : Connecter le Téléphone

1. **Connectez votre téléphone** au PC avec un **câble USB**
2. Sur votre téléphone, une popup apparaîtra : **"Autoriser le débogage USB ?"**
3. **Cochez "Toujours autoriser depuis cet ordinateur"**
4. **Cliquez sur "Autoriser"**

### Étape 4 : Vérifier la Connexion

Ouvrez PowerShell et tapez :

```bash
flutter devices
```

Vous devriez voir votre téléphone listé, par exemple :
```
sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64 • Android 13
```

### Étape 5 : Lancer l'Application

```bash
cd occaz_car-main
flutter run -t lib/main_mongodb.dart
```

Flutter détectera automatiquement votre téléphone et installera l'app ! 🚀

---

## 🍎 iOS (via USB)

### Étape 1 : Prérequis

- **Mac** (obligatoire pour iOS)
- **Xcode** installé
- **CocoaPods** installé

### Étape 2 : Activer le Mode Développeur

1. **Paramètres** → **Confidentialité et sécurité**
2. **Activez "Mode développeur"**

### Étape 3 : Connecter l'iPhone

1. **Connectez votre iPhone** au Mac avec un **câble USB**
2. **Faites confiance à cet ordinateur** si demandé
3. **Ouvrez Xcode** → **Window** → **Devices and Simulators**
4. Vérifiez que votre iPhone est reconnu

### Étape 4 : Lancer l'Application

```bash
cd occaz_car-main
flutter run -t lib/main_mongodb.dart -d ios
```

---

## 🔧 Dépannage

### Problème : "No devices found"

**Solutions :**

1. **Vérifiez le câble USB** (utilisez un câble de données, pas juste de charge)
2. **Réinstallez les drivers USB** (Windows)
3. **Redémarrez ADB** :
   ```bash
   adb kill-server
   adb start-server
   flutter devices
   ```

### Problème : "USB debugging not authorized"

1. **Débranchez et rebranchez** le câble
2. **Autorisez à nouveau** sur le téléphone
3. **Cochez "Toujours autoriser"**

### Problème : "Device offline"

1. **Désactivez puis réactivez** le débogage USB
2. **Redémarrez ADB** :
   ```bash
   adb kill-server
   adb start-server
   ```

---

## ✅ Vérification Rapide

### Vérifier que Flutter détecte votre téléphone :

```bash
flutter devices
```

### Vérifier que ADB détecte votre téléphone :

```bash
adb devices
```

Vous devriez voir quelque chose comme :
```
List of devices attached
emulator-5554    device
```

---

## 🚀 Commandes Utiles

### Lister tous les appareils disponibles :
```bash
flutter devices
```

### Lancer sur un appareil spécifique :
```bash
flutter run -t lib/main_mongodb.dart -d <device-id>
```

### Voir les logs en temps réel :
```bash
flutter logs
```

### Redémarrer l'application :
```bash
# Appuyez sur 'r' dans le terminal où l'app tourne
```

### Hot Reload (recharger sans redémarrer) :
```bash
# Appuyez sur 'R' dans le terminal où l'app tourne
```

---

## 📝 Notes Importantes

- **Première installation** : L'app peut prendre 1-2 minutes à s'installer
- **MongoDB fonctionne** : Contrairement au web, MongoDB fonctionne parfaitement sur Android/iOS
- **Internet requis** : Votre téléphone doit être connecté à Internet pour se connecter à MongoDB Atlas

---

## 🎉 C'est Prêt !

Une fois connecté, lancez simplement :

```bash
flutter run -t lib/main_mongodb.dart
```

Et profitez de votre application avec MongoDB ! 🚀



