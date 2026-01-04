# 👤 Comptes Utilisateurs MongoDB

## 🎯 Comment se connecter ?

Avec MongoDB, **il n'y a pas de compte par défaut**. Vous devez créer un compte vous-même.

---

## ✅ Option 1 : Créer un compte via l'application (RECOMMANDÉ)

1. **Lancez l'application** :
   ```bash
   flutter run -t lib/main_mongodb.dart -d chrome
   ```

2. **Cliquez sur "S'inscrire"** ou "Créer un compte"

3. **Remplissez le formulaire** :
   - 📧 **Email** : votre email (ex: `test@occazcar.com`)
   - 🔒 **Mot de passe** : votre mot de passe (ex: `test123`)
   - 👤 **Nom** : votre nom
   - 📱 **Téléphone** : votre numéro
   - 🏷️ **Type** : Acheteur ou Vendeur

4. **Après l'inscription**, vous serez automatiquement connecté ! ✅

---

## 🛠️ Option 2 : Créer un utilisateur de test avec un script

Si vous préférez créer un utilisateur directement dans MongoDB :

### Étape 1 : Créer le script

Le script `scripts/create_test_user.dart` est déjà créé pour vous.

### Étape 2 : Exécuter le script

```bash
cd occaz_car-main
dart scripts/create_test_user.dart
```

### Étape 3 : Utiliser les identifiants

Le script créera un utilisateur avec :
- **Email** : `test@occazcar.com`
- **Mot de passe** : `test123`
- **Type** : Acheteur

Vous pouvez modifier ces valeurs dans le script si vous le souhaitez.

---

## 📝 Comptes de test suggérés

### Compte Acheteur
- **Email** : `acheteur@occazcar.com`
- **Mot de passe** : `acheteur123`
- **Type** : Acheteur

### Compte Vendeur
- **Email** : `vendeur@occazcar.com`
- **Mot de passe** : `vendeur123`
- **Type** : Vendeur

Créez ces comptes via l'application ou le script.

---

## 🔍 Vérifier les utilisateurs dans MongoDB Atlas

1. Allez sur [MongoDB Atlas](https://cloud.mongodb.com)
2. Connectez-vous à votre cluster
3. Cliquez sur **"Browse Collections"**
4. Sélectionnez la base de données `occazcar`
5. Ouvrez la collection `users`
6. Vous verrez tous les utilisateurs créés

---

## ⚠️ Important

- Les mots de passe sont **hashés** (SHA-256) dans la base de données
- Vous ne pouvez pas voir les mots de passe en clair
- Si vous oubliez votre mot de passe, vous devrez créer un nouveau compte ou modifier directement dans MongoDB

---

## 🚀 Prêt à commencer !

Créez votre premier compte et commencez à utiliser l'application ! 🎉



