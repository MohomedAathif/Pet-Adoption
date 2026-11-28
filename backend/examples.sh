#!/bin/bash

# Pet Adoption API - cURL Examples
# These examples show how to test the API endpoints using cURL

API_URL="http://localhost:8000/api/v1"

echo "🐾 Pet Adoption API - cURL Examples"
echo "===================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper function to print colored output
print_section() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_command() {
    echo -e "${YELLOW}$ $1${NC}"
}

# ============================================================================
# 1. HEALTH CHECK
# ============================================================================

print_section "1. Health Check"
print_command "curl $API_URL/../health"
curl -s "$API_URL/../health" | jq '.'
echo ""

# ============================================================================
# 2. USER REGISTRATION
# ============================================================================

print_section "2. User Registration"

# Register as Adopter
print_command "Register Adopter"
curl -s -X POST "$API_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "adopter@example.com",
    "username": "adopter_user",
    "password": "AdopterPass123",
    "confirm_password": "AdopterPass123",
    "full_name": "John Adopter",
    "role": "adopter"
  }' | jq '.'
echo ""

# Register as Owner
print_command "Register Owner"
curl -s -X POST "$API_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "owner@example.com",
    "username": "pet_owner",
    "password": "OwnerPass123",
    "confirm_password": "OwnerPass123",
    "full_name": "Jane Owner",
    "role": "owner"
  }' | jq '.'
echo ""

# ============================================================================
# 3. LOGIN
# ============================================================================

print_section "3. User Login"
print_command "Login User"

# Login and save response
login_response=$(curl -s -X POST "$API_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "adopter@example.com",
    "password": "AdopterPass123"
  }')

echo "$login_response" | jq '.'

# Extract tokens (for use in subsequent requests)
ACCESS_TOKEN=$(echo "$login_response" | jq -r '.access_token')
REFRESH_TOKEN=$(echo "$login_response" | jq -r '.refresh_token')

echo -e "${GREEN}✓ Save these tokens for authenticated requests:${NC}"
echo "ACCESS_TOKEN=$ACCESS_TOKEN"
echo "REFRESH_TOKEN=$REFRESH_TOKEN"
echo ""

# ============================================================================
# 4. GET CURRENT USER
# ============================================================================

print_section "4. Get Current User Info"
print_command "curl -H 'Authorization: Bearer \$ACCESS_TOKEN' $API_URL/auth/me"

curl -s -X GET "$API_URL/auth/me" \
  -H "Authorization: Bearer $ACCESS_TOKEN" | jq '.'
echo ""

# ============================================================================
# 5. UPDATE USER PROFILE
# ============================================================================

print_section "5. Update User Profile"
print_command "curl -X PUT ... $API_URL/auth/me"

curl -s -X PUT "$API_URL/auth/me" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "full_name": "John Doe Updated",
    "phone": "+1-555-0123",
    "address": "456 Oak Avenue, Springfield, IL 62701"
  }' | jq '.'
echo ""

# ============================================================================
# 6. CHANGE PASSWORD
# ============================================================================

print_section "6. Change Password"
print_command "curl -X POST ... $API_URL/auth/change-password"

curl -s -X POST "$API_URL/auth/change-password" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "current_password": "AdopterPass123",
    "new_password": "NewAdopterPass123",
    "confirm_password": "NewAdopterPass123"
  }' | jq '.'
echo ""

# ============================================================================
# 7. REFRESH TOKEN
# ============================================================================

print_section "7. Refresh Access Token"
print_command "curl -X POST ... $API_URL/auth/refresh"

refresh_response=$(curl -s -X POST "$API_URL/auth/refresh" \
  -H "Content-Type: application/json" \
  -d "{
    \"refresh_token\": \"$REFRESH_TOKEN\"
  }")

echo "$refresh_response" | jq '.'

# Update ACCESS_TOKEN for subsequent requests
NEW_ACCESS_TOKEN=$(echo "$refresh_response" | jq -r '.access_token // empty' 2>/dev/null)
if [ -n "$NEW_ACCESS_TOKEN" ]; then
    ACCESS_TOKEN="$NEW_ACCESS_TOKEN"
    echo -e "${GREEN}✓ Access token refreshed${NC}"
fi
echo ""

# ============================================================================
# 8. CREATE PET
# ============================================================================

