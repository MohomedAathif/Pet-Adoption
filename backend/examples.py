"""
Example API Usage and Testing

This file demonstrates how to use the Pet Adoption API with examples
for registration, login, and managing users.
"""

import requests
import json
from typing import Dict, Any

# API Base URL
BASE_URL = "http://localhost:8000/api/v1"

class PetAdoptionAPI:
    """Simple API client for testing"""
    
    def __init__(self, base_url: str = BASE_URL):
        self.base_url = base_url
        self.access_token = None
        self.refresh_token = None
        self.current_user = None
    
    def _headers(self, include_auth: bool = True) -> Dict[str, str]:
        """Get request headers"""
        headers = {"Content-Type": "application/json"}
        if include_auth and self.access_token:
            headers["Authorization"] = f"Bearer {self.access_token}"
        return headers
    
    def register(self, email: str, username: str, password: str, full_name: str = "", role: str = "adopter") -> Dict[str, Any]:
        """Register a new user"""
        url = f"{self.base_url}/auth/register"
        data = {
            "email": email,
            "username": username,
            "password": password,
            "confirm_password": password,
            "full_name": full_name,
            "role": role
        }
        response = requests.post(url, json=data, headers=self._headers(include_auth=False))
        return response.json()
    
    def login(self, email: str, password: str) -> Dict[str, Any]:
        """Login user and get tokens"""
        url = f"{self.base_url}/auth/login"
        data = {
            "email": email,
            "password": password
        }
        response = requests.post(url, json=data, headers=self._headers(include_auth=False))
        result = response.json()
        
        if response.status_code == 200:
            self.access_token = result.get("access_token")
            self.refresh_token = result.get("refresh_token")
            self.current_user = result
            print(f"✓ Logged in as {result.get('email')} (Role: {result.get('role')})")
        
        return result
    
    def refresh_tokens(self) -> Dict[str, Any]:
        """Refresh access token"""
        url = f"{self.base_url}/auth/refresh"
        data = {"refresh_token": self.refresh_token}
        response = requests.post(url, json=data, headers=self._headers(include_auth=False))
        result = response.json()
        
        if response.status_code == 200:
            self.access_token = result.get("access_token")
            self.refresh_token = result.get("refresh_token")
        
        return result
    
    def get_current_user(self) -> Dict[str, Any]:
        """Get current user information"""
        url = f"{self.base_url}/auth/me"
        response = requests.get(url, headers=self._headers())
        return response.json()
    
    def update_profile(self, full_name: str = None, phone: str = None, address: str = None) -> Dict[str, Any]:
        """Update user profile"""
        url = f"{self.base_url}/auth/me"
        data = {}
        if full_name:
            data["full_name"] = full_name
        if phone:
            data["phone"] = phone
        if address:
            data["address"] = address
        
        response = requests.put(url, json=data, headers=self._headers())
        return response.json()
    
    def change_password(self, current_password: str, new_password: str) -> Dict[str, Any]:
        """Change user password"""
        url = f"{self.base_url}/auth/change-password"
        data = {
            "current_password": current_password,
            "new_password": new_password,
            "confirm_password": new_password
        }
        response = requests.post(url, json=data, headers=self._headers())
        return response.json()
    
    # Admin operations
    def list_users(self, skip: int = 0, limit: int = 10, role: str = None) -> Dict[str, Any]:
        """List all users (Admin only)"""
        url = f"{self.base_url}/admin/users"
        params = {"skip": skip, "limit": limit}
        if role:
            params["role"] = role
        
        response = requests.get(url, params=params, headers=self._headers())
        return response.json()
    
    def get_user(self, user_id: int) -> Dict[str, Any]:
        """Get user details (Admin only)"""
        url = f"{self.base_url}/admin/users/{user_id}"
        response = requests.get(url, headers=self._headers())
        return response.json()
    
    def update_user_role(self, user_id: int, new_role: str) -> Dict[str, Any]:
        """Update user role (Admin only)"""
        url = f"{self.base_url}/admin/users/{user_id}/role/{new_role}"
        response = requests.put(url, headers=self._headers())
        return response.json()
    
    def get_admin_dashboard(self) -> Dict[str, Any]:
        """Get admin dashboard stats (Admin only)"""
        url = f"{self.base_url}/admin/stats/dashboard"
        response = requests.get(url, headers=self._headers())
        return response.json()


def example_user_registration():
    """Example: User registration"""
    print("\n" + "="*50)
    print("Example: User Registration")
    print("="*50)
    
    api = PetAdoptionAPI()
    
    # Register new adopter
    print("\n1️⃣ Registering new adopter...")
    result = api.register(
        email="john.doe@example.com",
        username="johndoe",
        password="SecurePassword123",
        full_name="John Doe",
        role="adopter"
    )
    print(json.dumps(result, indent=2))


