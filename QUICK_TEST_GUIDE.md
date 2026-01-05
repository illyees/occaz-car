# 🧪 Quick Start Testing Guide

## ⚡ Fast Track to Testing

### Step 1: Start Backend (30 seconds)

```powershell
cd backend
node server.js
```

**Look for:**

```
✓ Serveur démarré sur le port 3000
✓ Base de données MySQL connectée
```

---

### Step 2: Start Flutter App (1 minute)

```powershell
# From project root
flutter run
```

**Or press F5 in VS Code**

---

### Step 3: Create Your First Account (1 minute)

1. Click **"Créer un compte"**
2. Fill in:
   ```
   Nom complet:     John Doe
   Email:           john@test.com
   Téléphone:       +33612345678
   Mot de passe:    test123
   Confirmer:       test123
   ```
3. Click **"S'inscrire"**
4. ✅ Success message appears → Returns to login

---

### Step 4: Login (30 seconds)

1. Enter:
   ```
   Email:          john@test.com
   Mot de passe:   test123
   ```
2. Click **"Se connecter"**
3. ✅ Loading spinner → Home screen appears

---

### Step 5: Add Your First Vehicle (2 minutes)

1. Click **"Publier une annonce"** (blue floating button)
2. Fill in:
   ```
   Marque:         Peugeot
   Modèle:         208
   Année:          2020
   Prix (DT):      25000
   Kilométrage:    45000
   Carburant:      Essence (dropdown)
   Boîte:          Automatique (dropdown)
   Ville:          Tunis (dropdown)
   Description:    Excellente condition, première main
   ```
3. Click **"Publier l'annonce"**
4. ✅ Loading → Success message → Returns to home
5. ✅ Your vehicle appears in the list!

---

### Step 6: Verify in Database (30 seconds)

```powershell
mysql -u root -e "USE occazcar_db; SELECT * FROM users;"
mysql -u root -e "USE occazcar_db; SELECT * FROM vehicles;"
```

**You should see:**

- ✅ Your user account in `users` table
- ✅ Your vehicle in `vehicles` table
- ✅ `user_id` in vehicles matches your user ID

---

## 🎯 Expected Results

### ✅ What Should Work

1. **Registration**

   - Creates user in MySQL with hashed password
   - Shows success message
   - Returns to login screen

2. **Login**

   - Validates credentials against MySQL
   - Stores JWT token in app
   - Navigates to home screen
   - Token persists across app restarts

3. **View Vehicles**

   - Loads all vehicles from database
   - Shows empty state if no vehicles
   - Pull-to-refresh works
   - Shows loading spinner during fetch

4. **Add Vehicle**
   - Creates vehicle in MySQL
   - Links to logged-in user
   - Appears immediately in list
   - Shows success message

### ❌ What Should NOT Work (Expected Errors)

1. **Duplicate Email**

   - Try registering same email twice
   - Should show error: "Email déjà utilisé"

2. **Wrong Password**

   - Login with wrong password
   - Should show error message

3. **Backend Offline**
   - Stop Node.js server
   - Should show connection error with retry button

---

## 🚨 Troubleshooting

### Problem: "Connection Refused"

**Solution:**

```powershell
# Make sure backend is running
cd backend
node server.js
```

### Problem: "Can't find database"

**Solution:**

```powershell
# Import schema
mysql -u root < backend/database/schema.sql
```

### Problem: Flutter build errors

**Solution:**

```powershell
flutter clean
flutter pub get
flutter run
```

---

## 📊 Live Database Monitoring

**Watch your database in real-time:**

```powershell
# Terminal 1: Backend logs
cd backend
node server.js

# Terminal 2: MySQL monitor
mysql -u root occazcar_db

# In MySQL:
SELECT * FROM users;
SELECT * FROM vehicles;
```

**Every action in the app should appear in your database!**

---

## ✨ Pro Tips

1. **Test with Multiple Users**

   - Create 2-3 different accounts
   - Each can add their own vehicles
   - All vehicles appear in main list

2. **Test Edge Cases**

   - Very long vehicle names
   - Special characters in description
   - Min/max year values (1900-2026)

3. **Monitor Network**

   - Open Chrome DevTools → Network tab
   - See API calls in real-time
   - Check request/response data

4. **JWT Token**
   - Token lasts 7 days
   - Stored securely in app
   - Auto-loaded on app restart
   - Try closing and reopening app → Still logged in!

---

## 🎉 Success Checklist

After testing, you should have verified:

- ✅ User registration works
- ✅ User appears in MySQL `users` table
- ✅ Password is hashed (not plain text)
- ✅ Login works with correct credentials
- ✅ Login fails with wrong credentials
- ✅ JWT token persists across app restarts
- ✅ Vehicles list loads from database
- ✅ Can create new vehicle
- ✅ Vehicle appears in `vehicles` table
- ✅ Vehicle appears in app immediately
- ✅ Pull-to-refresh works
- ✅ Loading spinners appear during API calls
- ✅ Error messages show when appropriate

---

## 📞 Need Help?

Check these files:

1. `INTEGRATION_COMPLETE.md` - Full documentation
2. `FRONTEND_BACKEND_STATUS.md` - Technical details
3. `backend/README.md` - API documentation

---

**Total Testing Time: ~5 minutes**  
**You're ready to go! 🚀**
