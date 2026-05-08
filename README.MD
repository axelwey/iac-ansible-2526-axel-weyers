# Labo 10 – Proxmox als private IaaS met dynamic inventory en day-2 operations

## Projectuitleg
Dit project provisioneert twee Rocky Linux VMs op Proxmox VE via de Proxmox API,
ontdekt ze dynamisch via de community.proxmox inventory plugin en voert
role-based day-2 configuratie uit op basis van tags en groepen.

## Inventory architectuur
- `inventories/lab/hosts.yml` – statisch, alleen localhost voor provisioning
- `inventories/lab/pve.proxmox.yml` – dynamic inventory via Proxmox plugin
- Groepen worden afgeleid uit Proxmox VM tags

## Dependencies installeren
```bash
ansible-galaxy collection install -r requirements.yml
pip3 install --user --break-system-packages proxmoxer
sudo apt install -y python3-requests python3-netaddr
```

## Vault
Gevoelige waarden staan in versleutelde vault bestanden:
- `inventories/lab/group_vars/proxmox_api/vault.yml`
- `inventories/lab/group_vars/managed_by_ansible/vault.yml`

Vault password file: `~/.vault_pass` (niet in git)

## Provisioning
```bash
ansible-playbook playbooks/labo10_proxmox_provision.yml
```

## Inventory controleren
```bash
ansible-inventory --graph
ansible-inventory --host rocky-web-01
```

## Connectiviteit testen
```bash
ansible web_hosts -m ansible.builtin.ping
ansible db_hosts -m ansible.builtin.ping
```

## Day-2
```bash
ansible-playbook playbooks/labo10_day2.yml
```

## Verwachte output
- Run 1: changed tasks voor installatie van packages en services
- Run 2: geen changes, alleen ok
