# Role: linux_baseline

## Doel
Zet een minimale, herbruikbare Linux baseline op voor Rocky en Debian hosts.

## Wat doet deze role?
- OS-update uitvoeren
- Common packages installeren (git, curl, rsync)
- Debian-specifiek: network-manager (nmtui)
- User `ops_admin` aanmaken met sudo-rechten en SSH public key
- User `emergency_admin` aanmaken als lokaal fallback account (wachtwoord via Vault)
- MOTD deployen

## Belangrijkste variabelen

| Variabele                        | Omschrijving                              | Standaard         |
|----------------------------------|-------------------------------------------|-------------------|
| `ops_admin_user`                 | Naam van de ops gebruiker                 | `ops_admin`       |
| `ops_admin_ssh_public_key`       | SSH public key voor ops_admin             | `""`              |
| `emergency_admin_user`           | Naam van het fallback account             | `emergency_admin` |
| `emergency_admin_password_hash`  | SHA512 hash, beheerd via Ansible Vault    | `"!"`             |
| `common_packages`                | Lijst van te installeren packages         | git, curl, rsync  |
| `debian_extra_packages`          | Extra packages voor Debian                | network-manager   |
| `motd_message`                   | Tekst voor /etc/motd                      | zie defaults      |

## Aannames
- **Rocky/RHEL**: sudo-groep is `wheel`
- **Debian**: sudo-groep is `sudo`
- `emergency_admin_password_hash` moet via Vault worden opgegeven (geen plaintext)
- `ops_admin_ssh_public_key` moet worden ingesteld in `group_vars/linux/vars.yml`
