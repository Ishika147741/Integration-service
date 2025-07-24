# Comprehensive API Testing Script for Telegram Integration Service
# PowerShell Version

Write-Host "🚀 Testing Telegram Integration Service API Endpoints" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$BASE_URL = "http://localhost:3000/api"

function Test-Endpoint {
    param(
        [string]$Title,
        [string]$Method = "GET",
        [string]$Endpoint,
        [string]$Body = $null,
        [string]$Color = "Blue"
    )
    
    Write-Host $Title -ForegroundColor $Color
    Write-Host "$Method $Endpoint" -ForegroundColor Gray
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        $params = @{
            Uri = $Endpoint
            Method = $Method
            ContentType = "application/json"
        }
        
        if ($Body) {
            $params.Body = $Body
        }
        
        $response = Invoke-RestMethod @params
        Write-Host "Status: 200 OK" -ForegroundColor Green
        $response | ConvertTo-Json -Depth 3
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode
        Write-Host "Status: $statusCode" -ForegroundColor Red
        
        if ($_.ErrorDetails.Message) {
            try {
                $errorResponse = $_.ErrorDetails.Message | ConvertFrom-Json
                $errorResponse | ConvertTo-Json -Depth 3
            }
            catch {
                Write-Host $_.ErrorDetails.Message
            }
        }
    }
    Write-Host ""
}

# Test 1: Health Check
Test-Endpoint -Title "📊 1. Testing Health Check Endpoint" -Endpoint "$BASE_URL/health"

# Test 2: Bot Status
Test-Endpoint -Title "🤖 2. Testing Bot Status Endpoint" -Endpoint "$BASE_URL/bot-status"

# Test 3: Valid Send Message
$validMessage = @{
    message = "Hello! This is a test message from PowerShell curl."
    receiver = "123456789"
} | ConvertTo-Json

Test-Endpoint -Title "📨 3. Testing Send Message Endpoint (Valid Request)" -Method "POST" -Endpoint "$BASE_URL/send-message" -Body $validMessage

# Test 4: Send Message with HTML Formatting
$htmlMessage = @{
    message = "<b>🔔 Alert!</b> Your order <code>ORD-12345</code> has been <i>shipped</i>."
    receiver = "987654321"
} | ConvertTo-Json

Test-Endpoint -Title "📨 4. Testing Send Message with HTML Formatting" -Method "POST" -Endpoint "$BASE_URL/send-message" -Body $htmlMessage

# Test 5: Invalid Receiver
$invalidReceiver = @{
    message = "Test message"
    receiver = "invalid_chat_id"
} | ConvertTo-Json

Test-Endpoint -Title "❌ 5. Testing Validation Error - Invalid Receiver" -Method "POST" -Endpoint "$BASE_URL/send-message" -Body $invalidReceiver -Color "Red"

# Test 6: Missing Message
$missingMessage = @{
    receiver = "123456789"
} | ConvertTo-Json

Test-Endpoint -Title "❌ 6. Testing Validation Error - Missing Message" -Method "POST" -Endpoint "$BASE_URL/send-message" -Body $missingMessage -Color "Red"

# Test 7: Empty Message
$emptyMessage = @{
    message = ""
    receiver = "123456789"
} | ConvertTo-Json

Test-Endpoint -Title "❌ 7. Testing Validation Error - Empty Message" -Method "POST" -Endpoint "$BASE_URL/send-message" -Body $emptyMessage -Color "Red"

# Test 8: Message Too Long
$longMessage = @{
    message = "A" * 5000
    receiver = "123456789"
} | ConvertTo-Json

Test-Endpoint -Title "❌ 8. Testing Validation Error - Message Too Long" -Method "POST" -Endpoint "$BASE_URL/send-message" -Body $longMessage -Color "Red"

# Test 9: Message History
Test-Endpoint -Title "📜 9. Testing Message History Endpoint" -Endpoint "$BASE_URL/messages/123456789" -Color "Blue"

# Test 10: Message History with Limit
Test-Endpoint -Title "📜 10. Testing Message History with Limit" -Endpoint "$BASE_URL/messages/123456789?limit=5" -Color "Blue"

# Test 11: Invalid Chat ID in History
Test-Endpoint -Title "❌ 11. Testing Invalid Chat ID in History" -Endpoint "$BASE_URL/messages/invalid_id" -Color "Red"

# Test 12: Non-existent Endpoint
Test-Endpoint -Title "❌ 12. Testing 404 - Non-existent Endpoint" -Endpoint "$BASE_URL/nonexistent" -Color "Red"

# Test 13: Invalid HTTP Method
Test-Endpoint -Title "❌ 13. Testing Invalid HTTP Method" -Method "DELETE" -Endpoint "$BASE_URL/send-message" -Color "Red"

# Test 14: Invalid JSON
Write-Host "❌ 14. Testing Invalid JSON" -ForegroundColor Red
Write-Host "POST $BASE_URL/send-message" -ForegroundColor Gray
Write-Host "----------------------------------------" -ForegroundColor Gray
try {
    Invoke-RestMethod -Uri "$BASE_URL/send-message" -Method POST -ContentType "application/json" -Body "{invalid json}"
}
catch {
    $statusCode = $_.Exception.Response.StatusCode
    Write-Host "Status: $statusCode" -ForegroundColor Red
    Write-Host "Error: Bad Request - Invalid JSON format" -ForegroundColor Red
}
Write-Host ""

# Test 15: Development Test Endpoint
$testMessage = @{
    chatId = "123456789"
} | ConvertTo-Json

Test-Endpoint -Title "🧪 15. Testing Development Test Endpoint" -Method "POST" -Endpoint "$BASE_URL/test-message" -Body $testMessage -Color "Yellow"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "✅ API Testing Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Summary of expected results:" -ForegroundColor White
Write-Host "- Health check: 200 OK" -ForegroundColor Gray
Write-Host "- Bot status: 200 OK (connected: false in demo mode)" -ForegroundColor Gray
Write-Host "- Valid send message: 200 OK (demo mode simulation)" -ForegroundColor Gray
Write-Host "- Invalid requests: 400 Bad Request with validation errors" -ForegroundColor Gray
Write-Host "- Non-existent endpoints: 404 Not Found" -ForegroundColor Gray
Write-Host "- Message history: 500 Internal Server Error (no database in demo mode)" -ForegroundColor Gray
Write-Host ""
