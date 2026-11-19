$url = "http://localhost:8000/api/v1/auth/login"
$body = @{
    email = "admin_demo@example.com"
    password = "change_me"
} | ConvertTo-Json

$response = Invoke-WebRequest -Uri $url -Method Post -Body $body -ContentType "application/json"
$data = $response.Content | ConvertFrom-Json
$token = $data.access_token

if ($token) {
    Write-Host "Token obtained: $token"
    
    # Now test dashboard endpoint
    $dashUrl = "http://localhost:8000/api/v1/dashboard/summary"
    $headers = @{
        "Authorization" = "Bearer $token"
    }
    
    $dashResponse = Invoke-WebRequest -Uri $dashUrl -Headers $headers
    Write-Host "Dashboard Status: $($dashResponse.StatusCode)"
    Write-Host "Dashboard Response: $($dashResponse.Content)"
} else {
    Write-Host "Failed to get token"
    Write-Host "Response: $($response.Content)"
}
