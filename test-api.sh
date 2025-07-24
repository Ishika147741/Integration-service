#!/bin/bash
# Comprehensive API Testing Script for Telegram Integration Service

echo "🚀 Testing Telegram Integration Service API Endpoints"
echo "=========================================================="
echo ""

BASE_URL="http://localhost:3000/api"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📊 1. Testing Health Check Endpoint${NC}"
echo "GET $BASE_URL/health"
echo "----------------------------------------"
curl -s -w "\nStatus Code: %{http_code}\n" $BASE_URL/health | jq '.'
echo ""

echo -e "${BLUE}🤖 2. Testing Bot Status Endpoint${NC}"
echo "GET $BASE_URL/bot-status"
echo "----------------------------------------"
curl -s -w "\nStatus Code: %{http_code}\n" $BASE_URL/bot-status | jq '.'
echo ""

echo -e "${BLUE}📨 3. Testing Send Message Endpoint (Valid Request)${NC}"
echo "POST $BASE_URL/send-message"
echo "----------------------------------------"
curl -s -w "\nStatus Code: %{http_code}\n" \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Hello! This is a test message from curl.",
    "receiver": "123456789"
  }' \
  $BASE_URL/send-message | jq '.'
echo ""

echo -e "${BLUE}📨 4. Testing Send Message with HTML Formatting${NC}"
echo "POST $BASE_URL/send-message"
echo "----------------------------------------"
curl -s -w "\nStatus Code: %{http_code}\n" \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "message": "<b>🔔 Alert!</b> Your order <code>ORD-12345</code> has been <i>shipped</i>.",
    "receiver": "987654321"
  }' \
  $BASE_URL/send-message | jq '.'
echo ""

echo -e "${RED}❌ 5. Testing Validation Error - Invalid Receiver${NC}"
echo "POST $BASE_URL/send-message"
echo "----------------------------------------"
curl -s -w "\nStatus Code: %{http_code}\n" \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Test message",
    "receiver": "invalid_chat_id"
  }' \
  $BASE_URL/send-message | jq '.'
echo ""

echo -e "${RED}❌ 6. Testing Validation Error - Missing Message${NC}"
echo "POST $BASE_URL/send-message"
echo "----------------------------------------"
curl -s -w "\nStatus Code: %{http_code}\n" \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "receiver": "123456789"
  }' \
  $BASE_URL/send-message | jq '.'
echo ""

echo -e "${RED}❌ 7. Testing Validation Error - Empty Message${NC}"
echo "POST $BASE_URL/send-message"
echo "----------------------------------------"
curl -s -w "\nStatus Code: %{http_code}\n" \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "message": "",
    "receiver": "123456789"
  }' \
  $BASE_URL/send-message | jq '.'
echo ""

echo -e "${RED}❌ 8. Testing Validation Error - Message Too Long${NC}"
echo "POST $BASE_URL/send-message"
echo "----------------------------------------"
LONG_MESSAGE=$(printf 'A%.0s' {1..5000})
curl -s -w "\nStatus Code: %{http_code}\n" \
  -X POST \
  -H "Content-Type: application/json" \
  -d "{
    \"message\": \"$LONG_MESSAGE\",
    \"receiver\": \"123456789\"
  }" \
  $BASE_URL/send-message | jq '.'
echo ""

echo -e "${BLUE}📜 9. Testing Message History Endpoint${NC}"
echo "GET $BASE_URL/messages/123456789"
echo "----------------------------------------"
curl -s -w "\nStatus Code: %{http_code}\n" $BASE_URL/messages/123456789 | jq '.'
echo ""

echo -e "${BLUE}📜 10. Testing Message History with Limit${NC}"
echo "GET $BASE_URL/messages/123456789?limit=5"
echo "----------------------------------------"
curl -s -w "\nStatus Code: %{http_code}\n" "$BASE_URL/messages/123456789?limit=5" | jq '.'
echo ""

echo -e "${RED}❌ 11. Testing Invalid Chat ID in History${NC}"
echo "GET $BASE_URL/messages/invalid_id"
echo "----------------------------------------"
curl -s -w "\nStatus Code: %{http_code}\n" $BASE_URL/messages/invalid_id | jq '.'
echo ""

echo -e "${RED}❌ 12. Testing 404 - Non-existent Endpoint${NC}"
echo "GET $BASE_URL/nonexistent"
echo "----------------------------------------"
curl -s -w "\nStatus Code: %{http_code}\n" $BASE_URL/nonexistent | jq '.'
echo ""

echo -e "${RED}❌ 13. Testing Invalid HTTP Method${NC}"
echo "DELETE $BASE_URL/send-message"
echo "----------------------------------------"
curl -s -w "\nStatus Code: %{http_code}\n" -X DELETE $BASE_URL/send-message | jq '.'
echo ""

echo -e "${RED}❌ 14. Testing Invalid JSON${NC}"
echo "POST $BASE_URL/send-message"
echo "----------------------------------------"
curl -s -w "\nStatus Code: %{http_code}\n" \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{invalid json}' \
  $BASE_URL/send-message | jq '.'
echo ""

echo -e "${YELLOW}🧪 15. Testing Development Test Endpoint (if available)${NC}"
echo "POST $BASE_URL/test-message"
echo "----------------------------------------"
curl -s -w "\nStatus Code: %{http_code}\n" \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "chatId": "123456789"
  }' \
  $BASE_URL/test-message | jq '.'
echo ""

echo "=========================================================="
echo -e "${GREEN}✅ API Testing Complete!${NC}"
echo ""
echo "Summary of expected results:"
echo "- Health check: 200 OK"
echo "- Bot status: 200 OK (connected: false in demo mode)"
echo "- Valid send message: 200 OK (demo mode simulation)"
echo "- Invalid requests: 400 Bad Request with validation errors"
echo "- Non-existent endpoints: 404 Not Found"
echo "- Message history: 500 Internal Server Error (no database in demo mode)"
echo ""
