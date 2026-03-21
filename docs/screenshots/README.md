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
9. 9_Wordpress
   - 9a. 9a_9500305_Wordpress_Apache - Apache2 actief (running) op container 9500305
   - 9b. 9b_9500305_Wordpress_SQL - MySQL actief (running), status "Server is operational"
   - 9c. 9c_9500305_Wordpress_PHP - PHP versie 8.3.6 geïnstalleerd
   - 9d. 9d_9500305_Wordpress_DB - MySQL toont database 'wordpress' aangemaakt
   - 9e. 9e_9500305_Wordpress - WordPress bestanden aanwezig in /var/www/html/wordpress
   - 9f. 9f_9500305_Wordpress_Installpage - WordPress installatiepagina bereikbaar via http://10.24.40.11/wordpress