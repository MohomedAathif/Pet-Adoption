# FastAPI Backend Setup Guide

## Overview

This is a production-ready FastAPI backend for the Pet Adoption System with:
- ✅ JWT Authentication with access and refresh tokens
- ✅ Role-Based Access Control (RBAC) with 3 roles: admin, adopter, owner
- ✅ PostgreSQL database with SQLAlchemy ORM
- ✅ Comprehensive user management
- ✅ Admin dashboard and user management endpoints
- ✅ Input validation with Pydantic
- ✅ Error handling and logging
- ✅ CORS support for frontend integration

## Directory Structure

```
backend/
├── app/
│   ├── api/v1/
│   │   ├── endpoints/
│   │   │   ├── auth.py           # Authentication & login
│   │   │   ├── users.py          # User management
│   │   │   ├── pets.py           # Pet management
│   │   │   └── admin.py          # Admin operations
│   │   └── router.py              # Route aggregation
│   ├── core/
│   │   └── dependencies.py        # Auth dependencies & role verification
│   ├── models/
│   │   ├── user.py                # User model with roles
│   │   ├── pet.py                 # Pet model
│   │   └── adoption.py            # Adoption model
│   ├── schemas/
│   │   ├── user.py                # User Pydantic schemas
│   │   ├── token.py               # JWT token schemas
│   │   ├── pet.py                 # Pet schemas
│   │   └── adoption.py            # Adoption schemas
│   ├── crud/
│   │   ├── user.py                # User CRUD operations
│   │   ├── pet.py                 # Pet CRUD operations
│   │   └── adoption.py            # Adoption CRUD operations
│   ├── utils/
│   │   └── security.py            # Password hashing & JWT tokens
│   ├── config/
│   │   └── settings.py            # Environment configuration
│   ├── database.py                # Database connection & init
│   ├── init_db.py                 # Database initialization script
│   └── main.py                    # FastAPI app initialization
├── .env.example                   # Environment variables template
├── requirements.txt               # Python dependencies
```

## Quick Start

### 1. Environment Setup

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Copy environment file
cp .env.example .env
```

### 2. Configure Environment Variables

Edit `.env` file:

```env
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/pet_adoption

# JWT
SECRET_KEY=your-super-secret-key-generate-with-openssl-rand-hex-32
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7

# Application
ENVIRONMENT=development
DEBUG=True
```

### 3. Database Setup

```bash
# Initialize database and create tables
python -m app.init_db

# Or with custom admin credentials:
python -m app.init_db --email admin@example.com --username admin --password YourPassword123
```

### 4. Run Application

```bash
# Development mode
python -m uvicorn app.main:app --reload

# Production mode
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 4
```

Access:
- 🔗 API: http://localhost:8000
- 📚 Docs: http://localhost:8000/docs
- 🔄 ReDoc: http://localhost:8000/redoc
- ❤️ Health: http://localhost:8000/health

## API Endpoints

### Authentication

```
POST   /api/v1/auth/register       - Register new user
POST   /api/v1/auth/login          - Login (returns tokens)
POST   /api/v1/auth/refresh        - Refresh access token
GET    /api/v1/auth/me             - Get current user info
PUT    /api/v1/auth/me             - Update user profile
POST   /api/v1/auth/change-password - Change password
POST   /api/v1/auth/logout         - Logout
```

### User Management (Admin)

```
GET    /api/v1/admin/users         - List all users
GET    /api/v1/admin/users/{id}    - Get user details
GET    /api/v1/admin/users/role/{role} - Filter users by role
PUT    /api/v1/admin/users/{id}/role/{role} - Update user role
PUT    /api/v1/admin/users/{id}/activate   - Activate user
PUT    /api/v1/admin/users/{id}/deactivate - Deactivate user
GET    /api/v1/admin/stats/users   - User statistics
GET    /api/v1/admin/stats/dashboard - Admin dashboard
```

### Pets Management

```
GET    /api/v1/pets                - List all pets
GET    /api/v1/pets/{id}           - Get pet details
POST   /api/v1/pets                - Create pet (authenticated)
PUT    /api/v1/pets/{id}           - Update pet (authenticated)
DELETE /api/v1/pets/{id}           - Delete pet (authenticated)
```

## User Roles

### Admin
- Full system access
- Manage all users and assign roles
- Access admin dashboard
- View system statistics

### Adopter
- Browse available pets
- Create adoption requests
- View own adoption history
- Update profile

### Owner
- List pets for adoption
- Manage own pets
- View adoption requests
- Track adoptions

### Owner
- Manage owned pets
- Process adoptions
- View adoption statistics
- Manage owner profile

## Authentication Flow

### 1. Register
```bash
curl -X POST "http://localhost:8000/api/v1/auth/register" \
  -H "Content-Type: application/json" \
  -d {
    "email": "user@example.com",
    "username": "username",
    "password": "Password123",
    "confirm_password": "Password123",
    "full_name": "John Doe",
    "role": "adopter"
  }
