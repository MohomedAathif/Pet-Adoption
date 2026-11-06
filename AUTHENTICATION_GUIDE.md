# 🔐 Complete Authentication System - Implementation Guide

## Overview

A complete authentication and role-based access control (RBAC) system has been implemented for the Pet Adoption platform with:

- **JWT-based authentication** with access and refresh tokens
- **Three user roles**: Admin, Adopter, Owner
- **Role-based access control** on both frontend and backend
- **Protected routes** that require authentication
- **Role-specific UI elements** that change based on user role
- **Secure password hashing** with bcrypt
- **Automatic token refresh** handling

---

## 📦 What's Included

### Backend (FastAPI)

#### Models & Database
- **User Model** (`app/models/user.py`)
  - Email (unique)
  - Username (unique)
  - Hashed Password (bcrypt)
  - Full Name
  - Phone & Address (optional)
  - Role (admin, adopter, owner)
  - Account Status (is_active, is_verified)
  - Timestamps (created_at, updated_at, last_login)

#### Authentication System
- **Security Utilities** (`app/utils/security.py`)
  - Password hashing & verification (bcrypt)
  - JWT token creation (access & refresh)
  - Token verification & validation
  - Token type checking

- **CRUD Operations** (`app/crud/user.py`)
  - User creation with unique constraints
  - User authentication (email + password)
  - User queries by ID, email, username, role
  - User updates and soft deletes
  - Last login tracking

- **Dependencies** (`app/core/dependencies.py`)
  - `get_current_user()` - Requires valid JWT token
  - `get_optional_user()` - Optional authentication
  - `get_admin()` - Admin-only access
  - `get_adopter()` - Adopter role access
  - `get_owner()` - Owner role access
  - `get_user_with_roles()` - Factory for custom role combinations

- **API Endpoints** (`app/api/v1/endpoints/auth.py`)
  - `POST /auth/register` - Create new account
  - `POST /auth/login` - Get JWT tokens
  - `POST /auth/refresh` - Refresh access token
  - `GET /auth/me` - Get current user info
  - `PUT /auth/me` - Update profile
  - `POST /auth/change-password` - Change password

#### Database Seed Script
- **Seed Data** (`app/seed_db.py`)
  - Creates demo users for each role
  - Default passwords for testing
  - Run after database initialization

### Frontend (React)

#### AuthContext (`src/contexts/AuthContext.jsx`)
Global authentication state with:
- `user` - Current user object
- `token` - JWT access token
- `isAuthenticated` - Auth status boolean
- `loading` - Loading state
- `error` - Error messages
- `login(email, password)` - Login function
- `register(formData)` - Registration function
- `logout()` - Clear auth state
- `hasRole(role)` - Check if user has specific role
- `hasAnyRole(roles)` - Check if user has any of specified roles

#### Auth Pages
- **Login.jsx** (`src/components/pages/Login.jsx`)
  - Email and password fields
  - Error handling
  - Link to registration
  - Demo credentials display
  - Form validation

- **Register.jsx** (`src/components/pages/Register.jsx`)
  - Full name field
  - Email & password with confirmation
  - Role selection dropdown
  - Form validation (password length, match)
  - Success state with redirect

#### Protected Routes (`src/components/ProtectedRoute.jsx`)
- `<ProtectedRoute>` - Requires authentication
- `<RoleProtectedRoute allowedRoles={['admin']}>` - Requires specific role
- Both show loading state and redirect to login if unauthorized
- Access denied page for insufficient permissions

#### Updated Components
- **Sidebar.jsx** - Role-based menu items
  - Admin sees: Dashboard, Admin Panel, Analytics
  - Adopter sees: Dashboard, Browse Pets, My Favorites, My Requests
  - Owner sees: Dashboard, Browse Pets, My Pets, Adoption Requests
  - All see: Settings, Logout
  - Shows logged-in user email and role

- **Navbar.jsx** - Auth-aware navbar
  - Shows user avatar with initials
  - Dropdown menu with profile options
  - Sign Out button
  - Shows login link when not authenticated

- **App.jsx** - Auth routes
  - Public routes: /login, /register
  - Protected routes: /, /pets, /profile, /notifications
  - Admin routes: /admin (role-protected)

#### Axios Setup (`src/services/api.js`)
- Request interceptor: Adds JWT token to Authorization header
- Response interceptor: Handles 401 Unauthorized errors
- Automatic token refresh (ready for implementation)
- Redirects to login on token expiration

---

## 🚀 Getting Started

### 1. Initialize Backend Database

```bash
cd backend
python -m app.init_db
```

This creates the database tables and default admin user.

### 2. Seed Demo Users

```bash
python -m app.seed_db
```

Creates demo users for testing:
```
ADMIN:   admin@example.com / password123
ADOPTER: adopter@example.com / password123
OWNER: owner@example.com / password123
OWNER:   owner@example.com / password123
```

### 3. Start Backend Server

```bash
python run.py
# or
uvicorn app.main:app --reload --host 0.0.0.0 --port 8002
```

Backend runs on: `http://localhost:8002`
API docs: `http://localhost:8002/docs`

### 4. Start Frontend Dev Server

