# Portfolio Opdracht 2

## Inhoudsopgave

### Opdracht 1 - Docker basis en Swarm
1. [Voorbereiding](#1-voorbereiding)
2. [Les 4 - Docker installatie en basiscontrole](#2-les-4---docker-installatie-en-basiscontrole)
3. [Les 7 - Dockerfile, image build en container](#3-les-7---dockerfile-image-build-en-container)
4. [Les 8 - Docker Compose stack](#4-les-8---docker-compose-stack)
5. [Les 9 - Docker Swarm](#5-les-9---docker-swarm)
6. [Extra - Geautomatiseerd uitvoeren via Ansible](#6-extra---geautomatiseerd-uitvoeren-via-ansible)
7. [Basic Docker Networking](#7-basic-docker-networking)

### Opdracht 2 - MySQL containers in aparte subnetten
8. [MySQL containers in aparte subnetten](#8-mysql-containers-in-aparte-subnetten)

---

## Opdracht 1 - Docker basis en Swarm

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
- `scripts/ansible/inventory.ini`
- `scripts/ansible/docker_swarm_setup.yml`

Playbook resultaat:
- mgr1 als leader
- mgr2 en mgr3 als reachable managers
- validatie via docker node ls in de playbook-output

---

## 7. Basic Docker Networking

### Doel

De basis Docker-netwerkcommando's uitvoeren via een script dat de commando's één voor één doorloopt.

### Uitvoering

- Script aangemaakt: `scripts/bash/docker_networking.sh`
- Bridge-netwerk aangemaakt en geïnspecteerd.
- Twee containers gestart op hetzelfde netwerk.
- Verbinding tussen containers getest met ping.
- Netwerk en containers opgeruimd.

### Bewijs

![Networking script uitvoer deel 1](docs/screenshots/14m_Opdracht2_RunNetworkingCommands.png)

![Networking script uitvoer deel 2](docs/screenshots/14n_Opdracht2_RunNetworkingCommands.png)

---

## Opdracht 2 - MySQL containers in aparte subnetten

---

## 8. MySQL containers in aparte subnetten

### Doel

Twee MySQL containers opstarten in aparte Docker-subnetten, de bereikbaarheid testen vanuit het Proxmox-subnet en tussen de containers onderling, en eventueel de connectiviteit herstellen.

### Docker subnetten uitgelegd

Docker maakt standaard één bridge-netwerk aan waarop alle containers met elkaar kunnen communiceren. Door containers in **aparte subnetten** te plaatsen, isoleer je ze van elkaar — ze kunnen dan niet meer zomaar onderling communiceren.

Dit is nuttig voor:
- **Beveiliging**: een database-container is niet bereikbaar vanuit een frontend-container tenzij je dat expliciet toestaat
- **Multi-tenant omgevingen**: meerdere klanten of applicaties delen dezelfde host maar zijn netwerktechnisch gescheiden
- **Microservices**: elke service heeft zijn eigen netwerksegment, waardoor blast radius bij een incident beperkt blijft

### Opzet

Twee MySQL containers in aparte subnetten via Docker Compose, beide op **docker-mgr-1 (10.24.40.22)**:

| Container | Subnet           | IP             | Gepubliceerde poort |
|-----------|------------------|----------------|---------------------|
| mysql1    | 192.168.100.0/24 | 192.168.100.10 | 3306                |
| mysql2    | 192.168.101.0/24 | 192.168.101.10 | 3307                |

Gebruikte bestanden:
- `scripts/docker/mysql-subnets/docker-compose.yml`
- `scripts/ansible/reset_and_deploy_mysql.yml`

### Waarom één VM en niet drie?

Initieel is geprobeerd het playbook op alle drie Docker-managers (mgr1, mgr2, mgr3) uit te rollen. Dit leverde twee problemen op:

1. **Geen zinvolle netwerkseparatie** — als elke VM zijn eigen mysql1 en mysql2 krijgt, test je de isolatie drie keer op zichzelf. Containers op verschillende VM's communiceren sowieso via het host-netwerk (10.24.40.x), dus Docker bridge isolation is dan irrelevant.

2. **Complexe iptables-conflicten** — het playbook stopte Docker, manipuleerde iptables-chains handmatig en herstartte Docker. Dit veroorzaakte conflicten met de bestaande iptables-regels op de VM's en brak op een gegeven moment de SSH-verbinding naar de hosts.

De correcte aanpak voor Docker subnet-isolatie is: **beide containers op dezelfde host**, elk in een eigen Docker bridge network. De isolatie zit in de Docker lagen, niet in de VM-laag.

### Technische uitdagingen tijdens het opzetten

Het werkend krijgen van de container-naar-container communicatie heeft aanzienlijk meer tijd gekost dan verwacht, door een combinatie van problemen die specifiek zijn voor Ubuntu 22.04 met Docker:

**1. Onvoldoende VM-geheugen**
De VM had initieel 1024 MB RAM. Het gelijktijdig initialiseren van twee MySQL 8.0 containers (elk ~400 MB tijdens opstarten) zorgde dat de VM volledig vastliep en SSH-verbindingen verbraken. Opgelost door de VM te upgraden naar 2048 MB en geheugenlimieten toe te voegen aan de docker-compose (`mem_limit: 400m`, `--innodb-buffer-pool-size=128M`).

**2. Ophoping van stale Docker bridge interfaces**
Na herhaalde `docker compose down/up` cycli bleven oude bridge interfaces achter met dezelfde IP-adressen (192.168.100.1 en 192.168.101.1) maar in `DOWN` staat. De host stuurde ARP-requests op de neergehaalde bridge in plaats van de actieve, waardoor containers onbereikbaar werden — ook voor ping. Opgelost door stale bridges handmatig te verwijderen met `ip link delete`.

**3. bridge-nf-call-iptables blokkeerde intra-bridge verkeer**
Na het verwijderen van de stale bridges waren containers wel pingbaar, maar TCP-verbindingen tussen containers bleven time-outen (error 110). De oorzaak: `net.bridge.bridge-nf-call-iptables=1` stuurde gebridged container-verkeer door de iptables FORWARD-chain, die standaard `policy DROP` heeft. Docker's ACCEPT-regels in de DOCKER-FORWARD chain werden niet correct toegepast voor intra-bridge verkeer. Opgelost door de sysctl op 0 te zetten:

```bash
sudo sh -c 'echo 0 > /proc/sys/net/bridge/bridge-nf-call-iptables'
```

Dit vertelt de kernel dat gebridged L2-verkeer iptables omzeilt. Docker's netwerkseparatie tussen *verschillende* subnetten blijft intact via routing-niveau isolatie.

### Uitvoering

De uiteindelijke werkende stappen op docker-mgr-1:

```bash
# 1. Clean start
cd ~/mysql-subnets
docker compose down
docker compose up -d

# 2. Test VOOR fix — containers zitten in aparte subnetten
docker exec mysql1 mysqladmin -h 192.168.101.10 -u root -psecret --connect-timeout=3 ping
# → Can't connect (aparte subnetten, geen route)

# 3. Fix toepassen
docker network connect mysql-subnets_subnet-b mysql1
sudo sh -c 'echo 0 > /proc/sys/net/bridge/bridge-nf-call-iptables'

# 4. Test NA fix
docker exec mysql1 mysqladmin -h 192.168.101.10 -u root -psecret --connect-timeout=5 ping
# → mysqld is alive
docker exec mysql2 mysqladmin -h mysql1 -u root -psecret --connect-timeout=5 ping
# → mysqld is alive
```

**Resultaten:**

| Test | Resultaat |
|------|-----------|
| mysql1 vanuit host (poort 3306) | bereikbaar |
| mysql2 vanuit host (poort 3307) | bereikbaar |
| mysql1 → mysql2 vóór fix | niet bereikbaar (aparte subnetten) |
| mysql1 → mysql2 na fix | **mysqld is alive** |
| mysql2 → mysql1 na fix | **mysqld is alive** |

### Bewijs

**Ansible playbook — connectiviteit na fix nog niet bereikbaar (voor sysctl fix):**

![Ansible playbook failed connectivity](docs/screenshots/14o_Opdracht2_FailedSQLSubnet.png)

**Handmatige uitvoering — succesvolle connectiviteitstest voor en na fix:**

![Handmatige succesvolle test](docs/screenshots/14p_Opdracht2_SQLSubnetManuallySuccess.png)