```

### 2. Login
```bash
curl -X POST "http://localhost:8000/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d {
    "email": "user@example.com",
    "password": "Password123"
  }
```

Response:
```json
{
  "access_token": "eyJhbGc...",
  "refresh_token": "eyJhbGc...",
  "token_type": "bearer",
  "expires_in": 1800,
  "user_id": 1,
  "email": "user@example.com",
  "role": "adopter"
}
```

### 3. Use Access Token
```bash
curl -X GET "http://localhost:8000/api/v1/auth/me" \
  -H "Authorization: Bearer {access_token}"
```

### 4. Refresh Token
```bash
curl -X POST "http://localhost:8000/api/v1/auth/refresh" \
  -H "Content-Type: application/json" \
  -d {
    "refresh_token": "{refresh_token}"
  }
```

## Security Features

### Password Security
- ✅ Hashed with bcrypt
- ✅ Minimum 8 characters required
- ✅ Validated on registration and change
- ✅ ORM prevents SQL injection

### JWT Tokens
- ✅ Access tokens expire in 30 minutes
- ✅ Refresh tokens valid for 7 days
- ✅ Tokens include user_id, email, and role
- ✅ Signature verification on every request

### Database
- ✅ Parameterized queries prevent SQL injection
- ✅ Foreign key constraints
- ✅ Password field never returned in responses
- ✅ Email verification ready

### Role-Based Access Control
- ✅ Endpoints restricted by role
- ✅ Admin-only operations protected
- ✅ Users can only modify their own data
- ✅ Role elevation requires admin action

## Development

### Running Tests

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=app

# Run specific test file
pytest tests/unit/crud/test_user.py

# Run with verbose output
pytest -v
```

### Code Style

```bash
# Format code with black
black app/

# Lint with flake8
flake8 app/

# Check imports with isort
isort app/
```

## Production Deployment

### 1. Environment Variables

```env
ENVIRONMENT=production
DEBUG=False
SECRET_KEY=your-production-secret-key-must-be-very-strong
DATABASE_URL=postgresql://prod_user:prod_password@prod_host:5432/prod_db
```

### 2. Database

```bash
# Run migrations
alembic upgrade head

# Initialize production database
python -m app.init_db --email admin@production.com
```

### 3. CORS Configuration

Update `CORS_ORIGINS` in `.env`:
```env
CORS_ORIGINS=["https://yourdomain.com", "https://app.yourdomain.com"]
```

### 4. Run with Gunicorn

```bash
pip install gunicorn

gunicorn -w 4 -b 0.0.0.0:8000 app.main:app
```

## Troubleshooting

### Database Connection Error
```
Error: could not translate host name "localhost" to address
Solution: Ensure PostgreSQL is running and DATABASE_URL is correct
```

### JWT Token Error
```
Error: Invalid or expired token
Solution: Check SECRET_KEY matches between token creation and verification
```

### Migration Conflicts
```
Error: Column already exists
Solution: Check Alembic migration history with: alembic current
```

## API Documentation

### Interactive Documentation
Visit `http://localhost:8000/docs` for Swagger UI

### Schema Documentation
Visit `http://localhost:8000/redoc` for ReDoc

## File Descriptions

### Core Files

**models/user.py**
- User ORM model with roles enum
- Timestamps and verification fields
- Database indices for performance

**schemas/user.py**
- Pydantic validation schemas
- User registration, login, update schemas
- Response models with proper exclusions

**crud/user.py**
- 15+ CRUD operations
- Authentication methods
- Role management
- Password handling

**utils/security.py**
- Password hashing with bcrypt
- JWT token creation (access & refresh)
- Token verification
- Token payload extraction

**core/dependencies.py**
- Dependency injection utilities
- Role-based access control
- Current user extraction
- Role-specific decorators

**api/v1/endpoints/auth.py**
- Authentication endpoints
- Token management
- User registration and login
- Password change

**api/v1/endpoints/admin.py**
- Admin user management
- Role assignment
- User statistics
- Admin dashboard

## PostgreSQL Setup

```bash
# Install PostgreSQL (macOS)
brew install postgresql

# Start PostgreSQL
brew services start postgresql

# Create database
createdb pet

# Connect to database
psql pet

# Create user
CREATE USER user WITH PASSWORD 'password';
GRANT ALL PRIVILEGES ON DATABASE pet TO user;
```

## Next Steps

1. ✅ Backend setup complete
2. 🔄 Configure database connection
3. 📝 Run init_db script to create tables
4. 🚀 Start development server
5. 🧪 Test endpoints with Swagger UI
6. 🔗 Integrate with frontend

## Support & Documentation

- FastAPI Docs: https://fastapi.tiangolo.com/
- SQLAlchemy Docs: https://docs.sqlalchemy.org/
- JWT: https://tools.ietf.org/html/rfc7519
- Pydantic: https://docs.pydantic.dev/

## License

MIT License - See LICENSE file for details
