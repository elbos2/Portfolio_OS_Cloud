#!/bin/bash
# Test MySQL subnet connectiviteit

COMPOSE_DIR="$(dirname "$0")/../docker/mysql-subnets"

echo "=== 1. Containers starten ==="
docker compose -f "$COMPOSE_DIR/docker-compose.yml" up -d

echo ""
echo "=== 2. Wachten tot MySQL klaar is ==="
sleep 15

echo ""
echo "=== 3. Netwerken tonen ==="
docker network ls | grep -E "subnet-a|subnet-b"

echo ""
echo "=== 4. IP-adressen van containers ==="
docker inspect mysql1 --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
docker inspect mysql2 --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'

echo ""
echo "=== 5. Bereikbaarheid vanuit host (Proxmox subnet) ==="
echo "--- mysql1 via poort 3306 ---"
nc -zv 127.0.0.1 3306 && echo "mysql1: BEREIKBAAR" || echo "mysql1: NIET BEREIKBAAR"

echo "--- mysql2 via poort 3307 ---"
nc -zv 127.0.0.1 3307 && echo "mysql2: BEREIKBAAR" || echo "mysql2: NIET BEREIKBAAR"

echo ""
echo "=== 6. Containers bereiken elkaar? (verwacht: NIET) ==="
docker exec mysql1 bash -c "apt-get install -y iputils-ping -qq && ping -c 2 172.21.0.10" \
  && echo "mysql1 -> mysql2: BEREIKBAAR" \
  || echo "mysql1 -> mysql2: NIET BEREIKBAAR (aparte subnetten)"

echo ""
echo "=== 7. Fix: mysql1 toevoegen aan subnet-b ==="
docker network connect mysql-subnets_subnet-b mysql1

echo ""
echo "=== 8. Opnieuw testen na fix ==="
docker exec mysql1 bash -c "ping -c 2 172.21.0.10" \
  && echo "mysql1 -> mysql2: BEREIKBAAR" \
  || echo "mysql1 -> mysql2: NOG STEEDS NIET BEREIKBAAR"

echo ""
echo "=== 9. Netwerk inspecteren ==="
docker network inspect mysql-subnets_subnet-a --format '{{range .Containers}}{{.Name}}: {{.IPv4Address}}{{"\n"}}{{end}}'
docker network inspect mysql-subnets_subnet-b --format '{{range .Containers}}{{.Name}}: {{.IPv4Address}}{{"\n"}}{{end}}'

echo ""
echo "=== 10. Opruimen ==="
docker compose -f "$COMPOSE_DIR/docker-compose.yml" down

echo ""
echo "=== Klaar ==="