def example_authentication():
    """Example: User authentication"""
    print("\n" + "="*50)
    print("Example: User Authentication")
    print("="*50)
    
    api = PetAdoptionAPI()
    
    # Register user
    print("\n1️⃣ Registering user...")
    api.register(
        email="user@example.com",
        username="testuser",
        password="TestPassword123",
        full_name="Test User",
        role="adopter"
    )
    
    # Login
    print("\n2️⃣ Logging in...")
    result = api.login("user@example.com", "TestPassword123")
    print(f"Access Token: {result['access_token'][:20]}...")
    print(f"Refresh Token: {result['refresh_token'][:20]}...")
    
    # Get current user
    print("\n3️⃣ Getting current user info...")
    user = api.get_current_user()
    print(json.dumps(user, indent=2, default=str))
    
    # Refresh token
    print("\n4️⃣ Refreshing tokens...")
    result = api.refresh_tokens()
    print(f"New Access Token: {result['access_token'][:20]}...")


def example_profile_management():
    """Example: Profile management"""
    print("\n" + "="*50)
    print("Example: Profile Management")
    print("="*50)
    
    api = PetAdoptionAPI()
    
    # Register and login
    print("\n1️⃣ Setting up user...")
    api.register(
        email="profile@example.com",
        username="profileuser",
        password="TestPassword123",
        full_name="Profile User"
    )
    api.login("profile@example.com", "TestPassword123")
    
    # Update profile
    print("\n2️⃣ Updating profile...")
    result = api.update_profile(
        full_name="Updated Name",
        phone="+1234567890",
        address="123 Main St, City, State"
    )
    print(json.dumps(result, indent=2, default=str))
    
    # Change password
    print("\n3️⃣ Changing password...")
    result = api.change_password(
        current_password="TestPassword123",
        new_password="NewPassword123"
    )
    print(json.dumps(result, indent=2))


def example_admin_operations():
    """Example: Admin operations"""
    print("\n" + "="*50)
    print("Example: Admin Operations")
    print("="*50)
    
    api = PetAdoptionAPI()
    
    # Login as admin (assuming admin already exists)
    print("\n1️⃣ Logging in as admin...")
    api.login("admin@petadoption.com", "AdminPassword123")
    
    # List users
    print("\n2️⃣ Listing all users...")
    result = api.list_users(limit=5)
    print(json.dumps(result, indent=2, default=str))
    
    # List users by role
    print("\n3️⃣ Listing users by role (adopter)...")
    result = api.list_users(role="adopter", limit=5)
    print(json.dumps(result, indent=2, default=str))
    
    # Get dashboard stats
    print("\n4️⃣ Getting admin dashboard stats...")
    result = api.get_admin_dashboard()
    print(json.dumps(result, indent=2, default=str))


def example_error_handling():
    """Example: Error handling"""
    print("\n" + "="*50)
    print("Example: Error Handling")
    print("="*50)
    
    api = PetAdoptionAPI()
    sample_email = "sample.user@example.com"
    sample_secret = "SampleValue123"
    
    # Attempt invalid login
    print("\n1️⃣ Attempting invalid login...")
    result = api.login("nonexistent@example.com", "wrongpassword")
    print(json.dumps(result, indent=2))
    
    # Attempt to access protected endpoint without token
    print("\n2️⃣ Accessing protected endpoint without token...")
    api.access_token = None  # Clear token
    result = api.get_current_user()
    print(json.dumps(result, indent=2))
    
    # Register with duplicate email
    print("\n3️⃣ Registering with duplicate email...")
    api.register(
        email=sample_email,
        username="sampleuser",
        password=sample_secret
    )
    result = api.register(
        email=sample_email,
        username="different_username",
        password=sample_secret
    )
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    print("\n" + "🐾 "*20)
    print("Pet Adoption API - Usage Examples")
    print("🐾 "*20)
    
    try:
        # Run examples
        example_user_registration()
        example_authentication()
        example_profile_management()
        # Uncomment to test admin operations
        # example_admin_operations()
        example_error_handling()
        
        print("\n" + "="*50)
        print("✅ All examples completed!")
        print("="*50)
        print("\nNote: Ensure the FastAPI server is running on http://localhost:8000")
        
    except requests.exceptions.ConnectionError:
        print("\n❌ Error: Could not connect to API server")
        print("Make sure FastAPI is running: python -m uvicorn app.main:app --reload")
    except Exception as e:
        print(f"\n❌ Error: {str(e)}")
