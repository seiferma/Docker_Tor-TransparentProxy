#!/bin/sh

# Test mandatory module for nft definitions to work
lsmod | grep nft_redir > /dev/null
if [ $? -ne 0 ]; then
    echo "ERROR: Could not find mandatory module nft_redir."
    echo "Try running modprobe \"nft_redir\" on your host system."
    exit 1
fi

# Apply nft definitions
nft -f /etc/nftables.conf
if [ $? -ne 0 ]; then
    echo "ERROR: Could not apply nftables definitions."
    echo "Try running the container with the capabilities NET_ADMIN and NET_RAW, e.g. by adding \"--cap-add=NET_ADMIN --cap-add=NET_RAW\" to your command."
    exit 1
fi

# Run tor under user "tor"
su tor -s /bin/sh -c "tor -f /etc/tor/torrc" > /tmp/tor.log &

# Execute command
exec "$@"