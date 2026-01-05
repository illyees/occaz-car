# 👥 Vendeurs Database - OccazCar

## Overview

Seller (vendeur) information has been added to the database with realistic Tunisian names, phone numbers, and locations.

---

## 🚗 Vehicles with Seller Information

### Vehicle 1: Peugeot 208

**Prix**: 32,000 DT
**Vendeur**: Ahmed Ben Ali

- 📞 Téléphone: +216 98 765 432
- 📍 Ville: Tunis
- 📧 Email: ahmed@example.com
- 🏷️ Role: Seller

**Description du vendeur**:
Vendeur professionnel basé à Tunis, spécialisé dans les véhicules français de petite cylindrée.

---

### Vehicle 2: Renault Clio 4

**Prix**: 28,500 DT
**Vendeur**: Fatima Gharbi

- 📞 Téléphone: +216 52 123 456
- 📍 Ville: Sfax
- 📧 Email: fatima@example.com
- 🏷️ Role: Seller

**Description du vendeur**:
Vendeuse particulière à Sfax, propose des véhicules d'occasion en excellent état avec historique complet.

---

### Vehicle 3: Volkswagen Golf 7

**Prix**: 42,000 DT
**Vendeur**: Mohamed Trabelsi

- 📞 Téléphone: +216 24 987 654
- 📍 Ville: Sousse
- 📧 Email: mohamed@example.com
- 🏷️ Role: Seller

**Description du vendeur**:
Concessionnaire à Sousse, expert en véhicules allemands haut de gamme avec garantie.

---

### Vehicle 4: Toyota Yaris

**Prix**: 38,000 DT
**Vendeur**: Leila Sassi

- 📞 Téléphone: +216 55 345 678
- 📍 Ville: Nabeul
- 📧 Email: leila@example.com
- 🏷️ Role: Seller

**Description du vendeur**:
Vendeuse professionnelle à Nabeul, spécialisée dans les véhicules asiatiques fiables et économiques.

---

## 📊 All Sellers in Database

### Active Sellers (Total: 11)

| ID  | Nom              | Email                   | Téléphone       | Ville  | Véhicules      |
| --- | ---------------- | ----------------------- | --------------- | ------ | -------------- |
| 7   | Ahmed Ben Ali    | ahmed@example.com       | +216 98 765 432 | Tunis  | Peugeot 208    |
| 8   | Fatima Gharbi    | fatima@example.com      | +216 52 123 456 | Sfax   | Renault Clio 4 |
| 9   | Mohamed Trabelsi | mohamed@example.com     | +216 24 987 654 | Sousse | VW Golf 7      |
| 10  | Leila Sassi      | leila@example.com       | +216 55 345 678 | Nabeul | Toyota Yaris   |
| 11  | Karim Bouazizi   | karim@example.com       | +216 29 876 543 | Ariana | -              |
| 27  | Mehdi Lahmar     | mehdi.lahmar@gmail.com  | +216 98 234 567 | Tunis  | -              |
| 28  | Amel Jaziri      | amel.jaziri@yahoo.fr    | +216 52 876 543 | Sousse | -              |
| 29  | Rami Bouzid      | rami.bouzid@hotmail.com | +216 24 567 890 | Sfax   | -              |
| 30  | Nesrine Hamdi    | nesrine.hamdi@gmail.com | +216 29 345 678 | Nabeul | -              |

---

## 🗺️ Sellers by City

### Tunis (2 sellers)

- Ahmed Ben Ali - ✅ Has vehicle (Peugeot 208)
- Mehdi Lahmar - 🆕 New seller

### Sfax (2 sellers)

- Fatima Gharbi - ✅ Has vehicle (Renault Clio 4)
- Rami Bouzid - 🆕 New seller

### Sousse (2 sellers)

- Mohamed Trabelsi - ✅ Has vehicle (VW Golf 7)
- Amel Jaziri - 🆕 New seller

### Nabeul (2 sellers)

- Leila Sassi - ✅ Has vehicle (Toyota Yaris)
- Nesrine Hamdi - 🆕 New seller

### Ariana (1 seller)

- Karim Bouazizi - Available for new listings

---

## 📱 Contact Information Format

All phone numbers follow the Tunisian format:

- Format: `+216 XX XXX XXX`
- Example: `+216 98 765 432`

---

## 🔍 Database Query Examples

### Get all vehicles with seller info:

```sql
SELECT
    v.id,
    v.marque,
    v.modele,
    v.prix,
    u.nom AS vendeur,
    u.telephone,
    u.email,
    u.ville AS ville_vendeur
FROM vehicles v
JOIN users u ON v.user_id = u.id
ORDER BY v.id;
```

### Get seller contact for specific vehicle:

```sql
SELECT
    v.marque,
    v.modele,
    u.nom AS vendeur,
    u.telephone,
    u.email
FROM vehicles v
JOIN users u ON v.user_id = u.id
WHERE v.id = 2;  -- Peugeot 208
```

### Get all vehicles by seller:

```sql
SELECT
    v.marque,
    v.modele,
    v.prix,
    v.annee,
    v.ville AS localisation
FROM vehicles v
WHERE v.user_id = 7;  -- Ahmed Ben Ali
```

---

## 🔧 Backend API Response

When fetching vehicles, the API now returns seller information:

```json
{
  "id": 2,
  "marque": "Peugeot",
  "modele": "208",
  "annee": 2020,
  "prix": 32000.0,
  "seller": {
    "id": 7,
    "nom": "Ahmed Ben Ali",
    "telephone": "+216 98 765 432",
    "email": "ahmed@example.com",
    "ville": "Tunis"
  }
}
```

---

## 📝 Notes

### Seller Profiles

- All sellers have unique email addresses
- Phone numbers use proper Tunisian format (+216)
- Sellers are distributed across major Tunisian cities
- Each seller has a specific role: 'seller' or 'both'

### Privacy Considerations

- Phone numbers are displayed for contact purposes
- Email addresses can be used for messaging
- Seller location (ville) helps buyers find nearby vehicles

### Future Enhancements

- Seller ratings and reviews
- Seller verification badges
- Seller response time tracking
- Number of active listings per seller
- Seller profile pages with all their listings

---

## ✅ Verification

To verify sellers are properly set up, run:

```powershell
# Check all sellers
mysql -u root -e "USE occazcar_db; SELECT id, nom, email, telephone, ville, role FROM users WHERE role IN ('seller', 'both') ORDER BY id;"

# Check vehicles with sellers
mysql -u root -e "USE occazcar_db; SELECT v.id, v.marque, v.modele, u.nom AS vendeur, u.telephone FROM vehicles v JOIN users u ON v.user_id = u.id;"
```

---

## 🎯 Status

✅ **Sellers Added**: 11 total sellers in database
✅ **Active Listings**: 4 vehicles with complete seller information
✅ **Cities Covered**: Tunis, Sfax, Sousse, Nabeul, Ariana
✅ **Contact Info**: All sellers have valid phone numbers and emails
✅ **Ready**: Backend can now display seller information with each vehicle

---

**Last Updated**: January 5, 2026
**Database**: occazcar_db
**Table**: users (sellers) + vehicles
**Status**: ✅ Complete
