# Homelab Proxy

Proxy internet traffic to homelab services through Tailscale tunnel,
performing SSL termination and proxying with NGINX.

## Architecture
Internet → NGINX (SSL) → Tailscale (VPS) → Tailscale (local) → Home services (192.168.10.0/24)

## Setup
1. Get Tailscale Auth Key
2. Set up Tailscale on VPS
   - `cd Proxy`
   - `./setup-tailscale.sh <Tailscale Auth Key>`
3. Set up SSL certificates
    - `./setup-ssl.sh`
4. Run NGINX
   - `docker-compose up -d`
