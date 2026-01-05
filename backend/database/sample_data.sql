-- Sample data for OccazCar database
-- Run this after schema.sql to populate the database with test vehicles

USE occazcar_db;

-- First, check if sample users exist, if not create them
-- (Using INSERT IGNORE to skip if emails already exist)
INSERT IGNORE INTO users (nom, email, password, telephone, ville, role, created_at) VALUES
('Ahmed Ben Ali', 'ahmed@example.com', '$2a$10$rZ8qN0K8h0sV5qW9xC3yX.vW0qV0K8h0sV5qW9xC3yX.vW0qV0K8h0', '+216 98 765 432', 'Tunis', 'seller', NOW()),
('Fatima Gharbi', 'fatima@example.com', '$2a$10$rZ8qN0K8h0sV5qW9xC3yX.vW0qV0K8h0sV5qW9xC3yX.vW0qV0K8h0', '+216 52 123 456', 'Sfax', 'seller', NOW()),
('Mohamed Trabelsi', 'mohamed@example.com', '$2a$10$rZ8qN0K8h0sV5qW9xC3yX.vW0qV0K8h0sV5qW9xC3yX.vW0qV0K8h0', '+216 24 987 654', 'Sousse', 'seller', NOW()),
('Leila Sassi', 'leila@example.com', '$2a$10$rZ8qN0K8h0sV5qW9xC3yX.vW0qV0K8h0sV5qW9xC3yX.vW0qV0K8h0', '+216 55 345 678', 'Nabeul', 'seller', NOW()),
('Karim Bouazizi', 'karim@example.com', '$2a$10$rZ8qN0K8h0sV5qW9xC3yX.vW0qV0K8h0sV5qW9xC3yX.vW0qV0K8h0', '+216 29 876 543', 'Ariana', 'seller', NOW());

-- Get user IDs for our sample sellers
SET @user1 = (SELECT id FROM users WHERE email = 'ahmed@example.com' LIMIT 1);
SET @user2 = (SELECT id FROM users WHERE email = 'fatima@example.com' LIMIT 1);
SET @user3 = (SELECT id FROM users WHERE email = 'mohamed@example.com' LIMIT 1);
SET @user4 = (SELECT id FROM users WHERE email = 'leila@example.com' LIMIT 1);
SET @user5 = (SELECT id FROM users WHERE email = 'karim@example.com' LIMIT 1);

-- Now insert sample vehicles (using user IDs from above)

-- Peugeot 208
INSERT INTO vehicles (user_id, marque, modele, annee, prix, kilometrage, carburant, boite, ville, description, status, images, created_at) VALUES
(@user1, 'Peugeot', '208', 2020, 32000, 45000, 'Essence', 'Manuelle', 'Tunis', 'Peugeot 208 en excellent état, première main. Entretien régulier chez concessionnaire agréé. Climatisation, radio Bluetooth, jantes alliage.', 'active', '["https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=800", "https://images.unsplash.com/photo-1583267746897-c4342abd9c88?w=800"]', NOW()),

-- Renault Clio
(@user2, 'Renault', 'Clio 4', 2019, 28500, 62000, 'Diesel', 'Manuelle', 'Sfax', 'Renault Clio 4 diesel économique, parfaite pour ville et autoroute. Très bon état général, non fumeur. GPS intégré, caméra de recul.', 'active', '["https://images.unsplash.com/photo-1617531653332-bd46c24f2068?w=800"]', NOW()),

-- Volkswagen Golf
(@user1, 'Volkswagen', 'Golf 7', 2018, 42000, 78000, 'Diesel', 'Automatique', 'Tunis', 'Golf 7 GTD, boîte automatique DSG. Finition haut de gamme avec sièges cuir, toit panoramique, système multimédia tactile. Véhicule très bien entretenu.', 'active', '["https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800", "https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=800"]', NOW()),

-- Toyota Yaris
(@user3, 'Toyota', 'Yaris', 2021, 38000, 25000, 'Hybride', 'Automatique', 'Sousse', 'Toyota Yaris hybride presque neuve, encore sous garantie constructeur. Faible kilométrage, économie de carburant exceptionnelle. Parfait état.', 'active', '["https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=800"]', NOW()),

-- Fiat 500
(@user4, 'Fiat', '500', 2017, 18500, 95000, 'Essence', 'Manuelle', 'Nabeul', 'Petite citadine idéale pour la ville. Fiat 500 rouge, très mignonne et pratique. Climatisation, direction assistée, consommation réduite.', 'active', '["https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800"]', NOW()),

-- Mercedes Classe A
(@user5, 'Mercedes-Benz', 'Classe A', 2020, 78000, 35000, 'Diesel', 'Automatique', 'Ariana', 'Mercedes Classe A AMG Line, intérieur cuir noir, écran MBUX, pack LED, caméra 360°. Véhicule premium en excellent état.', 'active', '["https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=800", "https://images.unsplash.com/photo-1617531653520-bd788419a87c?w=800"]', NOW()),

-- Dacia Sandero
(@user2, 'Dacia', 'Sandero Stepway', 2019, 24000, 55000, 'Essence', 'Manuelle', 'Sfax', 'Dacia Sandero Stepway, spacieuse et économique. Parfaite pour famille. Très fiable, entretien complet à jour.', 'active', '["https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=800"]', NOW()),

