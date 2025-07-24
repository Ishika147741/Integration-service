@echo off
echo ========================================
echo   Telegram Integration Service Setup
echo ========================================
echo.

REM Check if Node.js is installed
node --version > nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed or not in PATH
    echo Please install Node.js from https://nodejs.org/
    echo.
    pause
    exit /b 1
)

echo ✅ Node.js found: 
node --version

REM Check if npm is available
npm --version > nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ npm is not available
    pause
    exit /b 1
)

echo ✅ npm found: 
npm --version

REM Install dependencies
echo.
echo 📦 Installing dependencies...
npm install

if %errorlevel% neq 0 (
    echo ❌ Failed to install dependencies
    pause
    exit /b 1
)

echo ✅ Dependencies installed successfully

REM Check if .env file exists
if not exist ".env" (
    echo.
    echo 📝 Creating .env file from template...
    copy ".env.example" ".env"
    echo ⚠️  Please edit the .env file with your configuration:
    echo    - Add your Telegram bot token
    echo    - Configure database connection
    echo.
) else (
    echo ✅ .env file already exists
)

REM Check if PostgreSQL is running
echo.
echo 🔍 Checking PostgreSQL connection...
psql --version > nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  PostgreSQL client not found in PATH
    echo Please ensure PostgreSQL is installed and running
) else (
    echo ✅ PostgreSQL client found
)

echo.
echo 📋 Setup completed! Next steps:
echo.
echo 1. Edit the .env file with your configuration:
echo    - TELEGRAM_BOT_TOKEN: Get from @BotFather on Telegram
echo    - Database credentials: Configure for your PostgreSQL instance
echo.
echo 2. Initialize the database:
echo    npm run init-db
echo.
echo 3. Start the service:
echo    npm start
echo.
echo 4. For development with auto-reload:
echo    npm run dev
echo.
echo 📚 Check README.md for detailed instructions
echo 📖 Check API.md for API documentation
echo.
pause
