#!/bin/bash

# clone_wordpress_vms.sh
# Kloon template VM 9000 naar 6 WordPress VM's
# Uitvoeren op pve-node1 als root

TEMPLATE_ID=9000
STORAGE="ceph-pool"
GATEWAY="10.24.40.1"
SSH_USER="ellaubo"
SSH_PORT="5995"

declare -A VM_CONFIG=(
  [101]="pve-node1,10.24.40.2,10.24.40.21"
  [102]="pve-node1,10.24.40.2,10.24.40.22"
  [103]="pve-node2,10.24.40.3,10.24.40.23"
  [104]="pve-node2,10.24.40.3,10.24.40.24"
  [105]="pve-node3,10.24.40.4,10.24.40.25"
  [106]="pve-node3,10.24.40.4,10.24.40.26"
)

for VMID in 101 102 103 104 105 106; do
  NODE=$(echo ${VM_CONFIG[$VMID]} | cut -d',' -f1)
  NODE_IP=$(echo ${VM_CONFIG[$VMID]} | cut -d',' -f2)
  VM_IP=$(echo ${VM_CONFIG[$VMID]} | cut -d',' -f3)

  echo "=== Kloon VM ${VMID} op ${NODE} met IP ${VM_IP} ==="

  qm clone ${TEMPLATE_ID} ${VMID} \
    --name "wordpress-$(echo $VM_IP | cut -d'.' -f4)" \
    --full \
    --storage ${STORAGE} \
    --target ${NODE}

  # Verwijder cicustom van template
  qm set ${VMID} --delete cicustom 2>/dev/null || true   

  echo "=== Configureer VM ${VMID} ==="
  if [ "${NODE}" == "pve-node1" ]; then
    qm set ${VMID} \
      --ipconfig0 ip=${VM_IP}/24,gw=${GATEWAY} \
      --ciuser ubuntu \
      --cipassword Welkom01x \
      --sshkeys /root/.ssh/id_rsa.pub
    qm start ${VMID}
  else
    ssh -p ${SSH_PORT} ${SSH_USER}@${NODE_IP} \
      "sudo qm set ${VMID} \
        --ipconfig0 ip=${VM_IP}/24,gw=${GATEWAY} \
        --ciuser ubuntu \
        --cipassword Welkom01x \
        --sshkeys /root/.ssh/id_rsa.pub && \
       sudo qm start ${VMID}"
  fi

  echo "=== VM ${VMID} gestart op ${NODE} met IP ${VM_IP} ==="
done

echo "=== Alle VM's gekloond en gestart ==="