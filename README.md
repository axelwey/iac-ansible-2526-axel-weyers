# iac-ansible-2526-axel-weyers

Ansible-projectrepo voor Infrastructure as Code — AP Hogeschool Antwerpen 2025-2026.

## Labo 09 API Healthcheck Workflow

### Projectuitleg
Een idempotente Ansible-role die twee publieke APIs uitleest, een stabiel JSON
health report opbouwt, dit lokaal opslaat als artifact, en conditioneel een
GitHub Gist bijwerkt.

### Gebruikte inventory group
`api_targets`  bevat `localhost` met `ansible_connection: local`

### Dependencies installeren
```bash
ansible-galaxy collection install -r requirements.yml
```

### Vault
De GitHub token is opgeslagen in een Vault-versleuteld bestand:
`inventories/lab/group_vars/api_targets/vault.yml`

Het vault-wachtwoord staat in `.vault_pass` (niet in Git).

Vault-bestand bekijken/bewerken:
```bash
ansible-vault view inventories/lab/group_vars/api_targets/vault.yml
ansible-vault edit inventories/lab/group_vars/api_targets/vault.yml
```

### Playbook runnen
```bash
ansible-playbook playbooks/labo09_api_healthcheck.yml
```

### Verwacht gedrag
**Run 1:** De role leest beide APIs uit, bouwt het rapport, schrijft het lokaal
weg, en updatet de Gist (changed).

**Run 2 (zonder wijzigingen):** Alle taken zijn `ok`, de Gist-update wordt
overgeslagen omdat de inhoud identiek is (geen changed op de PATCH-taak).

**Na een gerichte wijziging** (bv. andere `openlibrary_url`): alleen de
relevante taak toont `changed`.

### Variabelen aanpassen
Alle configuratie staat in:
`inventories/lab/group_vars/api_targets/vars.yml`

## Persoonsgebonden configuratie

De Gist ID in `inventories/lab/group_vars/api_targets/vars.yml` is persoonsgebonden.
Pas `github.gist_id` aan naar de ID van jouw eigen GitHub Gist.

De bijhorende GitHub Personal Access Token (met `gist` scope) sla je op via:

```bash
ansible-vault edit inventories/lab/group_vars/api_targets/vault.yml
```

Zet daar:

```yaml
vault_github_token: "jouw_token"
```
