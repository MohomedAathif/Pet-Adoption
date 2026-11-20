import requests
import json

BASE_URL = "http://localhost:8000/api"

# First, let's test login with a known user
LOGIN_DATA = {
    "email": "admin@test.com",
    "password": "admin123"
}

print("1. Testing login...")
login_response = requests.post(f"{BASE_URL}/v1/auth/login", json=LOGIN_DATA)
print(f"Status: {login_response.status_code}")
print(f"Response: {login_response.text}")

if login_response.status_code == 200:
    token = login_response.json().get("access_token")
    print(f"\nToken: {token}")
    
    print("\n2. Testing dashboard endpoint...")
    headers = {"Authorization": f"Bearer {token}"}
    dashboard_response = requests.get(f"{BASE_URL}/v1/dashboard/summary", headers=headers)
    print(f"Status: {dashboard_response.status_code}")
    print(f"Response: {dashboard_response.text}")
    
    if dashboard_response.status_code == 200:
        data = dashboard_response.json()
        print(f"\nDashboard data keys: {list(data.keys())}")
    else:
        print(f"\nError detail: {dashboard_response.json().get('detail')}")
