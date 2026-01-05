-- Base de données OccazCar
CREATE DATABASE IF NOT EXISTS occazcar_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE occazcar_db;

-- Table des utilisateurs
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  telephone VARCHAR(20),
  ville VARCHAR(100),
  role ENUM('buyer', 'seller', 'both') DEFAULT 'both',
  photo_url VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des véhicules
CREATE TABLE IF NOT EXISTS vehicles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  marque VARCHAR(100) NOT NULL,
  modele VARCHAR(100) NOT NULL,
  annee INT NOT NULL,
  prix DECIMAL(10, 2) NOT NULL,
  kilometrage INT NOT NULL,
  carburant ENUM('Essence', 'Diesel', 'Hybride', 'Électrique') NOT NULL,
  boite ENUM('Manuelle', 'Automatique') NOT NULL,
  ville VARCHAR(100) NOT NULL,
  description TEXT,
  images TEXT, -- JSON array of image URLs
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  status ENUM('active', 'sold', 'inactive') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_status (status),
  INDEX idx_ville (ville)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des favoris
CREATE TABLE IF NOT EXISTS favorites (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  vehicle_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE,
  UNIQUE KEY unique_favorite (user_id, vehicle_id),
  INDEX idx_user_vehicle (user_id, vehicle_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table de l'historique des véhicules
CREATE TABLE IF NOT EXISTS vehicle_history (
  id INT AUTO_INCREMENT PRIMARY KEY,
  vehicle_id INT NOT NULL,
  type ENUM('maintenance', 'reparation', 'accident') NOT NULL,
  titre VARCHAR(200) NOT NULL,
  description TEXT,
  date DATE NOT NULL,
  cout DECIMAL(10, 2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE,
  INDEX idx_vehicle_id (vehicle_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insérer un utilisateur de test
INSERT INTO users (nom, email, password, telephone, ville, role) VALUES
('Utilisateur Demo', 'demo@occazcar.tn', '$2a$10$YourHashedPasswordHere', '+216 20 123 456', 'Tunis', 'both');

-- Afficher le message de succès
SELECT 'Base de données créée avec succès!' as message;
