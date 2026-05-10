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



# Labo 11 – Cisco Network Automation en Event-Driven Remediation

## Projectuitleg

Dit project automatiseert de configuratie van een Cisco layer 2 switch via Ansible. De workflow omvat het uitlezen van de actuele toestand, het maken van een backup, het toepassen van één gewenste configuratiewijziging, het uitvoeren van een verify en het automatisch herstellen van drift via Event-Driven Ansible.

---

## Labotopologie

```
Ubuntu control node (172.16.120.10)
    └── vmnet8
        └── CML (172.16.120.30)
            └── bridge0
                └── unmanaged-switch-0
                    └── iol-l2-0 / sw1 (172.16.120.31)
```

---

## Scope

| Parameter | Waarde |
|---|---|
| Inventorynaam switch | `sw1` |
| Switch IP | `172.16.120.31` |
| Beheerde interface | `Ethernet0/1` |
| Gewenste description | `Managed by Ansible - Labo11` |
| Drift description | `MANUAL DRIFT - NOT COMPLIANT` |
| Webhook poort | `5000` |
| Webhook endpoint | `http://localhost:5000/endpoint` |

---

## Vereisten op de control node

### Systeem dependencies

```bash
sudo apt install -y openjdk-17-jdk curl jq
```

### Python dependencies

```bash
pip install paramiko ansible-rulebook ansible-runner --break-system-packages
```

### PATH instellen (eenmalig)

```bash
echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
source ~/.bashrc
```

### Collections installeren

```bash
ansible-galaxy collection install -r requirements.yml
```

### Verifieer installatie

```bash
ansible-galaxy collection list | grep -E "cisco|netcommon|eda"
python3 -c "import paramiko; print(paramiko.__version__)"
ansible-rulebook --version
java -version
```

---

## Vault configuratie

Het enable password van de switch wordt beheerd via Ansible Vault.

### Vault password file aanmaken (eenmalig, buiten de repo)

```bash
nano ~/.vault_pass
chmod 600 ~/.vault_pass
```

De `ansible.cfg` verwijst automatisch naar deze file via:
```
vault_password_file = ~/.vault_pass
```

### Environment variables voor EDA

Voor EDA-runs moeten deze variables gezet worden:

```bash
export ANSIBLE_VAULT_PASSWORD_FILE=~/.vault_pass
export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
```

### Controleer de vault setup

```bash
echo "$ANSIBLE_VAULT_PASSWORD_FILE"
echo "$ANSIBLE_CONFIG"
test -r "$ANSIBLE_VAULT_PASSWORD_FILE" && echo "vault file readable"
```

### Vault secret aanmaken

```bash
ansible-vault encrypt_string 'jouw-enable-password' --name 'ansible_become_password'
```

Plak de output in `inventories/lab/group_vars/cisco_switches/vault.yml`.

---

## SSH key-based login controleren

```bash
ssh -i ~/.ssh/labo11_cisco ansible@172.16.120.31
```

Dit moet inloggen zonder wachtwoordprompt. De private key staat op de control node onder `~/.ssh/labo11_cisco`. De public key staat op de switch.

---

## Read-only test uitvoeren

```bash
ansible-playbook playbooks/labo11_readonly_test.yml
```

Verwacht resultaat: `ok=2 changed=0` — de taak rapporteert geen `changed`.

---

## Baseline playbook uitvoeren

### Run 1

```bash
ansible-playbook playbooks/labo11_network_baseline.yml
```

Verwacht resultaat: de config-taak toont `changed` als de description nog niet correct is. De backup wordt aangemaakt onder `artifacts/network_backups/sw1/running-config-before-baseline.txt`.

### Run 2

```bash
ansible-playbook playbooks/labo11_network_baseline.yml
```

Verwacht resultaat: de config-taak toont `skipped` — geen onnodige wijziging.

**Opmerking:** het backup-artifact kan bij elke run wijzigen omdat de running-config opnieuw opgehaald wordt. Dit is normaal gedrag.

---

## Verify uitvoeren

```bash
ansible-playbook playbooks/labo11_verify_network.yml
```

Verwacht resultaat bij correcte state: `VERIFY OK: Ethernet0/1 heeft de gewenste description.`

Verwacht resultaat na drift:
```
VERIFY FAILED - Ethernet0/1 is niet compliant.
Expected: Managed by Ansible - Labo11
Current: MANUAL DRIFT - NOT COMPLIANT
```

---

## Drift simuleren

Voer op de switch console uit:

```
conf t
interface Ethernet0/1
description MANUAL DRIFT - NOT COMPLIANT
end
write memory
```

Voer daarna opnieuw de verify uit:

```bash
ansible-playbook playbooks/labo11_verify_network.yml
```

De verify moet falen met een duidelijke foutmelding.

---

## Rulebook starten

Stel de environment variables in en start het rulebook:

```bash
cd ~/iac-ansible-2526-axel-weyers
export ANSIBLE_VAULT_PASSWORD_FILE=~/.vault_pass
export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
ansible-rulebook --rulebook rulebooks/labo11_network_self_heal.yml \
  -i inventories/lab/hosts.yml --verbose
```

Het rulebook luistert op `0.0.0.0:5000` en matcht uitsluitend op:
- `problem == interface_description_drift`
- `device == sw1`

---

## Testevent sturen

Open een tweede terminal en stuur:

```bash
curl -X POST http://localhost:5000/endpoint \
  -H "Content-Type: application/json" \
  -d '{
    "device": "sw1",
    "problem": "interface_description_drift",
    "interface": "Ethernet0/1",
    "expected_description": "Managed by Ansible - Labo11"
  }'
```

Verwacht: `endpoint` als response. In terminal 1 verschijnt de remediation output.

---

## Artifacts

### Backup-artifacts

```
artifacts/network_backups/sw1/running-config-before-baseline.txt
```

Deze file wordt aangemaakt bij elke run van de baseline playbook en bevat de running-config van vóór de wijziging.

### Remediation-logs

```
artifacts/remediation/remediation-sw1-<timestamp>.log
```

Elke remediation schrijft een logbestand met de volgende inhoud:
- `device`
- `interface`
- `expected_description`
- `changed`
- `verified`
- `before`
- `after`
- `timestamp`

---

## Run 1 vs Run 2 interpreteren

| | Run 1 | Run 2 |
|---|---|---|
| Backup-artifact | `changed` (nieuw aangemaakt of bijgewerkt) | `ok` (ongewijzigd) |
| Config-taak | `changed` (description toegepast) | `skipped` (al correct) |
| Verify | `ok` | `ok` |
