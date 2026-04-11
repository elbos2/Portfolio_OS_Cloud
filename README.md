# Portfolio OS Cloud — cluster-95003

Portfolio voor de cursus Cloud Computing (Hanze HBO-ICT, jaar 3).

## Opdrachten

| Opdracht | Omschrijving | Status |
|----------|-------------|--------|
| [Opdracht 1](Portfolio_Opdracht1.md) | Beheer en uitrol van Proxmox cluster en webapplicaties | In uitvoering |
| [Opdracht 2](Portfolio_Opdracht2.md) | Wordt aangevuld | - |

## Infrastructuur

| Component | IP | Omschrijving |
|-----------|-----|-------------|
| pve-node1 | 10.24.40.2 | Proxmox node 1 |
| pve-node2 | 10.24.40.3 | Proxmox node 2 |
| pve-node3 | 10.24.40.4 | Proxmox node 3 |
| netdata-parent | 10.24.40.10 | Netdata monitoring (95003-LXC) |
| grafana | 10.24.40.11 | Grafana + Prometheus (VM 123) |
| wordpress-21 t/m 26 | 10.24.40.21-26 | WordPress VM's (Klant 2) |
| wordpress-lxc-1 t/m 3 | 10.24.40.31-33 | WordPress LXC's (Klant 1) |

## Automatisering

Alle configuratie is geautomatiseerd via Ansible playbooks in `scripts/ansible/` en bash scripts in `scripts/bash/`.

```bash
# Ansible uitvoeren vanaf pve-node1
ansible-playbook scripts/ansible/<playbook>.yml -i scripts/ansible/inventory.ini
```

## Monitoring

- **Netdata** — `http://10.24.40.10:19999`
- **Grafana** — `http://10.24.40.11:3000`
