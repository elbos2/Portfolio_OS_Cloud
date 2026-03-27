# Deze folder bevat alle screenshots van het project

## Uitleg per screenshot:

1. 1_OverviewProxMox - Overzicht van alle containers en VM's onder node PVEDT01
2. 2_Netwerkinstellingen_Container_9500304 - Netwerkinstellingen van container 9500304
3. 3_Netwerkinstellingen_Container_9500305 - Netwerkinstellingen van container 9500305
4. 4_Cluster_Overview - Overzicht van het Proxmox cluster (pvecm status) met 3 nodes
5. 5_Ceph_Status - Ceph clusterstatus (HEALTH\_OK) met 3 OSD's en 900GiB beschikbaar
6. 6_Repo_Overview - Overzicht van de apt repositories, enterprise repo uitgeschakeld en no-subscription repo actief
7. 7_Monitoring_Netdata
   - 7a. 7a_Monitoring_Netdata_Installatie - Netdata service actief (running) op container 95003-LXC, geïnstalleerd via apt
   - 7b. 7b_Monitoring_Netdata_Dashboard - Netdata dashboard op 10.24.40.10 met System Overview, 1 live node (95003-LXC)
   - 7c. 7c_Monitoring_Netdata_VMs - Ansible playbook netdata_install.yml uitgevoerd op pve-node2 en pve-node3, alle 5 taken geslaagd
   - 7d. 7d_Monitoring_Netdata_node1 - Netdata database overzicht op pve-node1 (10.24.40.2), 4.426 metrics verzameld
   - 7e. 7e_Monitoring_Netdata_node2 - Netdata database overzicht op pve-node2 (10.24.40.3), 4.295 metrics verzameld
   - 7f. 7f_Monitoring_Netdata_node3 - Netdata database overzicht op pve-node3 (10.24.40.4), 4.326 metrics verzameld
   - 7g. 7g_Monitoring_Netdata_Dashboard_Nodes - Netdata dashboard met 4 live nodes: 95003-LXC, pve-node1, pve-node2, pve-node3
8. 8_Cloud_Init_Template
   - 8a. 8a_Cloud_Init_Template - Ubuntu cloud image gedownload (600MB) en vergroot naar 32GB met qemu-img resize
   - 8b. 8b_Cloud_Init_Template - VM 9000 aangemaakt op ceph-pool met EFI disk
   - 8c. 8c_Cloud_Init_Template - Disk (32GB) geïmporteerd naar ceph-pool, boot order en cloud-init drive ingesteld
   - 8e. 8e_Cloud_Init_Template - Cloud-init configuratie: cicustom, tags, ciuser, cipassword en sshkeys ingesteld
   - 8f. 8f_Cloud_Init_Template - Template VM 9000 zichtbaar in Proxmox GUI met tags 24.04, cloudinit, ubuntu-template; test-clone 9001 draait op 10.24.40.20
   - 8g. 8g_Cloud_Init_Template - SSH verbinding succesvol naar ubuntu@10.24.40.20, Ubuntu 24.04 LTS
9. 9_Wordpress (handmatig - voorbereiding)
   - 9a. 9a_9500305_Wordpress_Apache - Apache2 actief (running) op container 9500305
   - 9b. 9b_9500305_Wordpress_SQL - MySQL actief (running), status "Server is operational"
   - 9c. 9c_9500305_Wordpress_PHP - PHP versie 8.3.6 geïnstalleerd
   - 9d. 9d_9500305_Wordpress_DB - MySQL toont database 'wordpress' aangemaakt
   - 9e. 9e_9500305_Wordpress - WordPress bestanden aanwezig in /var/www/html/wordpress
   - 9f. 9f_9500305_Wordpress_Installpage - WordPress installatiepagina bereikbaar via http://10.24.40.11/wordpress

10. 10_Klant2_Wordpress_VMs (Klant 2 - hoge beschikbaarheid op VM's)
   - 10a. 10a_Wordpress_bashclonefile - Bash script clone_wordpress_vms.sh kloont template VM 9000 naar VM 101 op pve-node1, disk van 32GB wordt gekopieerd naar ceph-pool
   - 10b. 10b_Wordpress_nweVMs - qm list toont alle 6 WordPress VM's (101-106) verdeeld over 3 nodes, allemaal running met 1GB RAM en 32GB disk
   - 10c. 10c_Wordpress_GUIOverview - Proxmox GUI overzicht met alle 6 WordPress VM's (101-106) zichtbaar over pve-node1, pve-node2 en pve-node3
   - 10d. 10d_Wordpress_TestInstallScript - Bash script install_wordpress.sh succesvol uitgevoerd op VM 101, WordPress bereikbaar via http://10.24.40.21/wordpress
   - 10e. 10e_Wordpress_TestInstallScript - WordPress site actief en bereikbaar in browser op http://10.24.40.21/wordpress
   - 10f. 10f_Wordpress_AnsiblePing_VM - Ansible ping naar alle 6 WordPress VM's via inventory.ini, alle hosts bereikbaar (pong)
   - 10g. 10g_Wordpress_AnsibleInstall - Ansible playbook install_wordpress.yml uitgevoerd op alle 6 VM's, script gekopieerd en uitgevoerd, PLAY RECAP toont ok op alle nodes
   - 10h. 10h_Wordpress_22 - WordPress site bereikbaar op http://10.24.40.22/wordpress (VM 102, pve-node1)
   - 10i. 10i_Wordpress_25 - WordPress site bereikbaar op http://10.24.40.25/wordpress (VM 105, pve-node3)
   - 10j. 10j_Wordpress_Firewall - Ansible playbook configure_firewall.yml uitgevoerd, SSH/HTTP/HTTPS toegestaan en UFW ingeschakeld op alle 6 VM's
   - 10k. 10k_Wordpress_Users - Ansible playbook create_users.yml uitgevoerd, gebruikers aangemaakt en SSH public keys geplaatst op alle 6 VM's
   - 10l. 10l_Wordpress_Netdata - Ansible playbook install_netdata_wordpress.yml uitgevoerd, Netdata geïnstalleerd via kickstart en geconfigureerd op alle VM's, poort 19999 geopend in UFW
   - 10m. 10m_Wordpress_Netdata - Netdata dashboard bereikbaar op http://10.24.40.21:19999, 3.528 metrics actief verzameld

11. 11_Klant1_LXC (Klant 1 - WordPress op LXC containers)
   - 11a. 11a_LXC_bash - Bash script create_lxc_wordpress.sh succesvol uitgevoerd op pve-node1, WordPress geïnstalleerd in CT 201 via pct exec, bereikbaar op http://10.24.40.31/wordpress
   - 11b. 11b_LXC_created - CT 201 (wordpress-lxc-1) zichtbaar in Proxmox GUI, running op pve-node1, Ubuntu, IP 10.24.40.31, unprivileged
   - 11c. 11c_LXC_wordpress_installed - WordPress site bereikbaar in browser op http://10.24.40.31/wordpress (CT 201)