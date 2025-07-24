Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Telegram Integration Service Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Node.js is installed
try {
    $nodeVersion = node --version 2>$null
    Write-Host "✅ Node.js found: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Node.js from https://nodejs.org/" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if npm is available
try {
    $npmVersion = npm --version 2>$null
    Write-Host "✅ npm found: $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ npm is not available" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Install dependencies
Write-Host ""
Write-Host "📦 Installing dependencies..." -ForegroundColor Blue
try {
    npm install
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Dependencies installed successfully" -ForegroundColor Green
    } else {
        throw "npm install failed"
    }
} catch {
    Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if .env file exists
Write-Host ""
if (-not (Test-Path ".env")) {
    Write-Host "📝 Creating .env file from template..." -ForegroundColor Blue
    Copy-Item ".env.example" ".env"
    Write-Host "⚠️  Please edit the .env file with your configuration:" -ForegroundColor Yellow
    Write-Host "   - Add your Telegram bot token" -ForegroundColor Yellow
    Write-Host "   - Configure database connection" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host "✅ .env file already exists" -ForegroundColor Green
}

# Check if PostgreSQL is available
Write-Host ""
Write-Host "🔍 Checking PostgreSQL connection..." -ForegroundColor Blue
try {
    $psqlVersion = psql --version 2>$null
    Write-Host "✅ PostgreSQL client found" -ForegroundColor Green
} catch {
    Write-Host "⚠️  PostgreSQL client not found in PATH" -ForegroundColor Yellow
    Write-Host "Please ensure PostgreSQL is installed and running" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📋 Setup completed! Next steps:" -ForegroundColor Green
Write-Host ""
Write-Host "1. Edit the .env file with your configuration:" -ForegroundColor White
Write-Host "   - TELEGRAM_BOT_TOKEN: Get from @BotFather on Telegram" -ForegroundColor Gray
Write-Host "   - Database credentials: Configure for your PostgreSQL instance" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Initialize the database:" -ForegroundColor White
Write-Host "   npm run init-db" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Start the service:" -ForegroundColor White
Write-Host "   npm start" -ForegroundColor Gray
Write-Host ""
Write-Host "4. For development with auto-reload:" -ForegroundColor White
Write-Host "   npm run dev" -ForegroundColor Gray
Write-Host ""
Write-Host "📚 Check README.md for detailed instructions" -ForegroundColor Cyan
Write-Host "📖 Check API.md for API documentation" -ForegroundColor Cyan
Write-Host ""
Read-Host "Press Enter to exit"
