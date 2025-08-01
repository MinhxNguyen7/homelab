# WireGuard Client

WireGuard client to connect home network to VPS proxy for internet access to homelab services.

## Setup

1. **Get configuration from VPS**:
   ```bash
   # On VPS, get the client config
   cat /path/to/proxy/wireguard/config/peer1/peer1.conf
   ```

2. **Create config file**:
   ```bash
   cp config/wg0.conf.template config/wg0.conf
   ```

3. **Update config** with values from VPS:
   - `PrivateKey`: Client's private key
   - `PublicKey`: VPS server's public key  
   - `PresharedKey`: Shared key for additional security
   - `Endpoint`: VPS IP address and port (51820)

4. **Start client**:
   ```bash
   docker-compose up -d
   ```

## How it works

- Client gets IP `10.13.13.2` on VPN network
- Routes traffic for `192.168.10.0/24` through VPS
- VPS NGINX proxies incoming requests to home services
- Enables internet access to homelab via domain names

## Files

- `docker-compose.yaml`: WireGuard client container
- `config/wg0.conf.template`: Configuration template
- `config/wg0.conf`: Actual config (git-ignored)

## Troubleshooting

Check connection status:
```bash
docker exec wg-client-homelab wg show
```