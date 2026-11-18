# Pet Adoption Web System

A full-stack web application for managing pet adoptions, built with modern technologies.

## Tech Stack

### Frontend
- **React 18** with Vite
- **Tailwind CSS** for styling
- **React Router** for navigation
- **Axios** for API communication

### Backend
- **FastAPI** - Modern Python web framework
- **SQLAlchemy** - ORM for database operations
- **PostgreSQL** - Relational database
- **Alembic** - Database migrations
- **Pydantic** - Data validation

## Project Structure

```
Pet-Adoption/
├── frontend/                 # React + Vite + Tailwind frontend
│   ├── src/
│   │   ├── components/       # React components (common, layout, pages, forms)
│   │   ├── pages/           # Page components
│   │   ├── hooks/           # Custom React hooks
│   │   ├── services/        # API client services
│   │   ├── store/           # State management
│   │   ├── styles/          # Global CSS/Tailwind styles
│   │   ├── utils/           # Utility functions
│   │   ├── types/           # TypeScript type definitions
│   │   └── constants/       # App constants
│   ├── public/              # Static assets
│   └── package.json
│
├── backend/                 # FastAPI Python backend
│   ├── app/
│   │   ├── api/v1/          # API endpoints organized by version
│   │   │   ├── endpoints/   # Endpoint handlers (pets, users, adoptions)
│   │   │   └── router.py    # Route aggregation
│   │   ├── models/          # SQLAlchemy ORM models
│   │   ├── schemas/         # Pydantic request/response schemas
│   │   ├── crud/            # Database CRUD operations
│   │   ├── services/        # Business logic layer
│   │   ├── middleware/      # Custom middleware
│   │   ├── utils/           # Utilities (security, validation, etc)
│   │   ├── config/          # Configuration management
│   │   ├── database.py      # Database connection setup
│   │   └── main.py          # FastAPI app initialization
│   ├── migrations/          # Alembic database migrations
│   ├── tests/               # Unit and integration tests
│   ├── requirements.txt     # Python dependencies
│   └── .env.example         # Environment variables template
│
├── .gitignore              # Git ignore configuration
└── README.md               # This file
```

## Quick Start

### Prerequisites
- Python 3.11+ (for local development)
- Node.js 18+ (for local frontend development)

### Local Development

#### Backend Setup
```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env
# Update .env with your configuration
python -m uvicorn app.main:app --reload
```

#### Frontend Setup
```bash
cd frontend
npm install
cp .env.example .env.local
npm run dev
```

## API Endpoints

### Pets
- `GET /api/v1/pets` - List all pets
- `GET /api/v1/pets/{id}` - Get pet details
- `POST /api/v1/pets` - Create new pet
- `PUT /api/v1/pets/{id}` - Update pet
- `DELETE /api/v1/pets/{id}` - Delete pet

### Users
- `POST /api/v1/users` - Register user
- `POST /api/v1/users/login` - Login user
- `GET /api/v1/users/{id}` - Get user profile

### Adoptions
- `POST /api/v1/adoptions` - Create adoption record
- `GET /api/v1/adoptions/{id}` - Get adoption details
- `PUT /api/v1/adoptions/{id}` - Update adoption
- `GET /api/v1/users/{user_id}/adoptions` - Get user's adoptions

## Environment Variables

### Backend (.env)
```
DATABASE_URL=postgresql://user:password@localhost:5432/pet_adoption
SECRET_KEY=your-secret-key-change-in-production
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
ENVIRONMENT=development
DEBUG=True
```

### Frontend (.env.local)
```
VITE_API_URL=http://localhost:8000/api
```

## Database Migrations

Using Alembic for schema management:

```bash
cd backend
# Create migration
alembic revision --autogenerate -m "description"

# Apply migrations
alembic upgrade head

# Rollback
alembic downgrade -1
```

## Testing

### Backend Tests
```bash
cd backend
pytest
pytest --cov=app  # With coverage
```

### Frontend Tests
```bash
cd frontend
npm run test
```

## Best Practices Implemented

✅ **Separation of Concerns** - Models, schemas, CRUD, services isolated
✅ **Scalable Structure** - Easy to add new features
✅ **Authentication Ready** - JWT token infrastructure in place
✅ **API Documentation** - Auto-generated Swagger docs
✅ **Database Migrations** - Version-controlled schema changes
✅ **Error Handling** - Consistent error responses
✅ **CORS Configured** - Frontend-backend integration ready
✅ **Type Safety** - Pydantic schemas and TypeScript support

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - see LICENSE file for details.
