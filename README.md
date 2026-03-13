# iac-ansible-2526-axel-weyers
IaC met Ansible – labo’s AJ 25- 26

## Requirements
Install Ansible Collections:
```bash 
ansible-galaxy collection install -r requirements.yml
```

## Run bootstrap
```bash
ansible-playbook playbook/labo5_baseline_v2.yml
```
## Notes
Playbooks assume SSH key-based authentication

## Motivatie loop/when
**loop** wordt gebruikt voor packages, users en sercices omdat de data in lijsten staat (list-of-dicts in `group_vars`). één generieke taks loopt over de volledige lijst.
**when** wordt enkel gebruikt waar het functioneel noodzakelijk is: om items te filteren op `os_family` of `group`. Zonder `when` zou elk item op elke host worden uitgevoerd, wat fout is. De conditionals staan in de data. 

