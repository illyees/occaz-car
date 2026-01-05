-- Add more realistic seller users with Tunisian names
INSERT INTO users (nom, email, telephone, password, role, ville, created_at) 
VALUES 
('Mehdi Lahmar', 'mehdi.lahmar@gmail.com', '+216 98 234 567', '$2b$10$dummyHashPasswordForDemoPurposesOnly1234567890', 'seller', 'Tunis', NOW()),
('Amel Jaziri', 'amel.jaziri@yahoo.fr', '+216 52 876 543', '$2b$10$dummyHashPasswordForDemoPurposesOnly1234567890', 'seller', 'Sousse', NOW()),
('Rami Bouzid', 'rami.bouzid@hotmail.com', '+216 24 567 890', '$2b$10$dummyHashPasswordForDemoPurposesOnly1234567890', 'seller', 'Sfax', NOW()),
('Nesrine Hamdi', 'nesrine.hamdi@gmail.com', '+216 29 345 678', '$2b$10$dummyHashPasswordForDemoPurposesOnly1234567890', 'seller', 'Nabeul', NOW());

-- Update existing vehicles to have different sellers for variety
UPDATE vehicles SET user_id = 7 WHERE id = 2;  -- Peugeot 208 -> Ahmed Ben Ali
UPDATE vehicles SET user_id = 8 WHERE id = 3;  -- Renault Clio 4 -> Fatima Gharbi
UPDATE vehicles SET user_id = 9 WHERE id = 4;  -- VW Golf 7 -> Mohamed Trabelsi
UPDATE vehicles SET user_id = 10 WHERE id = 5; -- Toyota Yaris -> Leila Sassi
