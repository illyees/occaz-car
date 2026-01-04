# 🚀 Démarrage Rapide - Mode Démo

## Lancer l'application en mode démo (SANS Firebase)

### Étape 1 : Lancer directement
```bash
cd occaz_car-main
flutter run -t lib/main_demo.dart
```

C'est tout ! L'application va démarrer avec des données mockées.

---

## 🎮 Utilisation

### Se connecter
- **N'importe quel email/mot de passe fonctionne**
- Email contenant "vendeur" ou "seller" → Compte vendeur
- Autre email → Compte acheteur

**Exemples :**
- `test@demo.com` / `123456` → Acheteur
- `vendeur@demo.com` / `123456` → Vendeur

### Fonctionnalités disponibles
- ✅ Parcourir les véhicules (5 véhicules de démo)
- ✅ Voir les détails d'un véhicule
- ✅ Rechercher avec filtres
- ✅ Ajouter un véhicule (si vendeur)
- ✅ Modifier/Supprimer des annonces (si vendeur)
- ✅ Voir le profil

---

## 📱 Test rapide

1. **Lancer** : `flutter run -t lib/main_demo.dart`
2. **S'inscrire** : Email: `test@demo.com`, Mot de passe: `123456`
3. **Explorer** : Parcourir les 5 véhicules de démo
4. **Tester la recherche** : Cliquer sur l'icône de recherche → Filtrer
5. **Tester vendeur** : Se déconnecter → S'inscrire avec `vendeur@demo.com` → Ajouter un véhicule

---

## ⚠️ Note importante

Les données sont **temporaires** et seront perdues au redémarrage de l'app.

Pour une persistance des données, configurez Firebase (voir `GUIDE_TEST.md`).

---

## 🐛 Problème ?

Si l'application ne démarre pas :
```bash
flutter clean
flutter pub get
flutter run -t lib/main_demo.dart
```

---

**Profitez du mode démo ! 🎨**









