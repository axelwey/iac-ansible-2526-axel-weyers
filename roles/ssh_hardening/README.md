# Role: ssh_hardening

## Doel
Past minimale SSH-hardening toe zonder de volledige sshd_config te overschrijven.

## Wat doet deze role?
- Schakelt direct root login uit (PermitRootLogin no)
- Schakelt wachtwoordauthenticatie uit (PasswordAuthentication no)
- Zorgt dat key-based login actief blijft (PubkeyAuthentication yes)
- Valideert de config vóór elke schrijfoperatie (sshd -t)
- Herstart SSH enkel bij effectieve wijziging (handler)

## Belangrijkste variabelen

| Variabele                    | Omschrijving                     | Standaard |
|------------------------------|----------------------------------|-----------|
| `ssh_permit_root_login`      | Waarde voor PermitRootLogin      | `no`      |
| `ssh_password_authentication`| Waarde voor PasswordAuthentication| `no`     |
| `ssh_pubkey_authentication`  | Waarde voor PubkeyAuthentication | `yes`     |

## Aannames
- SSH public keys zijn al geconfigureerd vóór deze role draait (anders sluit je jezelf buiten)
- linux_baseline role heeft ops_admin met SSH key aangemaakt
- Rocky: service heet `sshd` | Debian: service heet `ssh`

## Volgorde
Draai altijd **linux_baseline vóór ssh_hardening** zodat ops_admin SSH key al aanwezig is.
