# ✅ Connexion Automatique en Mode Démo

## 🎯 Modification Apportée

L'application se connecte **automatiquement** au démarrage en mode démo, **sans passer par l'écran de login**.

## 🚀 Utilisation

### Lancer l'application
```bash
cd occaz_car-main
flutter run -t lib/main_demo.dart
```

### Résultat
- ✅ **Connexion automatique** : Vous êtes directement connecté comme **acheteur**
- ✅ **Accès direct** : Vous voyez immédiatement la liste des véhicules
- ✅ **Pas de login requis** : L'écran de login est contourné

## 👤 Utilisateur par Défaut

- **Type** : Acheteur
- **Email** : `demo@occazcar.com`
- **Nom** : "Acheteur Demo"

## 🔄 Changer de Type d'Utilisateur

Si vous voulez tester en tant que **vendeur**, vous pouvez :

1. **Se déconnecter** : Menu profil → Déconnexion
2. **Se connecter** : Utiliser un email contenant "vendeur" (ex: `vendeur@demo.com`)

Ou modifier `main_demo.dart` ligne 18 pour utiliser :
```dart
await mockAuth.login('vendeur@demo.com', 'demo123');
```

## 📝 Note

Cette modification ne fonctionne qu'en **mode démo**. En mode Firebase normal, l'utilisateur devra toujours se connecter.

---

**Vous pouvez maintenant tester l'application directement sans passer par le login ! 🎉**