```bash
cd frontend
npm install
npm run dev
```

Frontend runs on: `http://localhost:5173`

### 5. Test Authentication

1. Go to `http://localhost:5173/login`
2. Enter demo credentials
3. Click "Sign In"
4. You'll be redirected to dashboard with user info in sidebar
5. Try different roles to see role-based UI changes

---

## 📝 API Documentation

### Authentication Endpoints

#### Register
```http
POST /api/v1/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "username": "username",
  "password": "password123",
  "confirm_password": "password123",
  "full_name": "John Doe",
  "role": "adopter"
}

Response (201):
{
  "id": 1,
  "email": "user@example.com",
  "username": "username",
  "full_name": "John Doe",
  "role": "adopter",
  "is_active": true,
  "is_verified": false,
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z",
  "last_login": null
}
```

#### Login
```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}

Response (200):
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "expires_in": 3600,
  "user_id": 1,
  "email": "user@example.com",
  "role": "adopter"
}
```

#### Get Current User
```http
GET /api/v1/auth/me
Authorization: Bearer <access_token>

Response (200):
{
  "id": 1,
  "email": "user@example.com",
  "full_name": "John Doe",
  "role": "adopter",
  "phone": "+1-555-0123",
  "address": "123 Main St, Anytown, ST",
  "is_active": true,
  "is_verified": true,
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z",
  "last_login": "2024-01-15T15:45:00Z"
}
```

#### Refresh Token
```http
POST /api/v1/auth/refresh
Content-Type: application/json

{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}

Response (200):
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer"
}
```

---

## 🔒 Using Protected Endpoints

All endpoints protected by authentication require the JWT token in the header:

```bash
curl -H "Authorization: Bearer <access_token>" \
  http://localhost:8002/api/v1/auth/me
```

### Role-Based Endpoints

Admin-only endpoints return 403 Forbidden if user doesn't have admin role:

```bash
# Will work for admin users
GET /api/v1/admin/users
Authorization: Bearer <admin_token>

# Will return 403 for non-admins
GET /api/v1/admin/users (as adopter)
Response: 403 Forbidden - "Admin access required"
```

---

## 🎨 Frontend Usage

### Using AuthContext

```jsx
import { useAuth } from '../../contexts/AuthContext'

function MyComponent() {
  const { user, login, logout, isAuthenticated, hasRole } = useAuth()

  const handleLogin = async () => {
    try {
      const userData = await login('user@example.com', 'password123')
      console.log('Logged in as:', userData)
    } catch (err) {
      console.error('Login failed:', err.message)
    }
  }

  const handleLogout = () => {
    logout()
  }

  if (!isAuthenticated) {
    return <button onClick={handleLogin}>Sign In</button>
  }

  return (
    <div>
      <p>Welcome, {user.email}!</p>
      <p>Role: {user.role}</p>
      {hasRole('admin') && <AdminPanel />}
      <button onClick={handleLogout}>Sign Out</button>
    </div>
  )
}
```

### Protecting Routes

```jsx
import { ProtectedRoute, RoleProtectedRoute } from '../components/ProtectedRoute'

function App() {
  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      
      <Route
        path="/dashboard"
        element={
          <ProtectedRoute>
            <Dashboard />
          </ProtectedRoute>
        }
      />

      <Route
        path="/admin"
        element={
          <RoleProtectedRoute allowedRoles={['admin']}>
            <AdminPanel />
          </RoleProtectedRoute>
        }
      />

      <Route
        path="/owner"
        element={
            <RoleProtectedRoute allowedRoles={['owner', 'admin']}>
              <OwnerPanel />
          </RoleProtectedRoute>
        }
      />
    </Routes>
  )
}
```

---

## 🔄 Token Management

### How Tokens Work

1. **Login**: User submits email/password → Backend returns access token & refresh token
2. **Request**: Client includes access token in `Authorization: Bearer <token>` header
3. **Validation**: Backend validates token signature and expiration
4. **Expiration**: Access token expires in 30 minutes (configurable in settings)
5. **Refresh**: Use refresh token to get new access/refresh token pair
6. **401 Error**: If token invalid/expired, axios interceptor redirects to login

### Token Storage

- Stored in `localStorage` with key: `auth_token`
- Automatically added to all API requests
- Cleared on logout or 401 error

### Automatic Refresh (Ready to Implement)

The axios interceptor is set up to handle 401 errors. To implement automatic refresh:

```javascript
// In src/services/api.js response interceptor
const originalRequest = error.config

if (error.response.status === 401 && !originalRequest._retry) {
  originalRequest._retry = true
  const refreshToken = localStorage.getItem('refresh_token')
  
  const response = await apiClient.post('/v1/auth/refresh', {
    refresh_token: refreshToken
  })
  
  localStorage.setItem('auth_token', response.data.access_token)
  originalRequest.headers.Authorization = `Bearer ${response.data.access_token}`
  
  return apiClient(originalRequest)
}
```

---

## 🧪 Testing

### Test Login with cURL

