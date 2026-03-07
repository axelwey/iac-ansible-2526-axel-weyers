# iac-ansible-2526-axel-weyers
IaC met Ansible – labo’s AJ 25- 26

## Requirements
Install Ansible Collections:
```bash 
ansible-galaxy collection install -r requirements.yml
```

## Secrets herstellen
Maak een map secrets/ aan en voeg de volgende bestanden toe:

secrets/become.pass (sudo wachtwoord)
secrets/appdb.pass (database wachtwoord)

## Connectivity Test
```bash
ansible linux -m ansible.builtin.ping
```
## Run bootstrap
```bash
ansible-playbook playbook/w04_service_host_baseline.yml
```
## Notes
Playbooks assume SSH key-based authentication


