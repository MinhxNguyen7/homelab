# Homelab Proxy

Proxy internet traffic to homelab services through WireGuard tunnel with SSL termination.

## Architecture
Internet → NGINX (SSL) → WireGuard → Home services (192.168.87.0/24)

## Files
- `docker-compose.yaml` - Main services (NGINX, WireGuard, Certbot)
- `nginx/nginx.conf` - Global NGINX config  
- `nginx/conf.d/*.conf` - Per-service proxy configs
- `certbot/` - Let's Encrypt certificates (auto-created)
- `wireguard/` - WireGuard configs (auto-created)

## Setup
1. Update domains in NGINX configs and email in docker-compose.yaml
2. Update home service IPs in NGINX configs (currently 192.168.87.x)
3. Add routing rule on VPS: `ip route add 192.168.87.0/24 dev wg0`
4. Run: `docker-compose up -d`
5. Generate certs: `docker-compose run --rm certbot`
6. Install WireGuard client config on home network

## Adding Services
1. Copy `service1.conf.template` to `newservice.conf`
2. Update `server_name` and `proxy_pass` 
3. Generate cert: `docker-compose run --rm certbot certonly --webroot -w /var/www/certbot -d newservice.domain.com`
4. Restart: `docker-compose restart nginx`

## Network
- NGINX terminates SSL, forwards HTTP through WireGuard tunnel
- Home services receive unencrypted requests at 192.168.87.x
- WireGuard provides encryption between VPS and home