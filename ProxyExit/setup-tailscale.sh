#! /bin/bash

# Sets up Tailscale to allow access to a local network.
# By default, the network is 192.168.10.0/24

# Get the auth key from the first argument
if [ -z "$1" ]; then
    echo "Usage: $0 <Tailscale Auth Key>"
    exit 1
fi

TS_AUTHKEY=$1

# Install Tailscale
echo "Downloading and installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh

# Authenticate Tailscale with the provided auth key
echo "Authenticating Tailscale with the provided auth key..."
# NOTE: Change route here if necessary
sudo tailscale up --authkey "$TS_AUTHKEY" --accept-dns --advertise-routes=192.168.10.0/24

# Enable IP forwarding
echo "Enabling IP forwarding..."
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

# Print out status
echo "Tailscale status:"; echo
tailscale status

echo "Tailscale setup complete. You may need to reboot for all changes to take effect."
