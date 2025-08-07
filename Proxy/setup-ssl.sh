#!/bin/bash

# SSL Certificate Setup Script
# This script sets up SSL certificates using a temporary docker-compose setup

set -e

echo "🔧 Setting up SSL certificates for proxy.minh-nguyen.tech, cloud.minh-nguyen.tech, owntracks.minh-nguyen.tech, and traccar.minh-nguyen.tech..."

# Check if domains are configured in DNS
echo "⚠️  Make sure proxy.minh-nguyen.tech, cloud.minh-nguyen.tech, owntracks.minh-nguyen.tech, and traccar.minh-nguyen.tech point to this server!"
echo "📧 Email configured: $(grep LETSENCRYPT_EMAIL .env | cut -d= -f2)"
echo ""

# Step 1: Stop any existing services that might conflict
echo "🛑 Step 1: Ensuring no conflicting services are running..."
docker compose down 2>/dev/null || true

# Step 2: Start temporary SSL setup
echo "� Step 2: Starting temporary nginx and certificate generation..."
docker compose -f docker-compose-ssl.yaml up certbot-setup

# Step 3: Clean up temporary services
echo "🧹 Step 3: Cleaning up temporary services..."
docker compose -f docker-compose-ssl.yaml down

# Step 4: Verify certificates were created
if [ -f "certbot/conf/live/proxy.minh-nguyen.tech/fullchain.pem" ]; then
    echo "✅ SSL certificates generated successfully!"
else
    echo "❌ SSL certificate generation failed!"
    exit 1
fi

echo ""
echo "✅ Setup complete! Certificates should be ready."
echo "🌐 You can access:"
echo "   - https://proxy.minh-nguyen.tech"
echo "   - https://cloud.minh-nguyen.tech"
echo "   - https://traccar.minh-nguyen.tech"
echo ""
echo "📋 To check status: docker compose ps"
echo "📋 To view logs: docker compose logs -f nginx"
