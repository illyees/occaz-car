# 🎮 Mode Démo - Tester sans Firebase

## ✅ Solution Créée

J'ai créé un **mode démo complet** qui permet de tester l'application sans configurer Firebase !

## 🚀 Lancer en mode démo

```bash
cd occaz_car-main
flutter run -t lib/main_demo.dart
```

C'est tout ! L'application démarre avec des données mockées.

---

## 📦 Fichiers créés

1. **`lib/main_demo.dart`** - Point d'entrée pour le mode démo
2. **`lib/services/mock_service.dart`** - Données mockées (5 véhicules)
3. **`lib/services/mock_auth_service.dart`** - Authentification mockée
4. **`lib/services/mock_database_service.dart`** - Base de données mockée
5. **`lib/services/mock_storage_service.dart`** - Stockage mocké
6. **`lib/utils/demo_helper.dart`** - Helper pour le mode démo

---

## 🎯 Fonctionnalités disponibles

### ✅ Ce qui fonctionne
- **Interface complète** : Tous les écrans sont accessibles
- **Authentification** : N'importe quel email/mot de passe fonctionne
- **Liste de véhicules** : 5 véhicules de démo préchargés
- **Recherche** : Filtres fonctionnent
- **Détails véhicule** : Affichage complet
- **Ajout véhicule** : Formulaire fonctionne (si vendeur)
- **Modification/Suppression** : Fonctionne (si vendeur)
- **Profil** : Affichage des informations

### ⚠️ Limitations
- Données temporaires (perdues au redémarrage)
- Images uploadées remplacées par des placeholders
- Pas de localisation GPS réelle

---

## 🎮 Comptes de test

### Acheteur
- **Email** : `test@demo.com` (ou n'importe quoi)
- **Mot de passe** : `123456` (ou n'importe quoi)
- **Résultat** : Accès à la liste des véhicules

### Vendeur
- **Email** : `vendeur@demo.com` (doit contenir "vendeur" ou "seller")
- **Mot de passe** : `123456` (ou n'importe quoi)
- **Résultat** : Accès complet + onglets vendeur

---

## 📝 Véhicules de démo

1. **Renault Clio 2020** - 12 000€ - Paris
2. **Peugeot 208 2019** - 15 000€ - Lyon
3. **Citroën C3 2021** - 18 000€ - Marseille
4. **Toyota Yaris 2018** - 11 000€ - Bordeaux
5. **Volkswagen Polo 2020** - 16 000€ - Lille

---

## 🔄 Retour au mode Firebase

Pour utiliser Firebase plus tard :

1. Configurer Firebase : `flutterfire configure`
2. Lancer normalement : `flutter run` (sans `-t lib/main_demo.dart`)

---

## 📚 Documentation

- **Guide démo complet** : `MODE_DEMO.md`
- **Démarrage rapide** : `DEMARRAGE_DEMO.md` (ce fichier)
- **Guide Firebase** : `GUIDE_TEST.md`

---

**Profitez du mode démo pour tester l'interface ! 🎨**









