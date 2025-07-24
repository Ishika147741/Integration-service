const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
require('dotenv').config();

const telegramService = require('./src/services/telegramService');
const DiscordService = require('./src/services/DiscordService');
const messageRoutes = require('./src/routes/messageRoutes');
const discordRoutes = require('./src/routes/discordRoutes');
const { initializeDatabase } = require('./src/config/database');
const { errorHandler } = require('./src/middleware/errorHandler');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(morgan('combined'));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/api', messageRoutes);
app.use('/api/discord', discordRoutes);

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    service: 'Telegram & Discord Integration Service'
  });
});

// Error handling middleware
app.use(errorHandler);

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    error: 'Route not found',
    message: `${req.method} ${req.originalUrl} is not a valid endpoint`
  });
});

// Initialize services and start server
async function startServer() {
  try {
    // Initialize database (optional for demo mode)
    const dbConnected = await initializeDatabase();
    if (dbConnected) {
      console.log('✅ Database initialized successfully');
    } else {
      console.log('⚠️  Running without database - some features may be limited');
    }

    // Initialize Telegram bot (optional for demo mode)
    try {
      await telegramService.initializeBot();
      console.log('✅ Telegram bot initialized successfully');
    } catch (error) {
      console.log('⚠️  Telegram bot initialization failed - running in demo mode');
      console.log('💡 Add TELEGRAM_BOT_TOKEN to .env to enable Telegram functionality');
    }

    // Initialize Discord bot (optional for demo mode)
    try {
      await DiscordService.initializeBot();
      console.log('✅ Discord bot initialized successfully');
    } catch (error) {
      console.log('⚠️  Discord bot initialization failed - running in demo mode');
      console.log('💡 Add DISCORD_BOT_TOKEN to .env to enable Discord functionality');
    }

    // Start server
    app.listen(PORT, () => {
      console.log(`🚀 Server running on port ${PORT}`);
      console.log(`📊 Health check: http://localhost:${PORT}/api/health`);
      console.log(`📨 Send Telegram message: POST http://localhost:${PORT}/api/send-message`);
      console.log(`💬 Send Discord message: POST http://localhost:${PORT}/api/discord/send-message`);
    });
  } catch (error) {
    console.error('❌ Failed to start server:', error);
    process.exit(1);
  }
}

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('\n🛑 Received SIGINT. Graceful shutdown...');
  process.exit(0);
});

process.on('SIGTERM', () => {
  console.log('\n🛑 Received SIGTERM. Graceful shutdown...');
  process.exit(0);
});

startServer();
