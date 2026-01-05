const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
require("dotenv").config();

const db = require("./config/database");

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// JWT secret
const JWT_SECRET = process.env.JWT_SECRET || "occazcar_secret_key_2024";

// Middleware d'authentification
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];

  if (!token) {
    return res.status(401).json({ error: "Token manquant" });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: "Token invalide" });
    }
    req.user = user;
    next();
  });
};

// ==================== ROUTES D'AUTHENTIFICATION ====================

// Inscription
app.post("/api/auth/register", async (req, res) => {
  try {
    const { nom, email, password, telephone, ville, role } = req.body;

    // Validation
    if (!nom || !email || !password) {
      return res
        .status(400)
        .json({ error: "Nom, email et mot de passe sont requis" });
    }

    // Vérifier si l'utilisateur existe déjà
    const [existingUsers] = await db.query(
      "SELECT id FROM users WHERE email = ?",
      [email]
    );

    if (existingUsers.length > 0) {
      return res.status(409).json({ error: "Cet email est déjà utilisé" });
    }

    // Hasher le mot de passe
    const hashedPassword = await bcrypt.hash(password, 10);

    // Insérer l'utilisateur
    const [result] = await db.query(
      "INSERT INTO users (nom, email, password, telephone, ville, role) VALUES (?, ?, ?, ?, ?, ?)",
      [
        nom,
        email,
        hashedPassword,
        telephone || null,
        ville || null,
        role || "both",
      ]
    );

    // Récupérer l'utilisateur créé
    const [users] = await db.query(
      "SELECT id, nom, email, telephone, ville, role, created_at FROM users WHERE id = ?",
      [result.insertId]
    );

    const user = users[0];

    // Générer le token JWT
    const token = jwt.sign({ id: user.id, email: user.email }, JWT_SECRET, {
      expiresIn: "7d",
    });

    res.status(201).json({
      message: "Utilisateur créé avec succès",
      token,
      user: {
        id: user.id,
        nom: user.nom,
        email: user.email,
        telephone: user.telephone,
        ville: user.ville,
        role: user.role,
      },
    });
  } catch (error) {
    console.error("Erreur lors de l'inscription:", error);
    res.status(500).json({ error: "Erreur serveur lors de l'inscription" });
  }
});

// Connexion
app.post("/api/auth/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    // Validation
    if (!email || !password) {
      return res
        .status(400)
        .json({ error: "Email et mot de passe sont requis" });
    }

    // Chercher l'utilisateur
    const [users] = await db.query(
      "SELECT id, nom, email, password, telephone, ville, role FROM users WHERE email = ?",
      [email]
    );

    if (users.length === 0) {
      return res.status(401).json({ error: "Email ou mot de passe incorrect" });
    }

    const user = users[0];

    // Vérifier le mot de passe
    const isValidPassword = await bcrypt.compare(password, user.password);
    if (!isValidPassword) {
      return res.status(401).json({ error: "Email ou mot de passe incorrect" });
    }

    // Générer le token JWT
    const token = jwt.sign({ id: user.id, email: user.email }, JWT_SECRET, {
      expiresIn: "7d",
    });

    res.json({
      message: "Connexion réussie",
      token,
      user: {
        id: user.id,
        nom: user.nom,
        email: user.email,
        telephone: user.telephone,
        ville: user.ville,
        role: user.role,
      },
    });
  } catch (error) {
    console.error("Erreur lors de la connexion:", error);
    res.status(500).json({ error: "Erreur serveur lors de la connexion" });
  }
});

// Obtenir le profil utilisateur (route protégée)
app.get("/api/auth/profile", authenticateToken, async (req, res) => {
  try {
    const [users] = await db.query(
      "SELECT id, nom, email, telephone, ville, role, photo_url, created_at FROM users WHERE id = ?",
      [req.user.id]
    );

    if (users.length === 0) {
      return res.status(404).json({ error: "Utilisateur non trouvé" });
    }

    res.json({ user: users[0] });
  } catch (error) {
    console.error("Erreur lors de la récupération du profil:", error);
    res.status(500).json({ error: "Erreur serveur" });
  }
});

