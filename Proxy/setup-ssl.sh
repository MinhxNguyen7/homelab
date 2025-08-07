#!/bin/bash

# SSL Certificate Setup Script - Cloudflare DNS Challenge
# This script sets up a wildcard SSL certificate using Cloudflare DNS challenge

set -e

echo "🔧 Setting up wildcard SSL certificate for *.minh-nguyen.tech using Cloudflare DNS challenge..."

# Check if Cloudflare API token is configured
if ! grep -q "CLOUDFLARE_API_TOKEN=" .env || grep -q "your_cloudflare_api_token_here" .env; then
    echo "❌ Cloudflare API token not configured!"
    echo "📝 Please update CLOUDFLARE_API_TOKEN in .env file"
    echo "🔗 Get API token from: https://dash.cloudflare.com/profile/api-tokens"
    echo "🔑 Permissions needed: Zone:DNS:Edit, Zone:Zone:Read for minh-nguyen.tech"
    exit 1
fi

echo "📧 Email configured: $(grep LETSENCRYPT_EMAIL .env | cut -d= -f2)"
echo "☁️  Using Cloudflare DNS challenge (no need for domain pointing to this server)"
echo ""

# Step 1: Stop any existing services that might conflict
echo "🛑 Step 1: Ensuring no conflicting services are running..."
docker compose down 2>/dev/null || true

# Step 2: Generate wildcard certificate using Cloudflare DNS challenge
echo "🌐 Step 2: Generating wildcard SSL certificate via Cloudflare DNS challenge..."
docker compose -f docker-compose-ssl.yaml up certbot-setup

# Step 3: Clean up temporary services
echo "🧹 Step 3: Cleaning up temporary services..."
docker compose -f docker-compose-ssl.yaml down

# Step 4: Verify certificates were created
if [ -f "certbot/conf/live/minh-nguyen.tech/fullchain.pem" ]; then
    echo "✅ Wildcard SSL certificate generated successfully!"
else
    echo "❌ SSL certificate generation failed!"
    exit 1
fi

echo ""
echo "✅ Setup complete! Wildcard certificate is ready for *.minh-nguyen.tech"
echo "🌐 You can now access any subdomain with HTTPS:"
echo "   - https://proxy.minh-nguyen.tech"
echo "   - https://cloud.minh-nguyen.tech" 
echo "   - https://owntracks.minh-nguyen.tech"
echo "   - https://traccar.minh-nguyen.tech"
echo "   - https://any-subdomain.minh-nguyen.tech"
echo ""
echo "📋 To check status: docker compose ps"
echo "📋 To view logs: docker compose logs -f nginx"
