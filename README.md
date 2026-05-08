# Labo 10 – Proxmox als private IaaS met dynamic inventory en day-2 operations

## Projectuitleg
Dit project provisioneert twee Rocky Linux VMs op Proxmox VE via de Proxmox API,
ontdekt ze dynamisch via de community.proxmox inventory plugin en voert
role-based day-2 configuratie uit op basis van tags en groepen.

## Inventory architectuur
- `inventories/lab/hosts.yml` – statisch, alleen localhost voor provisioning
- `inventories/lab/pve.proxmox.yml` – dynamic inventory via Proxmox plugin
- Groepen worden afgeleid uit Proxmox VM tags:
  - `managed_by_ansible` – alle door Ansible beheerde hosts
  - `rocky_hosts` – alle Rocky Linux hosts
  - `web_hosts` – rocky-web-01 (nginx)
  - `db_hosts` – rocky-db-01 (mariadb)

## Vereisten
- Ubuntu 24.04 control node
- Proxmox VE 9.x bereikbaar op `172.16.120.20:8006`
- Rocky GenericCloud template aanwezig als VMID 9000
- API user `ansible@pve` met token `ansible-token` aangemaakt in Proxmox
- Rollen toegewezen in Proxmox:
  - `AnsibleRole` op `/` voor `ansible@pve`
  - `PVESDNUser` op `/sdn/zones/localnetwork` voor `ansible@pve`
- SSH key aanwezig op control node: `~/.ssh/id_ed25519_iac_proxmox`
- SSH key geautoriseerd op Proxmox root: `ssh-copy-id -i ~/.ssh/id_ed25519_iac_proxmox root@172.16.120.20`

## Dependencies installeren
```bash
ansible-galaxy collection install -r requirements.yml
pip3 install --user --break-system-packages proxmoxer
sudo apt install -y python3-requests python3-netaddr
```

## Vault
Gevoelige waarden staan in versleutelde vault bestanden:
- `inventories/lab/group_vars/proxmox_api/vault.yml` – Proxmox API token secret
- `inventories/lab/group_vars/managed_by_ansible/vault.yml` – administrator wachtwoord

Vault password file aanmaken:
```bash
echo 'jouw-vault-wachtwoord' > ~/.vault_pass
chmod 600 ~/.vault_pass
```

Vault bestanden aanmaken:
```bash
ansible-vault create inventories/lab/group_vars/proxmox_api/vault.yml
# Inhoud: vault_proxmox_token_secret: "jouw-token-secret-uuid"

ansible-vault create inventories/lab/group_vars/managed_by_ansible/vault.yml
# Inhoud: vault_lab_administrator_password: "jouw-wachtwoord"
```

Token secret in pve.proxmox.yml versleutelen:
```bash
ansible-vault encrypt_string 'jouw-token-secret-uuid' --name 'token_secret'
# Plak output in inventories/lab/pve.proxmox.yml
```

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
