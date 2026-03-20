# iac-ansible-2526-axel-weyers
IaC met Ansible – labo’s AJ 25- 26

## Requirements
Install Ansible Collections:
```bash 
ansible-galaxy collection install -r requirements.yml
```

## Run bootstrap
```bash
ansible-playbook playbooks/labo6_nginx_template_handler.yml
```
## Notes
Playbooks assume SSH key-based authentication

## Motivatie loop/when
### Waarom group_vars?
 De variabelen nginx_listen_port, nginx_server_name en nginx_variant staan in group_vars/web_blue.yml en group_vars/web_green.yml. Daardoor bepaalt de groepslidmaatschap van een host automatisch welke waarden de template ontvangt. Gemeenschappelijke zaken (zoals het playbook zelf en de template) blijven ongewijzigd  alleen de data varieert. Dit is het kernprincipe van data-gedreven configuratie: één template, meerdere uitkomsten.
### Waarom een handler voor de restart? 
De ansible.builtin.template-taak triggert via notify de handler Restart nginx alleen wanneer de taak changed rapporteert, dus enkel als de inhoud van /etc/nginx/conf.d/labo6.conf effectief verschilt van wat al op de host staat. Bij een tweede run zonder variabelewijziging is de template identiek, meldt Ansible ok en wordt de handler nooit uitgevoerd. Dit garandeert idempotentie: geen onnodige restarts.

