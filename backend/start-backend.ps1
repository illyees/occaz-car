# Script de démarrage rapide du backend OccazCar
# Quick start script for OccazCar backend

Write-Host "🚀 OccazCar Backend - Script de démarrage" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

# Vérifier Node.js
Write-Host "1️⃣  Vérification de Node.js..." -ForegroundColor Cyan
try {
    $nodeVersion = node --version
    Write-Host "   ✅ Node.js installé: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Node.js n'est pas installé!" -ForegroundColor Red
    Write-Host "   📥 Téléchargez Node.js: https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# Vérifier MySQL
Write-Host ""
Write-Host "2️⃣  Vérification de MySQL..." -ForegroundColor Cyan
try {
    $mysqlVersion = mysql --version
    Write-Host "   ✅ MySQL installé: $mysqlVersion" -ForegroundColor Green
} catch {
    Write-Host "   ❌ MySQL n'est pas installé ou pas dans le PATH!" -ForegroundColor Red
    Write-Host "   📥 Téléchargez MySQL: https://dev.mysql.com/downloads/mysql/" -ForegroundColor Yellow
    Write-Host "   💡 Assurez-vous que MySQL bin est dans le PATH système" -ForegroundColor Yellow
    exit 1
}

# Vérifier si le service MySQL est démarré
Write-Host ""
Write-Host "3️⃣  Vérification du service MySQL..." -ForegroundColor Cyan
$mysqlService = Get-Service -Name MySQL* -ErrorAction SilentlyContinue | Where-Object {$_.Status -eq 'Running'}
if ($mysqlService) {
    Write-Host "   ✅ Service MySQL en cours d'exécution: $($mysqlService.Name)" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Service MySQL n'est pas démarré" -ForegroundColor Yellow
    Write-Host "   💡 Essayez: net start MySQL80 (ou le nom de votre service MySQL)" -ForegroundColor Yellow
    
    $response = Read-Host "   Voulez-vous essayer de démarrer MySQL? (O/N)"
    if ($response -eq 'O' -or $response -eq 'o') {
        try {
            net start MySQL80
            Write-Host "   ✅ Service MySQL démarré!" -ForegroundColor Green
        } catch {
            Write-Host "   ❌ Impossible de démarrer MySQL. Vérifiez le nom du service." -ForegroundColor Red
        }
    }
}

# Vérifier les dépendances npm
Write-Host ""
Write-Host "4️⃣  Vérification des dépendances npm..." -ForegroundColor Cyan
if (Test-Path "package.json") {
    if (Test-Path "node_modules") {
        Write-Host "   ✅ Dossier node_modules existe" -ForegroundColor Green
    } else {
        Write-Host "   📦 Installation des dépendances..." -ForegroundColor Yellow
        npm install
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ Dépendances installées avec succès!" -ForegroundColor Green
        } else {
            Write-Host "   ❌ Erreur lors de l'installation des dépendances" -ForegroundColor Red
            exit 1
        }
    }
} else {
    Write-Host "   ❌ Fichier package.json introuvable!" -ForegroundColor Red
    Write-Host "   💡 Assurez-vous d'être dans le dossier backend/" -ForegroundColor Yellow
    exit 1
}

