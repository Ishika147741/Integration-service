# Script to Update Telegram Bot Token

param(
    [Parameter(Mandatory=$true)]
    [string]$Token
)

Write-Host "🔧 Updating Telegram Bot Token..." -ForegroundColor Blue

# Read current .env file
$envContent = Get-Content ".env" -Raw

# Replace the token line
$newContent = $envContent -replace "TELEGRAM_BOT_TOKEN=your_bot_token_here", "TELEGRAM_BOT_TOKEN=$Token"

# Write back to .env file
$newContent | Set-Content ".env"

Write-Host "✅ Token updated successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Current .env configuration:" -ForegroundColor Yellow
Get-Content ".env"
Write-Host ""
Write-Host "🚀 Now restart the service with: npm start" -ForegroundColor Cyan
