# Instructions pour pousser vers GitHub

## Problème actuel

Vous êtes authentifié avec le compte `bechirzammouri` mais le repo appartient à `illyees`.

## Solutions

### Solution 1: Se connecter avec le bon compte GitHub

```powershell
# Supprimer les credentials existants
git credential-cache exit
# ou
git config --global --unset credential.helper

# Puis re-essayer de pousser (il demandera vos identifiants)
git push -u origin feature/clean-architecture
```

### Solution 2: Utiliser un Personal Access Token

1. Aller sur GitHub.com → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Générer un nouveau token avec les permissions `repo`
3. Copier le token
4. Utiliser cette commande :

```powershell
git remote set-url origin https://VOTRE_TOKEN@github.com/illyees/occaz-car.git
git push -u origin feature/clean-architecture
```

### Solution 3: Fork le repo (Si vous n'avez pas accès au repo illyees)

1. Fork le repo `illyees/occaz-car` sur votre compte GitHub
2. Changer l'origine :

```powershell
git remote set-url origin https://github.com/VOTRE_USERNAME/occaz-car.git
git push -u origin feature/clean-architecture
```

3. Créer une Pull Request vers le repo original

## Après avoir poussé la branche

Pour faire de `feature/clean-architecture` la branche principale :

### Méthode 1: Via GitHub (Recommandé)

1. Créer une Pull Request de `feature/clean-architecture` → `main`
2. Merger la PR
3. Settings → Branches → Change default branch → `feature/clean-architecture`

### Méthode 2: En ligne de commande

```powershell
# Sauvegarder l'ancienne main
git checkout main
git branch -m main old-main

# Renommer feature/clean-architecture en main
git checkout feature/clean-architecture
git branch -m feature/clean-architecture main

# Forcer la mise à jour sur GitHub
git push -f origin main

# Supprimer l'ancienne branche
git push origin --delete old-main
```

## État actuel du commit

✅ Commit créé: `1924b01`
✅ Message: "feat: Clean architecture implementation with modular structure"
✅ 75 fichiers modifiés, 6081 lignes ajoutées
✅ Prêt à être poussé

## Structure de l'architecture propre

```
lib/
├── main.dart (160 lignes)
├── models/
│   ├── demo_vehicle.dart
│   └── demo_user.dart
├── screens/
│   ├── login_screen.dart
│   ├── vehicles_list_screen.dart
│   ├── vehicle_details_screen.dart
│   ├── add_vehicle_screen.dart
│   └── profile_settings_screen.dart
├── widgets/
│   ├── vehicle_card.dart
│   ├── profile_screen.dart
│   └── my_vehicles_screen.dart
└── utils/
    └── demo_data.dart
```
