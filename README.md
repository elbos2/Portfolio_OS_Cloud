# Portfolio_OS_Cloud

## 1. Proxmox cluster opzetten en monitoren

### Proxmox
Proxmox cluster (cluster-95003) opgezet met drie nodes: pve-node1 (10.24.40.2), pve-node2 (10.24.40.3) en pve-node3 (10.24.40.4). Ceph is geïnstalleerd als shared storage met HEALTH_OK status en 900GiB beschikbaar via ceph-pool (RBD).

**Toegang per node:**
- pve-node1: gebruiker `root`, SSH op standaard poort 22
- pve-node2: root login uitgeschakeld, gebruiker `ellaubo` (wachtwoord: `pannenkoekenmetstroop23$%`), SSH op poort 5995
- pve-node3: root login uitgeschakeld, gebruiker `ellaubo` (wachtwoord: `pannenkoekenmetstroop23$%`), SSH op poort 5995

Screenshots: 1_OverviewProxMox, 2_Netwerkinstellingen_Container_9500304, 3_Netwerkinstellingen_Container_9500305, 4_Cluster_Overview, 5a_Ceph_Health, 5b_Ceph_Status, 5c_Ceph_Storage, 6_Repo_Overview

### Monitoring
Netdata wordt gebruikt als monitoring tool voor het Proxmox cluster. Gekozen vanwege eenvoudige installatie, lichtgewicht en overzichtelijk dashboard. De monitoring container (95003-LXC) fungeert als parent node. pve-node1, pve-node2 en pve-node3 streamen als child nodes naar de parent. Installatie geautomatiseerd via Ansible playbook.

Screenshots: 7a_Monitoring_Netdata_Installatie, 7b_Monitoring_Netdata_Dashboard, 7c_Monitoring_Netdata_VMs, 7d_Monitoring_Netdata_node1, 7e_Monitoring_Netdata_node2, 7f_Monitoring_Netdata_node3, 7g_Monitoring_Netdata_Dashboard_Nodes

## 2. Uitrol van applicaties voor klanten volgens DevOps-methodiek

### Cloud-init template
Ubuntu 24.04 cloud-init template (VM 9000) aangemaakt op ceph-pool als golden image. Template is de basis voor alle WordPress VM's. SSH keys, gebruiker (ubuntu) en netwerkinstellingen zijn vooraf geconfigureerd via cloud-init.

Screenshots: 8a_Cloud_Init_Template, 8b_Cloud_Init_Template, 8c_Cloud_Init_Template, 8e_Cloud_Init_Template, 8f_Cloud_Init_Template, 8g_Cloud_Init_Template

### Handmatig WordPress installeren (voorbereiding)
Container 9500305 gebruikt om WordPress handmatig te installeren als voorbereiding op het bash script en Ansible playbook. Dit is de DevOps-methodiek: eerst handmatig begrijpen wat je doet, dan automatiseren.

- DB naam: wordpress
- DB gebruiker: wpuser
- DB wachtwoord: Welkom01x
- WordPress pad: /var/www/html/wordpress
- IP container: 10.24.40.11

Screenshots: 9a_9500305_Wordpress_Apache, 9b_9500305_Wordpress_SQL, 9c_9500305_Wordpress_PHP, 9d_9500305_Wordpress_DB, 9e_9500305_Wordpress, 9f_9500305_Wordpress_Installpage

### Klant 2 - WordPress op VM's met hoge beschikbaarheid

Klant 2 stelt hoge eisen aan beschikbaarheid en beveiliging. Gekozen voor VM's (i.p.v. LXC) vanwege betere isolatie en ondersteuning voor Proxmox HA. In eerste instantie zijn 6 VM's aangemaakt (later bijgesteld naar 3 voor klant 2); de bestaande VM's zijn hergebruikt.

**Uitrol stappen (DevOps-methodiek: bash → Ansible):**

1. **Bash script** `clone_wordpress_vms.sh` kloont template VM 9000 naar 6 VM's (101-106) verdeeld over de 3 nodes, elk met een uniek IP (10.24.40.21-26)
2. **Bash script** `install_wordpress.sh` getest op VM 101 (10.24.40.21) — WordPress succesvol geïnstalleerd
3. **Ansible** `install_wordpress.yml` uitgerold op alle 6 VM's — alle nodes changed, geen fouten
4. **Ansible** `configure_firewall.yml` — SSH, HTTP en HTTPS toegestaan, UFW ingeschakeld op alle VM's
5. **Ansible** `create_users.yml` — gebruikers aangemaakt, SSH public keys geplaatst
6. **Ansible** `install_netdata_wordpress.yml` — Netdata geïnstalleerd via kickstart, geconfigureerd op alle VM's, poort 19999 geopend in UFW

Screenshots: 10a_Wordpress_bashclonefile, 10b_Wordpress_nweVMs, 10c_Wordpress_GUIOverview, 10d_Wordpress_TestInstallScript, 10e_Wordpress_TestInstallScript, 10f_Wordpress_AnsiblePing_VM, 10g_Wordpress_AnsibleInstall, 10h_Wordpress_22, 10i_Wordpress_25, 10j_Wordpress_Firewall, 10k_Wordpress_Users, 10l_Wordpress_Netdata, 10m_Wordpress_Netdata

### Klant 1 - WordPress op LXC containers (kostenoptimalisatie)

Klant 1 wil WordPress voor trainingsdoeleinden, focus op lage kosten. Gekozen voor LXC containers omdat deze lichter zijn dan VM's (minder geheugen/CPU overhead) en goedkoper te draaien zijn.

**Noot:** Initieel zijn VM's aangemaakt voor beide klanten. Na heroverweging zijn de VM's toegewezen aan Klant 2 en worden LXC containers ingezet voor Klant 1. Dit is een bewuste keuze op basis van de eisen per klant.

**Uitrol stappen (DevOps-methodiek: bash → Ansible):**

1. **Bash script** `create_lxc_wordpress.sh` maakt CT 201 aan op pve-node1 (Ubuntu 24.04, local-lvm, IP 10.24.40.31), start de container en voert `install_wordpress.sh` uit via `pct exec`
2. **Ansible** `create_lxc_wordpress.yml` — CT 202 en 203 uitgerold op pve-node2 en pve-node3 *(volgt)*

Screenshots: 11a_LXC_bash, 11b_LXC_created, 11c_LXC_wordpress_installed