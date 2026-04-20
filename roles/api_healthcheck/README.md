# Role: api_healthcheck

## Doel
Leest twee publieke API-endpoints uit, bouwt een stabiel JSON health report,
slaat dit lokaal op als artifact, en synchroniseert het naar een GitHub Gist
— maar alleen als de inhoud effectief gewijzigd is.

## Belangrijkste variabelen

| Variabele | Omschrijving |
|---|---|
| `api_healthcheck.restcountries_url` | Endpoint voor REST Countries |
| `api_healthcheck.openlibrary_url` | Endpoint voor Open Library |
| `api_healthcheck.openlibrary_user_agent` | User-Agent header voor Open Library |
| `api_healthcheck.report_path` | Lokaal pad voor het JSON artifact |
| `api_healthcheck.github.gist_id` | ID van de bestaande GitHub Gist |
| `api_healthcheck.github.filename` | Bestandsnaam binnen de Gist |
| `api_healthcheck.github.description` | Beschrijving van de Gist |
| `vault_github_token` | GitHub Personal Access Token (Vault-protected) |

## Aannames en beperkingen
- Target is altijd `localhost` met `ansible_connection: local`
- De Gist moet al bestaan voor je de role runt
- `vault_github_token` moet beschikbaar zijn via Ansible Vault
- Het rapport bevat geen timestamps of random waarden (stabiel by design)

## Gebruik
```yaml
- hosts: api_targets
  roles:
    - api_healthcheck
```
