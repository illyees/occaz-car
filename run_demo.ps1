# Script pour lancer la démo UI (sans Firebase)

Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "  OccazCar - Demo UI (Sans Backend)  " -ForegroundColor Cyan
Write-Host "======================================`n" -ForegroundColor Cyan

# Sauvegarder les fichiers originaux
Write-Host "1. Sauvegarde..." -ForegroundColor Yellow
Copy-Item "pubspec.yaml" "pubspec_backup_demo.yaml" -Force -ErrorAction SilentlyContinue
Copy-Item "lib\main.dart" "lib\main_backup_demo.dart" -Force -ErrorAction SilentlyContinue

# Copier les fichiers de démo
Write-Host "2. Configuration demo..." -ForegroundColor Yellow
Copy-Item "pubspec_demo.yaml" "pubspec.yaml" -Force
Copy-Item "lib\main_demo.dart" "lib\main.dart" -Force

# Nettoyage et installation
Write-Host "3. Nettoyage..." -ForegroundColor Yellow
flutter clean | Out-Null

Write-Host "4. Installation..." -ForegroundColor Yellow
flutter pub get

# Lancer l'app
Write-Host "`n5. Lancement sur Chrome...`n" -ForegroundColor Green
flutter run -d chrome

# Restaurer après l'arrêt
Write-Host "`n`nRestauration des fichiers originaux..." -ForegroundColor Yellow
Copy-Item "pubspec_backup_demo.yaml" "pubspec.yaml" -Force -ErrorAction SilentlyContinue
Copy-Item "lib\main_backup_demo.dart" "lib\main.dart" -Force -ErrorAction SilentlyContinue

Write-Host "Termine!" -ForegroundColor Green
