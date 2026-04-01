# iac-ansible-2526-axel-weyers

## Labo 08 — Windows baseline met Ansible, SSH en Chocolatey

### Projectstructuur

- `inventories/lab/hosts.yml` — inventory met host `win2025` in groep `windows`
- `host_vars/win2025.yml` — transportconfiguratie en verbindingsgegevens voor win2025
- `playbooks/labo08_windows_baseline.yml` — thin playbook
- `roles/windows_baseline/` — role met packages, features en config

### Transport

SSH met key-based authenticatie. De publieke sleutel van de control node staat in
`C:\ProgramData\ssh\administrators_authorized_keys` op de Windows Server.
De DefaultShell van de Windows OpenSSH-server is ingesteld op `cmd.exe`,
wat overeenkomt met `ansible_shell_type: cmd` in de inventory.

### Vault

Voor dit labo is geen Vault nodig: SSH key-based authenticatie vereist geen wachtwoord.
Er staan geen plaintext secrets in de repo.

### Dependencies installeren
```bash
ansible-galaxy collection install -r requirements.yml
```

### Playbook uitvoeren
```bash
ansible-playbook playbooks/labo08_windows_baseline.yml --ask-vault-pass
```

(geen vault in dit labo, dus ook zonder `--ask-vault-pass`:)
```bash
ansible-playbook playbooks/labo08_windows_baseline.yml
```

### Verwacht gedrag

**Run 1:** Chocolatey wordt gebootstrapped, 7 packages worden geïnstalleerd, 2 features en 1 config-waarde worden ingesteld. Alle tasks tonen `changed`.

**Run 2:** Niets is gewijzigd. Alle tasks tonen `ok`, geen `changed`.

### Packages/features/config aanpassen

- Packages: `roles/windows_baseline/defaults/main.yml` → `choco_packages`
- Features: `roles/windows_baseline/defaults/main.yml` → `choco_features`
- Config: `roles/windows_baseline/defaults/main.yml` → `choco_config`
- Hostspecifieke overrides: `host_vars/win2025.yml`
