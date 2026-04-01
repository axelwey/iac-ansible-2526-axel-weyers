# windows_baseline

## Doel

Beheert een minimale Windows Server baseline via Chocolatey: packages, features en config.

## Belangrijkste variabelen

| Variabele | Omschrijving | Locatie |
|---|---|---|
| `choco_packages` | Lijst van te installeren packages (name + state) | `defaults/main.yml` |
| `choco_features` | Lijst van Chocolatey features (name + state) | `defaults/main.yml` |
| `choco_config` | Lijst van Chocolatey config-waarden (name + value) | `defaults/main.yml` |

## Aannames en beperkingen

- Chocolatey wordt automatisch gebootstrapped door `win_chocolatey` als het nog niet aanwezig is.
- Windows Server 2025 heeft .NET Framework 4.8 standaard ingebouwd; een reboot is normaal niet nodig.
- De managed node is bereikbaar via SSH met key-based authenticatie als `administrator`.

## Gebruik

Deze role wordt aangeroepen vanuit `playbooks/labo08_windows_baseline.yml`.
Om packages aan te passen: wijzig `choco_packages` in `defaults/main.yml` of overschrijf in `host_vars/win2025.yml`.
