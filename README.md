# Portfolio_OS_Cloud

## 1. Proxmox cluster opzetten en monitoren

### Proxmox
Proxmox cluster (cluster-95003) opgezet met drie nodes: pve-node1 (10.24.40.2), pve-node2 (10.24.40.3) en pve-node3 (10.24.40.4). Ceph is geïnstalleerd als shared storage met HEALTH_OK status en 900GiB beschikbaar via ceph-pool (RBD).

Screenshots: 1_OverviewProxMox, 2_Netwerkinstellingen_Container_9500304, 3_Netwerkinstellingen_Container_9500305, 4_Cluster_Overview, 5a_Ceph_Health, 5b_Ceph_Status, 5c_Ceph_Storage, 6_Repo_Overview

### Monitoring
Netdata wordt gebruikt als monitoring tool voor het Proxmox cluster. Gekozen vanwege eenvoudige installatie, lichtgewicht en overzichtelijk dashboard. De monitoring container (95003-LXC) fungeert als parent node. pve-node1, pve-node2 en pve-node3 streamen als child nodes naar de parent. Installatie geautomatiseerd via Ansible playbook.

Screenshots: 7a_Monitoring_Netdata_Installatie, 7b_Monitoring_Netdata_Dashboard, 7c_Monitoring_Netdata_VMs, 7d_Monitoring_Netdata_node1, 7e_Monitoring_Netdata_node2, 7f_Monitoring_Netdata_node3, 7g_Monitoring_Netdata_Dashboard_Nodes

## 2. Uitrol van applicaties voor klanten volgens DevOps-methodiek

### Cloud-init template
Ubuntu 24.04 cloud-init template (VM 9000) aangemaakt op ceph-pool als golden image. Template is de basis voor alle WordPress VM's. SSH keys, gebruiker (ubuntu) en netwerkinstellingen zijn vooraf geconfigureerd via cloud-init.

Screenshots: 8a_Cloud_Init_Template, 8b_Cloud_Init_Template, 8c_Cloud_Init_Template, 8e_Cloud_Init_Template, 8f_Cloud_Init_Template, 8g_Cloud_Init_Template

### Klant 1 - Handmatig WordPress installeren
Container 9500305 gebruikt om WordPress handmatig te installeren als voorbereiding op het bash script en Ansible playbook.

- DB naam: wordpress
- DB gebruiker: wpuser
- DB wachtwoord: Welkom01x
- WordPress pad: /var/www/html/wordpress
- IP container: 10.24.40.11

Screenshots: 9a_9500305_Wordpress_Apache, 9b_9500305_Wordpress_SQL, 9c_9500305_Wordpress_PHP, 9d_9500305_Wordpress_DB, 9e_9500305_Wordpress, 9f_9500305_Wordpress_Installpage