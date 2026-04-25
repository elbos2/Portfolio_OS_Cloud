#!/bin/bash

# create_gitea_vm.sh
# Maak Gitea VM aan op pve-node1 door template 9000 te klonen
# Uitvoeren op pve-node1 als root

TEMPLATE_ID=9000
VMID=400
VM_NAME="gitea"
VM_IP="10.24.40.40"
GATEWAY="10.24.40.1"
DNS="8.8.8.8"
STORAGE="ceph-pool"
NODE="pve-node1"
CI_USER="ubuntu"
CI_PASSWORD="Welkom01x"

echo "=== Kloon template ${TEMPLATE_ID} naar VM ${VMID} (${VM_NAME}) ==="

qm clone ${TEMPLATE_ID} ${VMID} \
  --name "${VM_NAME}" \
  --full \
  --storage ${STORAGE} \
  --target ${NODE}

echo "=== Verwijder cicustom van template ==="
qm set ${VMID} --delete cicustom 2>/dev/null || true

echo "=== Configureer VM resources ==="
qm set ${VMID} \
  --cores 2 \
  --memory 2048 \
  --onboot 1

echo "=== Stel Cloud-Init in ==="
qm set ${VMID} \
  --ipconfig0 ip=${VM_IP}/24,gw=${GATEWAY} \
  --nameserver ${DNS} \
  --ciuser ${CI_USER} \
  --cipassword ${CI_PASSWORD} \
  --sshkeys /root/.ssh/id_rsa.pub

echo "=== Start VM ${VMID} ==="
qm start ${VMID}

echo ""
echo "=== Gitea VM aangemaakt en gestart ==="
echo "    VM ID : ${VMID}"
echo "    Naam  : ${VM_NAME}"
echo "    IP    : ${VM_IP}"
echo "    Node  : ${NODE}"
echo ""
echo "Wacht ~30 seconden totdat Cloud-Init klaar is, daarna:"
echo "  ssh ubuntu@${VM_IP}"
