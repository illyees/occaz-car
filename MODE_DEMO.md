# 🎮 Mode Démo - Tester sans Firebase

## 🎯 Objectif

Tester l'interface et les fonctionnalités de l'application **sans configurer Firebase**.

## 🚀 Comment lancer en mode démo

### Option 1 : Lancer directement le fichier démo
```bash
cd occaz_car-main
flutter run -t lib/main_demo.dart
```

### Option 2 : Modifier temporairement main.dart

Remplacez le contenu de `lib/main.dart` par celui de `lib/main_demo.dart` :

```dart
// Dans main.dart, remplacez les imports et providers par :
import 'services/mock_auth_service.dart';

// Et dans MultiProvider :
ChangeNotifierProvider(create: (_) => MockAuthService()),
```

Puis lancez normalement :
```bash
flutter run
```

## ✅ Ce qui fonctionne en mode démo

- ✅ **Interface utilisateur complète** : Tous les écrans sont accessibles
- ✅ **Navigation** : Navigation entre les écrans fonctionne
- ✅ **Authentification mockée** : 
  - Inscription : Accepte n'importe quel email/mot de passe
  - Connexion : Accepte n'importe quel email/mot de passe
  - Si email contient "vendeur" ou "seller" → compte vendeur
  - Sinon → compte acheteur
- ✅ **Liste de véhicules** : 5 véhicules de démo préchargés
- ✅ **Recherche** : Filtres fonctionnent avec les données mockées
- ✅ **Détails véhicule** : Affichage complet des informations
- ✅ **Ajout véhicule** : Formulaire fonctionne (images mockées)
- ✅ **Modification/Suppression** : Fonctionne avec les données mockées
- ✅ **Profil** : Affichage des informations utilisateur

## 📝 Données de démo incluses

### Véhicules préchargés :
1. **Renault Clio 2020** - 12 000€ - Paris
2. **Peugeot 208 2019** - 15 000€ - Lyon
3. **Citroën C3 2021** - 18 000€ - Marseille
4. **Toyota Yaris 2018** - 11 000€ - Bordeaux
5. **Volkswagen Polo 2020** - 16 000€ - Lille

### Comptes de test :
- **Acheteur** : N'importe quel email (ex: `acheteur@test.com`)
- **Vendeur** : Email contenant "vendeur" ou "seller" (ex: `vendeur@test.com`)

## 🎮 Scénarios de test en mode démo

### Test 1 : Parcourir sans connexion
1. Lancer l'app en mode démo
2. Vous verrez l'écran de connexion
3. Cliquez sur "S'inscrire"
4. Remplissez le formulaire (n'importe quelles valeurs)
5. ✅ Vous êtes connecté et voyez la liste des véhicules

### Test 2 : Tester en tant qu'acheteur
1. Se connecter avec un email normal (ex: `test@demo.com`)
2. ✅ Voir la liste des 5 véhicules
3. Cliquer sur un véhicule → Voir les détails
4. Tester la recherche → Filtrer par marque/prix
5. Tester le contact → Boutons Appeler/Message (ouvrent les apps système)

### Test 3 : Tester en tant que vendeur
1. Se connecter avec un email contenant "vendeur" (ex: `vendeur@demo.com`)
2. ✅ Voir les onglets : Accueil, Mes Annonces, Ajouter
3. Cliquer sur "Ajouter" → Formulaire en 3 étapes
4. Ajouter des photos (depuis la galerie)
5. Remplir les détails → Publier
6. ✅ Le véhicule apparaît dans "Mes Annonces"
7. Tester modifier → Modifier les informations
8. Tester supprimer → Supprimer l'annonce

### Test 4 : Tester la recherche
1. Cliquer sur l'icône de recherche
2. Tester les filtres :
   - Marque : Sélectionner "Renault" → Voir seulement les Renault
   - Prix max : Ajuster le slider → Voir les véhicules dans la fourchette
   - Année min : Ajuster → Voir les véhicules récents
3. ✅ Les résultats se filtrent en temps réel

## ⚠️ Limitations du mode démo

- ❌ **Pas de persistance** : Les données sont perdues au redémarrage
- ❌ **Pas de vraies images** : Les images uploadées sont remplacées par des placeholders
- ❌ **Pas de localisation GPS réelle** : La position est mockée
- ❌ **Pas de vraie authentification** : N'importe quel email/mot de passe fonctionne
- ❌ **Données limitées** : Seulement 5 véhicules de base

## 🔄 Retour au mode normal

Pour revenir au mode Firebase normal :

1. **Restaurer main.dart** :
   - Utiliser le fichier `main.dart` original
   - Ou exécuter `flutterfire configure` et utiliser Firebase

2. **Lancer normalement** :
```bash
flutter run
```

## 💡 Astuce

Vous pouvez garder les deux versions :
- `main.dart` → Mode Firebase (production)
- `main_demo.dart` → Mode démo (test)

Et basculer entre les deux selon vos besoins !

## 🐛 Résolution de problèmes

### Erreur : "Target file not found"
**Solution** : Vérifiez que vous êtes dans le bon dossier :
```bash
cd occaz_car-main
```

### Les véhicules ne s'affichent pas
**Solution** : Vérifiez que vous êtes bien connecté (inscription/connexion)

### L'application se bloque
**Solution** : 
```bash
flutter clean
flutter pub get
flutter run -t lib/main_demo.dart
```

---

**Profitez du mode démo pour tester l'interface ! 🎨**









