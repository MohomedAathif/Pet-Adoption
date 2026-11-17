# ⚡ Quick Start - 5 Minute Setup

## Prerequisites

- Node.js 16+ installed
- Python 3.8+ installed
- Backend running on port 8002
- Frontend running on port 5173

## Step 1: Initialize Backend (1 minute)

```bash
cd backend

# Create database and tables
python -m app.init_db

# Create demo users for testing
python -m app.seed_db
```

**Expected Output:**
```
✓ Admin user created successfully
✓ Created ADMIN user
✓ Created ADOPTER user
✓ Created OWNER user

Demo users created successfully!
You can now log in with these credentials:
  • ADMIN: admin@example.com / password123
  • ADOPTER: adopter@example.com / password123
  • OWNER: owner@example.com / password123
```

## Step 2: Start Backend Server (30 seconds)

```bash
python run.py
```

**Expected Output:**
```
INFO:     Uvicorn running on http://0.0.0.0:8002
INFO:     Press CTRL+C to quit
```

Access API docs: http://localhost:8002/docs

## Step 3: Start Frontend Dev Server (1 minute)

```bash
cd frontend

# Install dependencies (if not done)
npm install

# Start dev server
npm run dev
```

**Expected Output:**
```
VITE v4.5.14  ready in XXX ms

➜  Local:   http://localhost:5173/
```

## Step 4: Test Authentication (2 minutes)

1. **Open browser** to http://localhost:5173/
   - Should redirect to `/login` (not authenticated)

2. **Try to login** with Adopter account:
   - Email: `adopter@example.com`
   - Password: `password123`
   - Click "Sign In"

3. **Should see**:
   - Redirected to Dashboard
   - Sidebar shows "Logged in as adopter@example.com" with "ADOPTER" role
   - Navbar shows avatar with initials
   - Menu items specific to Adopter role

4. **Test role-based menu**:
   - As Adopter: See "Browse Pets", "My Favorites", "My Requests"
   - Visit Navbar dropdown → Click "Sign Out"

5. **Try different roles**:
   - Login as `owner@example.com` / `password123`
   - Notice menu items change to: "My Pets", "Adoption Requests"
   - Try Admin account: `admin@example.com` / `password123`
   - See "Admin Panel" option in menu

## Common Issues & Fixes

### ❌ "Cannot GET /login"
**Solution**: Make sure frontend is running on port 5173
```bash
cd frontend && npm run dev
```

### ❌ "Failed to fetch" API error
**Solution**: Backend not running
```bash
cd backend && python run.py
```

### ❌ Database error on login
**Solution**: Database not initialized
```bash
cd backend && python -m app.init_db && python -m app.seed_db
```

### ❌ Login page doesn't redirect
**Solution**: Check browser console for errors
- Open DevTools (F12)
- Check Console tab
- Look for error messages

### ❌ Sidebar menu items don't show
**Solution**: Check user role in localStorage
- Open DevTools → Application → localStorage
- Look for `auth_token` value
- Check if user has correct role

## What to Test Next

✅ **Authentication Flow**
- [ ] Register new account
- [ ] Login with different roles
- [ ] Logout clears token
- [ ] Protected pages redirect to login when logged out

✅ **Role-Based Access**
- [ ] Admin sees all menu items
- [ ] Adopter sees adoption menu items
- [ ] Owner sees owner menu items
- [ ] Pages show role-specific content

✅ **UI/UX**
- [ ] Dark mode toggle works
- [ ] Sidebar responsive on mobile
- [ ] Error messages display
- [ ] Loading states work

## API Testing with cURL

```bash
# Get login token
curl -X POST http://localhost:8002/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "adopter@example.com",
    "password": "password123"
  }'

# Get current user info
export TOKEN="<access_token_from_above>"
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8002/api/v1/auth/me
```

## React DevTools Debugging

If you have React DevTools extension:
1. Open DevTools
2. Go to "Components" tab
3. Find `AuthProvider` component
4. Expand to see current context state
5. Check `user`, `token`, `loading` values

## File Structure Summary

```
Backend Auth Files:
- app/models/user.py          (User model with roles)
- app/schemas/user.py         (User validation schemas)
- app/crud/user.py            (Database operations)
- app/utils/security.py       (Password & JWT handling)
- app/core/dependencies.py    (Role-based protection)
- app/api/v1/endpoints/auth.py (API endpoints)
- app/seed_db.py              (Demo user creation)

Frontend Auth Files:
- src/contexts/AuthContext.jsx       (Auth state management)
- src/components/ProtectedRoute.jsx  (Route protection)
- src/components/pages/Login.jsx     (Login page)
- src/components/pages/Register.jsx  (Registration)
- src/components/layout/Sidebar.jsx  (Role-based menu)
- src/components/layout/Navbar.jsx   (Auth navbar)
- src/services/api.js                (Axios + JWT)
- src/App.jsx                        (Route setup)
```

## Next: Connect API Endpoints

Now that auth is working, connect real endpoints:
- Update pet listing to use `/v1/pets` endpoint
- Create adoption request endpoints
- Implement favorites/saved pets
- Add user profile updates

## Questions?

Check `AUTHENTICATION_GUIDE.md` for detailed documentation.