# Vérifier le fichier .env
Write-Host ""
Write-Host "5️⃣  Vérification du fichier .env..." -ForegroundColor Cyan
if (Test-Path ".env") {
    Write-Host "   ✅ Fichier .env existe" -ForegroundColor Green
    
    # Lire et afficher la configuration (sans le mot de passe)
    $envContent = Get-Content ".env"
    Write-Host "   📋 Configuration actuelle:" -ForegroundColor Cyan
    foreach ($line in $envContent) {
        if ($line -match "^DB_HOST=(.+)$") {
            Write-Host "      DB_HOST: $($matches[1])" -ForegroundColor White
        }
        if ($line -match "^DB_USER=(.+)$") {
            Write-Host "      DB_USER: $($matches[1])" -ForegroundColor White
        }
        if ($line -match "^DB_NAME=(.+)$") {
            Write-Host "      DB_NAME: $($matches[1])" -ForegroundColor White
        }
        if ($line -match "^PORT=(.+)$") {
            Write-Host "      PORT: $($matches[1])" -ForegroundColor White
        }
    }
} else {
    Write-Host "   ⚠️  Fichier .env introuvable!" -ForegroundColor Yellow
    if (Test-Path ".env.example") {
        $response = Read-Host "   Voulez-vous créer .env à partir de .env.example? (O/N)"
        if ($response -eq 'O' -or $response -eq 'o') {
            Copy-Item ".env.example" ".env"
            Write-Host "   ✅ Fichier .env créé!" -ForegroundColor Green
            Write-Host "   ⚠️  IMPORTANT: Modifiez .env avec vos paramètres MySQL!" -ForegroundColor Yellow
            Write-Host "   💡 Notamment DB_PASSWORD avec votre mot de passe MySQL root" -ForegroundColor Yellow
            
            $response2 = Read-Host "   Voulez-vous éditer .env maintenant? (O/N)"
            if ($response2 -eq 'O' -or $response2 -eq 'o') {
                notepad .env
            }
        }
    } else {
        Write-Host "   ❌ Fichier .env.example introuvable!" -ForegroundColor Red
        exit 1
    }
}

# Vérifier la base de données
Write-Host ""
Write-Host "6️⃣  Vérification de la base de données..." -ForegroundColor Cyan
Write-Host "   💡 Vous devrez peut-être entrer votre mot de passe MySQL root" -ForegroundColor Yellow

$dbCheck = Read-Host "   Voulez-vous vérifier si la base de données existe? (O/N)"
if ($dbCheck -eq 'O' -or $dbCheck -eq 'o') {
    Write-Host "   📝 Entrez votre mot de passe MySQL root..." -ForegroundColor Cyan
    $checkCmd = "mysql -u root -p -e 'USE occazcar_db; SHOW TABLES;'"
    
    try {
        $output = Invoke-Expression $checkCmd 2>&1
        if ($output -match "Tables_in_occazcar_db") {
            Write-Host "   ✅ Base de données occazcar_db existe avec des tables!" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️  Base de données introuvable ou vide" -ForegroundColor Yellow
            $createDb = Read-Host "   Voulez-vous créer la base de données? (O/N)"
            if ($createDb -eq 'O' -or $createDb -eq 'o') {
                Write-Host "   📝 Exécution du script SQL..." -ForegroundColor Cyan
                if (Test-Path "database\schema.sql") {
                    mysql -u root -p occazcar_db < database\schema.sql
                    Write-Host "   ✅ Base de données créée avec succès!" -ForegroundColor Green
                } else {
                    Write-Host "   ❌ Fichier database\schema.sql introuvable!" -ForegroundColor Red
                }
            }
        }
    } catch {
        Write-Host "   ❌ Erreur lors de la vérification de la base de données" -ForegroundColor Red
        Write-Host "   💡 Vérifiez vos identifiants MySQL dans .env" -ForegroundColor Yellow
    }
}

# Démarrer le serveur
Write-Host ""
Write-Host "7️⃣  Prêt à démarrer le serveur!" -ForegroundColor Cyan
Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "✅ Vérifications terminées!" -ForegroundColor Green
Write-Host ""

$startServer = Read-Host "Voulez-vous démarrer le serveur maintenant? (O/N)"
if ($startServer -eq 'O' -or $startServer -eq 'o') {
    Write-Host ""
    Write-Host "🚀 Démarrage du serveur OccazCar..." -ForegroundColor Green
    Write-Host "   Appuyez sur Ctrl+C pour arrêter le serveur" -ForegroundColor Yellow
    Write-Host ""
    
    npm start
} else {
    Write-Host ""
    Write-Host "💡 Pour démarrer le serveur manuellement, exécutez:" -ForegroundColor Cyan
    Write-Host "   npm start" -ForegroundColor White
    Write-Host ""
    Write-Host "📚 Pour plus d'informations, consultez:" -ForegroundColor Cyan
    Write-Host "   - backend\README.md" -ForegroundColor White
    Write-Host "   - ..\INTEGRATION_GUIDE.md" -ForegroundColor White
    Write-Host ""
}
