# iac-ansible-2526-axel-weyers
IaC met Ansible – labo’s AJ 25- 26

## Requirements
Install Ansible Collections:
```bash 
ansible-galaxy collection install -r requirements.yml
```
## Connectivity Test
```bash
ansible linux -m ansible.builtin.ping
```
## Run labo 2 bootstrap
```bash
ansible-playbook playbook/labo02_bootstrap_rocky.yml
```


