# Portfolio Opdracht 2

## Inhoudsopgave
1. [Voorbereiding](#1-voorbereiding)
2. [Les 4 - Docker installatie en basiscontrole](#2-les-4---docker-installatie-en-basiscontrole)
3. [Les 7 - Dockerfile, image build en container](#3-les-7---dockerfile-image-build-en-container)
4. [Les 8 - Docker Compose stack](#4-les-8---docker-compose-stack)
5. [Les 9 - Docker Swarm](#5-les-9---docker-swarm)
6. [Extra - Geautomatiseerd uitvoeren via Ansible](#6-extra---geautomatiseerd-uitvoeren-via-ansible)
7. [Basic Docker Networking](#7-basic-docker-networking)

---

## 1. Voorbereiding

Voor deze opdracht zijn drie Docker-VM's gebruikt, verdeeld over de drie Proxmox-nodes:
- docker-mgr-1 (10.24.40.22)
- docker-mgr-2 (10.24.40.24)
- docker-mgr-3 (10.24.40.26)

De extra WordPress-VM's uit Opdracht 1 zijn hergebruikt als Docker-hosts.

![Hergebruik VM's](docs/screenshots/14a_Opdracht2_Reuse_WordpressVMs4Docker.png)

---

## 2. Les 4 - Docker installatie en basiscontrole

### Doel

Docker installeren op de hosts en controleren dat Docker correct werkt.

### Uitvoering

- Docker geïnstalleerd.
- Docker versie gecontroleerd.
- Basiscontainer getest met hello-world.
- Containers en images gecontroleerd met docker ps en docker images.

### Bewijs

![Installatie en basiscontrole](docs/screenshots/14c_Opdracht2_DockerInstall_VM1.png)

---

## 3. Les 7 - Dockerfile, image build en container

### Doel

Een Docker image bouwen met een Dockerfile en daarin een container starten.

### Uitvoering

- Dockerfile aangemaakt op VM1.
- Image gebouwd met docker build.
- Nieuwe container gestart met docker run.
- Dezelfde werkwijze herhaald op VM2 en VM3.

### Bewijs

![Dockerfile VM1](docs/screenshots/14d_Opdracht2_DockerFile_VM1.png)

![Build en run VM1](docs/screenshots/14e_Opdracht2_DockerFileBuildRun_VM1.png)

![Build en run VM2](docs/screenshots/14f_Opdracht2_DockerFileBuildRun_VM2.png)

![Build en run VM3](docs/screenshots/14g_Opdracht2_DockerFileBuildRun_VM3.png)

---

## 4. Les 8 - Docker Compose stack

### Doel

Een multi-container stack draaien met Docker Compose.

### Uitvoering

- docker-compose.yml aangemaakt.
- Stack gestart met docker compose up -d.
- Controle uitgevoerd met docker ps en docker compose logs.
- Herhaald op alle drie Docker-hosts.

### Bewijs

![Compose bestand VM1](docs/screenshots/14h_Opdracht2_DockerCompose_VM1.png)

![Compose up VM1](docs/screenshots/14i_Opdracht2_DockerComposeUp_VM1.png)

![Compose up VM2](docs/screenshots/14j_Opdracht2_DockerComposeUp_VM2.png)

![Compose up VM3](docs/screenshots/14k_Opdracht2_DockerComposeUp_VM3.png)

---

## 5. Les 9 - Docker Swarm

### Doel

Een swarmcluster opzetten met 3 managers (1 per Proxmox-node).

### Uitvoering

- Swarm geïnitialiseerd op docker-mgr-1.
- docker-mgr-2 en docker-mgr-3 toegevoegd als manager.
- Clusterstatus gecontroleerd met docker node ls.

### Bewijs

![Swarm met 3 managers](docs/screenshots/14l_Opdracht2_Swarm.png)

---

## 6. Extra - Geautomatiseerd uitvoeren via Ansible

Vanaf de swarm-stap is de setup geautomatiseerd uitgevoerd met Ansible.

Gebruikte bestanden:
- scripts/ansible/inventory.ini
- scripts/ansible/docker_swarm_setup.yml

Playbook resultaat:
- mgr1 als leader
- mgr2 en mgr3 als reachable managers
- validatie via docker node ls in de playbook-output

---

## 7. Basic Docker Networking

### Status

Basisnetwerkcontrole is uitgevoerd tijdens:
- containerbereikbaarheid via localhost en gepubliceerde poorten;
- compose stack netwerk (default compose network);
- swarm node connectiviteit.

Aanvullend subnet/MySQL-netwerkdeel wordt toegevoegd in de vervolgstap van de opdracht.
