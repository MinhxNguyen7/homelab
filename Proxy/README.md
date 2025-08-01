# Homelab Proxy

Proxy internet traffic to homelab services through WireGuard tunnel with SSL termination.

## Architecture
Internet → NGINX (SSL) → WireGuard → Home services (192.168.87.0/24)

## Files
- `docker-compose.yaml` - Main services (NGINX, WireGuard, Certbot)
- `.env` - Configuration variables (email, domains, WireGuard settings)
- `nginx/nginx.conf` - Global NGINX config  
- `nginx/conf.d/*.conf` - Per-service proxy configs
- `certbot/` - Let's Encrypt certificates (auto-created)
- `wireguard/` - WireGuard configs (auto-created)

## Setup
1. Update `.env` file with your email and domains
2. Update home service IPs in NGINX configs (currently 192.168.87.x)
3. Update certbot domains in docker-compose.yaml if needed
4. Run: `docker-compose up -d` (routing is set up automatically)
5. Generate certs: `docker-compose run --rm certbot`
6. Install WireGuard client config on home network

## Adding Services
1. Copy `service1.conf.template` to `newservice.conf`
2. Update `server_name` and `proxy_pass` 
3. Add domain to certbot command in docker-compose.yaml
4. Regenerate certs: `docker-compose run --rm certbot`
5. Restart: `docker-compose restart nginx`

## Maintenance
- Certificates auto-renew via `certbot-renew` service (checks every 12 hours)
- Monitor logs: `docker-compose logs -f`

## Network
- NGINX terminates SSL, forwards HTTP through WireGuard tunnel
- Home services receive unencrypted requests at 192.168.87.x
- WireGuard provides encryption between VPS and home