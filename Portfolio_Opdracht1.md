# Portfolio Opdracht 1 — Beheer en uitrol van Proxmox cluster en webapplicaties

## Inhoudsopgave
1. [Algemene configuratie](#1-algemene-configuratie)
   - [Proxmox cluster](#11-proxmox-cluster)
   - [Ceph storage](#12-ceph-storage)
   - [Monitoring — Netdata + Grafana](#13-monitoring--netdata--grafana)
2. [Klant 2 — WordPress op VM's met hoge beschikbaarheid](#2-klant-2--wordpress-op-vms-met-hoge-beschikbaarheid)
3. [Klant 1 — WordPress op LXC containers](#3-klant-1--wordpress-op-lxc-containers)

---

## 1. Algemene configuratie

### 1.1 Proxmox cluster

Proxmox cluster (cluster-95003) opgezet met drie nodes: pve-node1 (10.24.40.2), pve-node2 (10.24.40.3) en pve-node3 (10.24.40.4).

**Infrastructuur:**
pve-node1, pve-node2 en pve-node3 zijn VM's die draaien op de schoolomgeving (PVEDT01). De Netdata monitoring container (95003-LXC, IP 10.24.40.10) en Grafana VM (IP 10.24.40.11) draaien ook op PVEDT01, buiten het cluster-95003.

**Toegang per node:**
- pve-node1: gebruiker `root`, SSH poort 22
- pve-node2: gebruiker `ellaubo`, SSH poort 5995
- pve-node3: gebruiker `ellaubo`, SSH poort 5995

![Proxmox overzicht](docs/screenshots/1_OverviewProxMox.png)

![Cluster overzicht](docs/screenshots/4_Cluster_Overview.png)

![Netwerkinstellingen container 9500304](docs/screenshots/2_Netwerkinstellingen_Container_9500304.png)

![Netwerkinstellingen container 9500305](docs/screenshots/3_Netwerkinstellingen_Container_9500305.png)

![Repository overzicht](docs/screenshots/6_Repo_Overview.png)

---

### 1.2 Ceph storage

Ceph geïnstalleerd als shared storage met HEALTH_OK status en 900GiB beschikbaar via ceph-pool (RBD).

![Ceph health](docs/screenshots/5a_Ceph_Health.png)

![Ceph status](docs/screenshots/5b_Ceph_Status.png)

![Ceph storage](docs/screenshots/5c_Ceph_Storage.png)

---

### 1.3 Monitoring — Netdata + Grafana

#### Netdata

Netdata wordt ingezet als metrics collector op alle nodes. De monitoring container (95003-LXC, IP 10.24.40.10) fungeert als parent node. pve-node1/2/3, de WordPress VM's en LXC's streamen als child nodes naar de parent via het Netdata streaming protocol.

**Reden voor Grafana toevoeging:**
Netdata v2 (de huidige stabiele versie) heeft een beperking in de lokale dashboard van maximaal 5 nodes zonder Netdata Cloud account. Omdat het cluster meer dan 5 nodes heeft, is Grafana toegevoegd als dashboard zonder node-limieten.

**Installatie:**
```bash
ansible-playbook scripts/ansible/configure_netdata_streaming.yml -i scripts/ansible/inventory.ini
```

![Netdata installatie](docs/screenshots/7a_Monitoring_Netdata_Installatie.png)

![Netdata dashboard](docs/screenshots/7b_Monitoring_Netdata_Dashboard.png)

![Netdata VMs](docs/screenshots/7c_Monitoring_Netdata_VMs.png)

![Netdata node1](docs/screenshots/7d_Monitoring_Netdata_node1.png)

![Netdata node2](docs/screenshots/7e_Monitoring_Netdata_node2.png)

![Netdata node3](docs/screenshots/7f_Monitoring_Netdata_node3.png)

![Netdata alle nodes](docs/screenshots/7g_Monitoring_Netdata_Dashboard_Nodes.png)

#### Grafana + Prometheus

Grafana VM (VM 123, IP 10.24.40.11) aangemaakt op pve-node1 als clone van de Ubuntu 24.04 cloud-init template. Prometheus scrapt alle Netdata nodes individueel via de Prometheus endpoint. Grafana visualiseert de data per node selecteerbaar via de Instance dropdown.

**Installatie:**
```bash
ansible-playbook scripts/ansible/install_grafana_prometheus.yml -i scripts/ansible/inventory.ini
```

**Grafana dashboard:** `http://10.24.40.11:3000` (login: admin/admin bij eerste gebruik)

<!-- Screenshots toevoegen na maken: -->
<!-- ![Grafana dashboard](docs/screenshots/7h_Grafana_Dashboard.png) -->
<!-- ![Grafana nodes](docs/screenshots/7i_Grafana_Nodes.png) -->

---

## 2. Klant 2 — WordPress op VM's met hoge beschikbaarheid

Klant 2 gebruikt WordPress als CRM-applicatie en stelt hoge eisen aan beschikbaarheid en beveiliging. Gekozen voor VM's vanwege betere isolatie en ondersteuning voor Proxmox HA.

### 2.1 Cloud-init template

Ubuntu 24.04 cloud-init template (VM 9000) aangemaakt op ceph-pool als golden image. SSH keys, gebruiker (ubuntu) en netwerkinstellingen zijn vooraf geconfigureerd.

![Cloud-init template stap 1](docs/screenshots/8a_Cloud_Init_Template.png)

![Cloud-init template stap 2](docs/screenshots/8b_Cloud_Init_Template.png)

![Cloud-init template stap 3](docs/screenshots/8c_Cloud_Init_Template.png)

![Cloud-init template stap 4](docs/screenshots/8e_Cloud_Init_Template.png)

![Cloud-init template stap 5](docs/screenshots/8f_Cloud_Init_Template.png)

![Cloud-init template stap 6](docs/screenshots/8g_Cloud_Init_Template.png)

### 2.2 Handmatige installatie (voorbereiding)

WordPress eerst handmatig geïnstalleerd in container 9500305 als voorbereiding op automatisering — DevOps-methodiek: eerst begrijpen, dan automatiseren.

![WordPress Apache](docs/screenshots/9a_9500305_Wordpress_Apache.png)

![WordPress SQL](docs/screenshots/9b_9500305_Wordpress_SQL.png)

![WordPress PHP](docs/screenshots/9c_9500305_Wordpress_PHP.png)

![WordPress database](docs/screenshots/9d_9500305_Wordpress_DB.png)

![WordPress](docs/screenshots/9e_9500305_Wordpress.png)

![WordPress installatiepagina](docs/screenshots/9f_9500305_Wordpress_Installpage.png)

### 2.3 Geautomatiseerde uitrol via Ansible

6 VM's aangemaakt (101-106) verdeeld over de 3 nodes, elk met een uniek IP (10.24.40.21-26).

**Uitrol stappen (DevOps-methodiek: bash → Ansible):**

1. **Bash** `clone_wordpress_vms.sh` — kloont template VM 9000 naar 6 VM's
2. **Bash** `install_wordpress.sh` — getest op VM 101 (10.24.40.21)
3. **Ansible** `install_wordpress.yml` — uitgerold op alle 6 VM's
4. **Ansible** `configure_firewall.yml` — SSH, HTTP en HTTPS toegestaan, UFW ingeschakeld
5. **Ansible** `create_users.yml` — gebruikers aangemaakt, SSH public keys geplaatst
6. **Ansible** `install_netdata_wordpress.yml` — Netdata geïnstalleerd op alle VM's

```bash
ansible-playbook scripts/ansible/install_wordpress.yml -i scripts/ansible/inventory.ini
ansible-playbook scripts/ansible/configure_firewall.yml -i scripts/ansible/inventory.ini
ansible-playbook scripts/ansible/create_users.yml -i scripts/ansible/inventory.ini
ansible-playbook scripts/ansible/install_netdata_wordpress.yml -i scripts/ansible/inventory.ini
```

![Bash clone script](docs/screenshots/10a_Wordpress_bashclonefile.png)

![Nieuwe VM's aangemaakt](docs/screenshots/10b_Wordpress_nweVMs.png)

![GUI overzicht VM's](docs/screenshots/10c_Wordpress_GUIOverview.png)

![Test install script stap 1](docs/screenshots/10d_Wordpress_TestInstallScript.png)

![Test install script stap 2](docs/screenshots/10e_Wordpress_TestInstallScript.png)

![Ansible ping VM's](docs/screenshots/10f_Wordpress_AnsiblePing_VM.png)

![Ansible installatie](docs/screenshots/10g_Wordpress_AnsibleInstall.png)

![WordPress VM 22](docs/screenshots/10h_Wordpress_22.png)

![WordPress VM 25](docs/screenshots/10i_Wordpress_25.png)

![Firewall configuratie](docs/screenshots/10j_Wordpress_Firewall.png)

![Gebruikers aangemaakt](docs/screenshots/10k_Wordpress_Users.png)

![Netdata op VM's](docs/screenshots/10l_Wordpress_Netdata.png)

![Netdata op VM's bevestiging](docs/screenshots/10m_Wordpress_Netdata.png)

---

## 3. Klant 1 — WordPress op LXC containers

Klant 1 wil WordPress voor trainingsdoeleinden met focus op lage kosten. Gekozen voor LXC containers vanwege lagere overhead en lagere kosten ten opzichte van VM's.

### 3.1 Geautomatiseerde uitrol via bash en Ansible

**Uitrol stappen (DevOps-methodiek: bash → Ansible):**

1. **Bash** `create_lxc_wordpress.sh` — maakt CT 201 aan op pve-node1 (Ubuntu 24.04, IP 10.24.40.31), installeert WordPress via `pct exec`
2. **Ansible** `create_lxc_wordpress.yml` — CT 202 (10.24.40.32) op pve-node2 en CT 203 (10.24.40.33) op pve-node3 aangemaakt en WordPress geïnstalleerd

```bash
bash scripts/bash/create_lxc_wordpress.sh
ansible-playbook scripts/ansible/create_lxc_wordpress.yml -i scripts/ansible/inventory.ini
```

![LXC bash script](docs/screenshots/11a_LXC_bash.png)

![LXC aangemaakt](docs/screenshots/11b_LXC_created.png)

![LXC WordPress geïnstalleerd](docs/screenshots/11c_LXC_wordpress_installed.png)

![LXC Ansible uitrol](docs/screenshots/11d_LXC_wordpress_ansible.png)

![LXC Ansible aangemaakt](docs/screenshots/11e_LXC_wordpress_ansible_created.png)

![LXC 2 WordPress](docs/screenshots/11f_LXC2_wordpress.png)

![LXC 3 WordPress](docs/screenshots/11g_LXC3_wordpress.png)

![LXC firewall](docs/screenshots/11h_LXC_wordpress_Firewall.png)

![LXC Netdata](docs/screenshots/11i_LXC_wordpress_Netdata.png)

### 3.2 Netdata streaming

Alle nodes (VM's en LXC's) geconfigureerd om te streamen naar de Netdata parent via Ansible.

```bash
ansible-playbook scripts/ansible/configure_netdata_streaming.yml -i scripts/ansible/inventory.ini
```

![Netdata streaming Ansible](docs/screenshots/12a_Netdata_Streaming_Ansible.png)

![Netdata node restrictie (5-node limiet lokaal dashboard)](docs/screenshots/12b_Netdata_noderestriction.png)

![Netdata nodes overzicht](docs/screenshots/12c_Netdata_NodesOverview.png)
