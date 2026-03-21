#!/bin/bash

# clone_wordpress_vms.sh
# Kloon template VM 9000 naar 6 WordPress VM's
# Uitvoeren op pve-node1 als root

set -e

TEMPLATE_ID=9000
STORAGE="ceph-pool"
GATEWAY="10.24.40.1"
BRIDGE="vmbr0"

declare -A VM_CONFIG=(
  [101]="pve-node1,10.24.40.21"
  [102]="pve-node1,10.24.40.22"
  [103]="pve-node2,10.24.40.23"
  [104]="pve-node2,10.24.40.24"
  [105]="pve-node3,10.24.40.25"
  [106]="pve-node3,10.24.40.26"
)

for VMID in "${!VM_CONFIG[@]}"; do
  NODE=$(echo ${VM_CONFIG[$VMID]} | cut -d',' -f1)
  IP=$(echo ${VM_CONFIG[$VMID]} | cut -d',' -f2)

  echo "=== Kloon VM ${VMID} op ${NODE} met IP ${IP} ==="

  qm clone ${TEMPLATE_ID} ${VMID} \
    --name "wordpress-$(echo $IP | cut -d'.' -f4)" \
    --full \
    --storage ${STORAGE} \
    --target ${NODE}

  qm set ${VMID} \
    --ipconfig0 ip=${IP}/24,gw=${GATEWAY} \
    --ciuser ubuntu \
    --cipassword Welkom01x \
    --sshkeys /root/.ssh/id_rsa.pub

  qm start ${VMID}

  echo "=== VM ${VMID} gestart op ${NODE} met IP ${IP} ==="
done

echo "=== Alle VM's gekloond en gestart ==="