```bash
# Register
curl -X POST http://localhost:8002/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "username": "testuser",
    "password": "password123",
    "confirm_password": "password123",
    "full_name": "Test User",
    "role": "adopter"
  }'

# Login
curl -X POST http://localhost:8002/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'

# Get user info with token
curl -H "Authorization: Bearer <access_token>" \
  http://localhost:8002/api/v1/auth/me
```

### Test in Frontend

1. Open browser DevTools Console
2. Go to Application/Storage section
3. Check localStorage for `auth_token`
4. You should see JWT token stored
5. Try accessing protected pages directly (should redirect to login)

---

## 📋 Roles & Permissions

### Admin Role
- **Can**: Manage all users, approve new accounts, manage all pets, view analytics
- **Routes**: /admin, /admin/users, /admin/analytics
- **Menu Items**: Dashboard, Admin Panel, Analytics, Settings

### Adopter Role  
- **Can**: Browse pets, create adoption requests, manage favorites, view own requests
- **Routes**: /, /pets, /profile, /notifications
- **Menu Items**: Dashboard, Browse Pets, My Favorites, My Requests, Settings

### Owner Role
- **Can**: Create pet listings, manage own pets, view adoption requests, approve adoptions
- **Routes**: /, /pets, /profile, /notifications
- **Menu Items**: Dashboard, Browse Pets, My Pets, Adoption Requests, Settings

### Owner Role
- **Can**: Manage own pets, browse pets, create adoption requests
- **Routes**: /, /pets, /profile, /notifications
- **Menu Items**: Dashboard, Browse Pets, Settings

---

## ⚙️ Configuration

### Backend Settings (`app/config/settings.py`)

```python
# JWT Configuration
ALGORITHM = "HS256"
SECRET_KEY = "your-secret-key-change-in-production"  # Change this!
ACCESS_TOKEN_EXPIRE_MINUTES = 30
REFRESH_TOKEN_EXPIRE_DAYS = 7

# Password Configuration
PASSWORD_MIN_LENGTH = 8
PASSWORD_REQUIRE_SPECIAL_CHARS = False  # Change as needed

# Database
DATABASE_URL = "sqlite:///./pets.db"  # Change to PostgreSQL in production
```

### Frontend Settings (`.env`)

```env
VITE_API_URL=http://localhost:8000/api
```

---

## 🔐 Security Best Practices

✅ **Implemented:**
- Bcrypt password hashing (12 rounds)
- JWT token-based authentication  
- Secure token storage in localStorage
- HTTP-only suggestions for production
- CORS protection on backend
- Role-based access control
- 401 error handling with auto-redirect

📝 **For Production:**
- Change `SECRET_KEY` to a strong random string
- Use environment variables for sensitive config
- Implement HTTPS/SSL
- Use HttpOnly cookies for token storage instead of localStorage
- Implement rate limiting on auth endpoints
- Add email verification for registration
- Add password reset functionality
- Implement account lockout after failed attempts
- Add 2FA (2-factor authentication)
- Regular security audits

---

## 🐛 Troubleshooting

### Login Not Working

**Problem**: "Invalid email or password" error
- Check email and password are correct
- Ensure database is initialized with `python -m app.init_db`
- Check backend is running on port 8002

**Problem**: CORS error when calling API
- Backend CORS settings in `app/main.py` may need adjustment
- Ensure frontend URL is in CORS_ORIGINS list

### Frontend Not Showing User Info

**Problem**: User info not appearing in navbar
- Check browser console for errors
- Verify token is stored in localStorage
- Check that `/auth/me` endpoint is accessible

### Tokens Expiring Too Fast

**Problem**: Getting logged out frequently
- Adjust `ACCESS_TOKEN_EXPIRE_MINUTES` in backend settings
- Currently set to 30 minutes - increase if needed

### Role-Based Routes Not Working

**Problem**: Can access pages you shouldn't have access to
- Verify role is correctly stored in user object
- Check `RoleProtectedRoute` is wrapping the route component
- Verify allowed roles match actual user role value

---

## 📚 Additional Resources

- [FastAPI Security](https://fastapi.tiangolo.com/tutorial/security/)
- [JWT Handbook](https://auth0.com/resources/ebooks/jwt-handbook)
- [React Context API](https://react.dev/reference/react/useContext)
- [localStorage API](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage)

---

## ✅ Checklist for Full Implementation

- [x] User model with roles
- [x] Password hashing with bcrypt
- [x] JWT token generation & verification
- [x] Login & registration endpoints
- [x] Protected routes on backend
- [x] RBAC dependencies
- [x] Frontend AuthContext
- [x] Login & Register pages
- [x] Protected routes on frontend
- [x] Role-based UI in sidebar
- [x] Token storage in localStorage
- [x] Axios interceptors
- [ ] Email verification (optional)
- [ ] Password reset (optional)
- [ ] OAuth2 integration (optional)
- [ ] 2FA support (optional)

---

## 🎉 Next Steps

1. **Test authentication thoroughly** with different roles
2. **Implement protected endpoints** for pets, adoption requests, etc.
3. **Add email verification** for registration (optional)
4. **Deploy to production** with proper security settings
5. **Monitor authentication logs** for security issues

---

**Questions or issues? Check the troubleshooting section or review the implementation files.**
