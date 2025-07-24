# Telegram & Discord Integration Service

A Node.js service that integrates with both Telegram and Discord to send messages based on JSON input from external applications.

## Features

- Receives JSON messages via REST API
- Sends messages to Telegram users via Telegram Bot API
- Sends messages to Discord users via Discord Bot
- PostgreSQL database integration for logging and user management
- Separate tracking for Telegram and Discord messages
- Error handling and validation
- Environment-based configuration
- Demo mode for testing without bot tokens

## Setup

1. Install dependencies:
   ```bash
   npm install
   ```

2. Create a `.env` file with your configuration:
   ```env
   PORT=3000
   TELEGRAM_BOT_TOKEN=your_telegram_bot_token_here
   DISCORD_BOT_TOKEN=your_discord_bot_token_here
   DB_HOST=localhost
   DB_PORT=5432
   DB_NAME=telegram_service
   DB_USER=your_db_user
   DB_PASSWORD=your_db_password
   NODE_ENV=development
   ```

3. Initialize the database:
   ```bash
   npm run init-db
   npm run add-discord-tables
   ```

4. Start the service:
   ```bash
   npm start
   ```

   For development with auto-reload:
   ```bash
   npm run dev
   ```

## API Endpoints

### Telegram Endpoints

#### Send Telegram Message
- **POST** `/api/send-message`
- **Body:**
  ```json
  {
    "message": "Hello, this is a test message!",
    "receiver": "123456789"
  }
  ```

#### Get Telegram Message History
- **GET** `/api/messages/{chat_id}`

#### Telegram Bot Status
- **GET** `/api/bot-status`

### Discord Endpoints

#### Send Discord Message
- **POST** `/api/discord/send-message`
- **Body:**
  ```json
  {
    "message": "Hello, this is a Discord test message!",
    "receiver": "123456789012345678"
  }
  ```

#### Get Discord Message History
- **GET** `/api/discord/messages/{user_id}`

#### Discord Bot Status
- **GET** `/api/discord/bot-status`

### Health Check
- **GET** `/api/health`

## Getting Telegram Bot Token

1. Start a chat with [@BotFather](https://t.me/botfather) on Telegram
2. Send `/newbot` command
3. Follow the instructions to create your bot
4. Copy the bot token and add it to your `.env` file

## Getting User Chat ID

Users need to start a conversation with your bot first. You can get their chat ID by:
1. Having them send `/start` to your bot
2. The chat ID will be logged in the console
3. Store the chat ID in your database or use it directly

## Database Schema

The service creates the following tables:
- `messages`: Stores sent message logs
- `users`: Stores user information and chat IDs

## Error Handling

The service includes comprehensive error handling for:
- Invalid JSON format
- Missing required fields
- Telegram API errors
- Database connection issues