-- Kia Sportage
(@user3, 'Kia', 'Sportage', 2018, 52000, 68000, 'Diesel', 'Automatique', 'Sousse', 'SUV Kia Sportage, 7 places, idéal pour voyages en famille. Moteur diesel puissant, boîte auto, GPS, caméra, radar de recul.', 'active', '["https://images.unsplash.com/photo-1619767886558-efdc259cde1a?w=800"]', NOW()),

-- BMW Série 3
(@user1, 'BMW', 'Série 3', 2019, 68000, 52000, 'Diesel', 'Automatique', 'Tunis', 'BMW 320d pack M Sport. Intérieur cuir Dakota, volant sport, jantes 19", système audio Harman Kardon. État impeccable.', 'active', '["https://images.unsplash.com/photo-1555215695-3004980ad54e?w=800", "https://images.unsplash.com/photo-1617531653520-bd788419a87c?w=800"]', NOW()),

-- Hyundai i20
(@user4, 'Hyundai', 'i20', 2020, 29000, 38000, 'Essence', 'Manuelle', 'Nabeul', 'Hyundai i20 récente, garantie constructeur restante. Climatisation automatique, écran tactile, Bluetooth. Très économique.', 'active', '["https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=800"]', NOW()),

-- Peugeot 3008
(@user5, 'Peugeot', '3008 GT', 2021, 85000, 22000, 'Diesel', 'Automatique', 'Ariana', 'SUV Peugeot 3008 GT, finition haut de gamme. i-Cockpit 3D, sièges massants, toit panoramique, aides à la conduite. Comme neuf.', 'active', '["https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=800", "https://images.unsplash.com/photo-1617531653332-bd46c24f2068?w=800"]', NOW()),

-- Citroën C3
(@user2, 'Citroën', 'C3', 2018, 22000, 72000, 'Essence', 'Manuelle', 'Sfax', 'Citroën C3 grise, confortable et spacieuse. Idéale premier véhicule. Entretien régulier, bon état général.', 'active', '["https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=800"]', NOW()),

-- Nissan Qashqai
(@user3, 'Nissan', 'Qashqai', 2019, 48000, 58000, 'Diesel', 'Manuelle', 'Sousse', 'Nissan Qashqai crossover, polyvalent et confortable. Caméra 360°, toit ouvrant, sièges chauffants. Excellent état.', 'active', '["https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=800"]', NOW()),

-- Audi A3
(@user1, 'Audi', 'A3 Sportback', 2020, 62000, 42000, 'Diesel', 'Automatique', 'Tunis', 'Audi A3 Sportback S-Line, cockpit virtuel, phares LED Matrix, sellerie cuir/alcantara. Véhicule premium parfaitement entretenu.', 'active', '["https://images.unsplash.com/photo-1610768764270-790fbec18178?w=800", "https://images.unsplash.com/photo-1617531653520-bd788419a87c?w=800"]', NOW()),

-- Seat Ibiza
(@user4, 'Seat', 'Ibiza', 2019, 26000, 48000, 'Essence', 'Manuelle', 'Nabeul', 'Seat Ibiza dynamique, parfaite pour jeune conducteur. Économique, fiable, facile à conduire. Climatisation, GPS.', 'active', '["https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=800"]', NOW());

-- Add some vehicle history for better realism (maintenance records)
-- Note: vehicle_id will be the actual IDs after insertion
INSERT INTO vehicle_history (vehicle_id, type, titre, description, date, cout, created_at) 
SELECT id, 'maintenance', 'Révision complète + changement huile', 'Révision des 40000 km avec changement d\'huile moteur et filtres', '2023-06-15', 350, NOW()
FROM vehicles WHERE marque = 'Peugeot' AND modele = '208' LIMIT 1;

INSERT INTO vehicle_history (vehicle_id, type, titre, description, date, cout, created_at)
SELECT id, 'reparation', 'Changement plaquettes de frein', 'Remplacement des plaquettes de frein avant et arrière', '2023-09-20', 280, NOW()
FROM vehicles WHERE marque = 'Peugeot' AND modele = '208' LIMIT 1;

INSERT INTO vehicle_history (vehicle_id, type, titre, description, date, cout, created_at)
SELECT id, 'maintenance', 'Grande révision 80000 km', 'Révision complète avec distribution et bougies', '2023-08-10', 650, NOW()
FROM vehicles WHERE marque = 'Volkswagen' AND modele = 'Golf 7' LIMIT 1;

INSERT INTO vehicle_history (vehicle_id, type, titre, description, date, cout, created_at)
SELECT id, 'maintenance', 'Révision 30000 km', 'Entretien périodique chez concessionnaire Mercedes', '2023-10-05', 420, NOW()
FROM vehicles WHERE marque = 'Mercedes-Benz' AND modele = 'Classe A' LIMIT 1;

INSERT INTO vehicle_history (vehicle_id, type, titre, description, date, cout, created_at)
SELECT id, 'maintenance', 'Révision annuelle', 'Contrôle général et entretien annuel', '2023-07-22', 480, NOW()
FROM vehicles WHERE marque = 'BMW' AND modele = 'Série 3' LIMIT 1;

COMMIT;

-- Display summary
SELECT 
    'Véhicules ajoutés' as Info,
    COUNT(*) as Total 
FROM vehicles;

SELECT 
    marque,
    COUNT(*) as Nombre
FROM vehicles
GROUP BY marque
ORDER BY Nombre DESC;
