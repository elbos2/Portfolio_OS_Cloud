#!/bin/bash
# Basic Docker Networking - commando's één voor één

echo "=== 1. Beschikbare netwerken tonen ==="
docker network ls

echo ""
echo "=== 2. Nieuw bridge-netwerk aanmaken ==="
docker network create --driver bridge mijn-netwerk

echo ""
echo "=== 3. Netwerken tonen (nieuw netwerk zichtbaar) ==="
docker network ls

echo ""
echo "=== 4. Netwerk inspecteren ==="
docker network inspect mijn-netwerk

echo ""
echo "=== 5. Container starten op het nieuwe netwerk ==="
docker run -d --name container1 --network mijn-netwerk nginx

echo ""
echo "=== 6. Tweede container starten op hetzelfde netwerk ==="
docker run -d --name container2 --network mijn-netwerk nginx

echo ""
echo "=== 7. Verbinding testen tussen containers ==="
docker exec container1 ping -c 3 container2

echo ""
echo "=== 8. Netwerk inspecteren (containers zichtbaar) ==="
docker network inspect mijn-netwerk

echo ""
echo "=== 9. Containers stoppen en verwijderen ==="
docker stop container1 container2
docker rm container1 container2

echo ""
echo "=== 10. Netwerk verwijderen ==="
docker network rm mijn-netwerk

echo ""
echo "=== Klaar ==="
docker network ls
