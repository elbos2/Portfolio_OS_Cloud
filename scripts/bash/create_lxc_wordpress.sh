#!/bin/bash

# create_lxc_wordpress.sh
# Aanmaken van 1 LXC container voor Klant 1 (WordPress - goedkoop/LXC)
# Uitvoeren op pve-node1 als root

set -e

# === Configuratie ===
CT_ID=201
CT_HOSTNAME="wordpress-lxc-1"
STORAGE="local-lvm"
TEMPLATE="local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
MEMORY=1024
CORES=1
DISK_SIZE=8
CT_PASSWORD="Welkom01x"
BRIDGE="vmbr0"
IP="10.24.40.31/24"
GATEWAY="10.24.40.1"
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

echo "=== Controleer of template beschikbaar is ==="
if ! pveam list local | grep -q "ubuntu-24.04-standard"; then
  echo "Template niet gevonden, downloaden..."
  pveam update
  pveam download local ubuntu-24.04-standard_24.04-2_amd64.tar.zst
fi

echo "=== Aanmaken LXC container ${CT_ID} ==="
pct create ${CT_ID} ${TEMPLATE} \
  --hostname ${CT_HOSTNAME} \
  --memory ${MEMORY} \
  --cores ${CORES} \
  --rootfs ${STORAGE}:${DISK_SIZE} \
  --net0 name=eth0,bridge=${BRIDGE},ip=${IP},gw=${GATEWAY} \
  --password ${CT_PASSWORD} \
  --unprivileged 1 \
  --features nesting=1 \
  --onboot 1

echo "=== Starten container ${CT_ID} ==="
pct start ${CT_ID}
sleep 10

echo "=== DNS instellen in container ==="
pct exec ${CT_ID} -- bash -c "echo 'nameserver 8.8.8.8' > /etc/resolv.conf"

echo "=== Kopieer WordPress installatiescript naar container ==="
pct push ${CT_ID} "${SCRIPT_DIR}/install_wordpress.sh" /tmp/install_wordpress.sh
pct exec ${CT_ID} -- chmod +x /tmp/install_wordpress.sh

echo "=== Voer WordPress installatie uit in container ==="
pct exec ${CT_ID} -- bash /tmp/install_wordpress.sh

echo ""
echo "=== Klaar! ==="
echo "WordPress bereikbaar op: http://${IP%/*}/wordpress"
echo "Admin: http://${IP%/*}/wordpress/wp-admin"