print_section "8. Create Pet (Owner User)"
print_command "curl -X POST ... $API_URL/pets"

curl -s -X POST "$API_URL/pets" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Max",
    "species": "dog",
    "breed": "Golden Retriever",
    "age": 3,
    "description": "Friendly and energetic golden retriever looking for a loving home",
    "status": "available",
    "image_url": "https://example.com/max.jpg"
  }' | jq '.'
echo ""

# ============================================================================
# 9. LIST PETS
# ============================================================================

print_section "9. List Pets"
print_command "curl $API_URL/pets"

curl -s -X GET "$API_URL/pets" | jq '.'
echo ""

# ============================================================================
# 10. ADMIN OPERATIONS (requires admin token)
# ============================================================================

print_section "10. Admin Operations"

# Login as Admin (assumes admin exists from init_db)
print_command "Login as Admin"
admin_login=$(curl -s -X POST "$API_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@petadoption.com",
    "password": "AdminPassword123"
  }')

ADMIN_TOKEN=$(echo "$admin_login" | jq -r '.access_token // empty' 2>/dev/null)

if [ -n "$ADMIN_TOKEN" ]; then
    echo -e "${GREEN}✓ Admin Login Successful${NC}"
    
    # List all users
    print_command "List All Users"
    curl -s -X GET "$API_URL/admin/users?skip=0&limit=10" \
      -H "Authorization: Bearer $ADMIN_TOKEN" | jq '.'
    echo ""
    
    # Get user by role
    print_command "List Adopter Users"
    curl -s -X GET "$API_URL/admin/users/role/adopter" \
      -H "Authorization: Bearer $ADMIN_TOKEN" | jq '.'
    echo ""
    
    # Get admin dashboard
    print_command "Get Admin Dashboard Stats"
    curl -s -X GET "$API_URL/admin/stats/dashboard" \
      -H "Authorization: Bearer $ADMIN_TOKEN" | jq '.'
    echo ""
    
    # Update user role
    print_command "Update User Role (ID=1)"
    curl -s -X PUT "$API_URL/admin/users/1/role/owner" \
      -H "Authorization: Bearer $ADMIN_TOKEN" | jq '.'
    echo ""
else
    echo -e "${YELLOW}⚠ Admin login failed - admin user may not exist${NC}"
    echo "Run: python -m app.init_db"
    echo ""
fi

# ============================================================================
# 11. ERROR HANDLING EXAMPLES
# ============================================================================

print_section "11. Error Handling Examples"

# Missing required field
print_command "Missing Required Field (Email)"
curl -s -X POST "$API_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "TestPass123"
  }' | jq '.'
echo ""

# Invalid email format
print_command "Invalid Email Format"
curl -s -X POST "$API_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "invalid-email",
    "username": "testuser",
    "password": "TestPass123",
    "confirm_password": "TestPass123"
  }' | jq '.'
echo ""

# Duplicate email
print_command "Duplicate Email"
curl -s -X POST "$API_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "adopter@example.com",
    "username": "different_username",
    "password": "TestPass123",
    "confirm_password": "TestPass123"
  }' | jq '.'
echo ""

# Invalid credentials
print_command "Invalid Login Credentials"
curl -s -X POST "$API_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "adopter@example.com",
    "password": "WrongPassword"
  }' | jq '.'
echo ""

# Unauthorized access
print_command "Unauthorized Access (No Token)"
curl -s -X GET "$API_URL/auth/me" | jq '.'
echo ""

# Invalid token
print_command "Invalid Token"
curl -s -X GET "$API_URL/auth/me" \
  -H "Authorization: Bearer invalid.token.here" | jq '.'
echo ""

# ============================================================================
# SUMMARY
# ============================================================================

echo ""
echo "===================================="
echo "📝 Summary of cURL Examples"
echo "===================================="
echo ""
echo "✓ Health Check"
echo "✓ User Registration (multiple roles)"
echo "✓ User Login"
echo "✓ Get Current User"
echo "✓ Update Profile"
echo "✓ Change Password"
echo "✓ Refresh Token"
echo "✓ Pet Management"
echo "✓ Admin Operations"
echo "✓ Error Handling"
echo ""
echo "🚀 API is running at: $API_URL"
echo "📚 Swagger Docs at: http://localhost:8000/docs"
echo "🔄 ReDoc at: http://localhost:8000/redoc"
echo ""
