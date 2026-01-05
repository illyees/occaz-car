# Script pour lancer OccazCar en mode test (sans Firebase)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  OccazCar - Mode Test (Sans Firebase)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Sauvegarder les fichiers originaux
Write-Host "1. Sauvegarde des fichiers..." -ForegroundColor Yellow
Copy-Item "lib\main.dart" "lib\main_backup.dart" -Force
Copy-Item "pubspec.yaml" "pubspec_backup.yaml" -Force

# Remplacer par les versions mock
Write-Host "2. Configuration mode test..." -ForegroundColor Yellow
Copy-Item "lib\main_mock.dart" "lib\main.dart" -Force
Copy-Item "pubspec_mock.yaml" "pubspec.yaml" -Force

# Nettoyer et installer
Write-Host "3. Nettoyage..." -ForegroundColor Yellow
flutter clean | Out-Null

Write-Host "4. Installation des dépendances..." -ForegroundColor Yellow
flutter pub get

# Lancer sur Chrome
Write-Host ""
Write-Host "5. Lancement de l'application sur Chrome..." -ForegroundColor Green
Write-Host ""
flutter run -d chrome

# Restaurer les fichiers originaux
Write-Host ""
Write-Host "Restauration des fichiers originaux..." -ForegroundColor Yellow
Copy-Item "lib\main_backup.dart" "lib\main.dart" -Force
Copy-Item "pubspec_backup.yaml" "pubspec.yaml" -Force
Remove-Item "lib\main_backup.dart"
Remove-Item "pubspec_backup.yaml"

Write-Host ""
Write-Host "Terminé!" -ForegroundColor Green