// Mettre à jour le profil utilisateur (route protégée)
app.put("/api/auth/profile", authenticateToken, async (req, res) => {
  try {
    const { nom, telephone, ville, photo_url } = req.body;

    const [result] = await db.query(
      "UPDATE users SET nom = ?, telephone = ?, ville = ?, photo_url = ? WHERE id = ?",
      [nom, telephone, ville, photo_url, req.user.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: "Utilisateur non trouvé" });
    }

    // Récupérer le profil mis à jour
    const [users] = await db.query(
      "SELECT id, nom, email, telephone, ville, role, photo_url FROM users WHERE id = ?",
      [req.user.id]
    );

    res.json({
      message: "Profil mis à jour avec succès",
      user: users[0],
    });
  } catch (error) {
    console.error("Erreur lors de la mise à jour du profil:", error);
    res.status(500).json({ error: "Erreur serveur" });
  }
});

// ==================== ROUTES DES VÉHICULES ====================

// Créer une annonce de véhicule (route protégée)
app.post("/api/vehicles", authenticateToken, async (req, res) => {
  try {
    const {
      marque,
      modele,
      annee,
      prix,
      kilometrage,
      carburant,
      boite,
      ville,
      description,
      images,
      latitude,
      longitude,
    } = req.body;

    // Validation
    if (
      !marque ||
      !modele ||
      !annee ||
      !prix ||
      !kilometrage ||
      !carburant ||
      !boite ||
      !ville
    ) {
      return res
        .status(400)
        .json({ error: "Tous les champs requis doivent être remplis" });
    }

    const imagesJson = images ? JSON.stringify(images) : null;

    const [result] = await db.query(
      `INSERT INTO vehicles 
       (user_id, marque, modele, annee, prix, kilometrage, carburant, boite, ville, description, images, latitude, longitude) 
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        req.user.id,
        marque,
        modele,
        annee,
        prix,
        kilometrage,
        carburant,
        boite,
        ville,
        description || null,
        imagesJson,
        latitude || null,
        longitude || null,
      ]
    );

    res.status(201).json({
      message: "Annonce créée avec succès",
      vehicleId: result.insertId,
    });
  } catch (error) {
    console.error("Erreur lors de la création de l'annonce:", error);
    res
      .status(500)
      .json({ error: "Erreur serveur lors de la création de l'annonce" });
  }
});

// Obtenir tous les véhicules
app.get("/api/vehicles", async (req, res) => {
  try {
    const { ville, marque, minPrix, maxPrix, carburant, boite } = req.query;

    let query = `
      SELECT v.*, u.nom as vendeur_nom, u.telephone as vendeur_telephone, u.ville as vendeur_ville
      FROM vehicles v
      JOIN users u ON v.user_id = u.id
      WHERE v.status = 'active'
    `;
    const params = [];

    if (ville) {
      query += " AND v.ville = ?";
      params.push(ville);
    }
    if (marque) {
      query += " AND v.marque = ?";
      params.push(marque);
    }
    if (minPrix) {
      query += " AND v.prix >= ?";
      params.push(parseFloat(minPrix));
    }
    if (maxPrix) {
      query += " AND v.prix <= ?";
      params.push(parseFloat(maxPrix));
    }
    if (carburant) {
      query += " AND v.carburant = ?";
      params.push(carburant);
    }
    if (boite) {
      query += " AND v.boite = ?";
      params.push(boite);
    }

    query += " ORDER BY v.created_at DESC";

    const [vehicles] = await db.query(query, params);

    // Parser les images JSON
    const vehiclesWithImages = vehicles.map((v) => ({
      ...v,
      images: v.images ? JSON.parse(v.images) : [],
    }));

    res.json({ vehicles: vehiclesWithImages });
  } catch (error) {
    console.error("Erreur lors de la récupération des véhicules:", error);
    res.status(500).json({ error: "Erreur serveur" });
  }
});

// Obtenir un véhicule par ID
app.get("/api/vehicles/:id", async (req, res) => {
  try {
    const [vehicles] = await db.query(
      `SELECT v.*, u.nom as vendeur_nom, u.telephone as vendeur_telephone, u.ville as vendeur_ville, u.photo_url as vendeur_photo
       FROM vehicles v
       JOIN users u ON v.user_id = u.id
       WHERE v.id = ?`,
      [req.params.id]
    );

    if (vehicles.length === 0) {
      return res.status(404).json({ error: "Véhicule non trouvé" });
    }

    const vehicle = {
      ...vehicles[0],
      images: vehicles[0].images ? JSON.parse(vehicles[0].images) : [],
    };

    res.json({ vehicle });
  } catch (error) {
    console.error("Erreur lors de la récupération du véhicule:", error);
    res.status(500).json({ error: "Erreur serveur" });
  }
});

// Obtenir les véhicules d'un utilisateur (route protégée)
app.get("/api/vehicles/user/me", authenticateToken, async (req, res) => {
  try {
    const [vehicles] = await db.query(
      "SELECT * FROM vehicles WHERE user_id = ? ORDER BY created_at DESC",
      [req.user.id]
    );

    const vehiclesWithImages = vehicles.map((v) => ({
      ...v,
      images: v.images ? JSON.parse(v.images) : [],
    }));

    res.json({ vehicles: vehiclesWithImages });
  } catch (error) {
    console.error(
      "Erreur lors de la récupération des véhicules de l'utilisateur:",
      error
    );
    res.status(500).json({ error: "Erreur serveur" });
  }
});

// Mettre à jour un véhicule (route protégée)
app.put("/api/vehicles/:id", authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const {
      marque,
      modele,
      annee,
      prix,
      kilometrage,
      carburant,
      boite,
      ville,
      description,
      images,
      status,
    } = req.body;

    // Vérifier que l'utilisateur est le propriétaire
    const [vehicles] = await db.query(
      "SELECT user_id FROM vehicles WHERE id = ?",
      [id]
    );

    if (vehicles.length === 0) {
      return res.status(404).json({ error: "Véhicule non trouvé" });
    }

    if (vehicles[0].user_id !== req.user.id) {
      return res
        .status(403)
        .json({ error: "Non autorisé à modifier ce véhicule" });
    }

    const imagesJson = images ? JSON.stringify(images) : null;

    const [result] = await db.query(
      `UPDATE vehicles SET 
       marque = ?, modele = ?, annee = ?, prix = ?, kilometrage = ?,
       carburant = ?, boite = ?, ville = ?, description = ?, images = ?, status = ?
       WHERE id = ?`,
      [
        marque,
        modele,
        annee,
        prix,
        kilometrage,
        carburant,
        boite,
        ville,
        description,
        imagesJson,
        status || "active",
        id,
      ]
    );

    res.json({ message: "Véhicule mis à jour avec succès" });
  } catch (error) {
    console.error("Erreur lors de la mise à jour du véhicule:", error);
    res.status(500).json({ error: "Erreur serveur" });
  }
});

// Supprimer un véhicule (route protégée)
app.delete("/api/vehicles/:id", authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;

    // Vérifier que l'utilisateur est le propriétaire
    const [vehicles] = await db.query(
      "SELECT user_id FROM vehicles WHERE id = ?",
      [id]
    );

    if (vehicles.length === 0) {
      return res.status(404).json({ error: "Véhicule non trouvé" });
    }

    if (vehicles[0].user_id !== req.user.id) {
      return res
        .status(403)
        .json({ error: "Non autorisé à supprimer ce véhicule" });
    }

    await db.query("DELETE FROM vehicles WHERE id = ?", [id]);

    res.json({ message: "Véhicule supprimé avec succès" });
  } catch (error) {
    console.error("Erreur lors de la suppression du véhicule:", error);
    res.status(500).json({ error: "Erreur serveur" });
  }
});

// ==================== ROUTE DE TEST ====================

app.get("/", (req, res) => {
  res.json({
    message: "API OccazCar - Backend MySQL",
    version: "1.0.0",
    endpoints: {
      auth: [
        "POST /api/auth/register",
        "POST /api/auth/login",
        "GET /api/auth/profile",
        "PUT /api/auth/profile",
      ],
      vehicles: [
        "POST /api/vehicles",
        "GET /api/vehicles",
        "GET /api/vehicles/:id",
        "GET /api/vehicles/user/me",
        "PUT /api/vehicles/:id",
        "DELETE /api/vehicles/:id",
      ],
    },
  });
});

// Démarrer le serveur
app.listen(PORT, () => {
  console.log(`✅ Serveur OccazCar démarré sur le port ${PORT}`);
  console.log(`🔗 API disponible sur http://localhost:${PORT}`);
});

module.exports = app;
