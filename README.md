# Infrastructure as Code – Labo 07

## Beschrijving
Mini Linux role library voor Rocky en Debian via Ansible roles + Vault.

## Inventory groups

| Groep       | Hosts           | Doel                          |
|-------------|-----------------|-------------------------------|
| `linux`     | rocky1, debian1 | Alle managed Linux hosts      |
| `web_blue`  | rocky1          | nginx variant: poort 8080     |
| `web_green` | debian1         | nginx variant: poort 8081     |

## Rollen
- `linux_baseline` – OS update, packages, users, MOTD
- `nginx` – installatie + vhost config via template
- `ssh_hardening` – SSH hardening via lineinfile + validatie

## Dependencies installeren
```bash
ansible-galaxy collection install -r requirements.yml
```

## Vault setup
```bash
echo "JouwVaultWachtwoord" > .vault_pass
# .vault_pass staat in .gitignore en wordt NOOIT gecommit
```

## Playbook uitvoeren
```bash
# Eerste run (maakt alles aan)
ansible-playbook playbooks/labo07_roles_vault.yml

# Tweede run (toont idempotentie)
ansible-playbook playbooks/labo07_roles_vault.yml

# Met expliciete vault password vraag (zonder .vault_pass file)
ansible-playbook playbooks/labo07_roles_vault.yml --ask-vault-pass
```

## Variabelen aanpassen
- nginx varianten: `group_vars/web_blue/vars.yml` en `group_vars/web_green/vars.yml`
- ops_admin SSH key: `group_vars/linux/vars.yml` → `ops_admin_ssh_public_key`
- emergency_admin hash: `group_vars/linux/vars.yml` → `emergency_admin_password_hash` (vault)
- become passwords: `host_vars/rocky1/vars.yml` en `host_vars/debian1/vars.yml` (vault)

## Verwacht gedrag
- **Run 1**: wijzigingen op beide hosts (packages, users, nginx config, SSH hardening)
- **Run 2**: geen of minimale changes (enkel als OS updates beschikbaar zijn)
- **Gerichte wijziging**: verander `nginx_listen_port` in web_blue/vars.yml → enkel nginx handler op rocky1 triggert
