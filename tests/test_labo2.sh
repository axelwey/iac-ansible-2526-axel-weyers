#!/usr/bin/env bash
set -euo pipefail

echo "== [1/7] Sanity: where am I?"
pwd
test -f ansible.cfg
test -f inventories/lab/hosts.yml
test -f requirements.yml
test -f playbooks/labo02_bootstrap_rocky.yml

echo "== [2/7] Install required collections"
ansible-galaxy collection install -r requirements.yml

echo "== [3/7] Show inventory (must include linux + rocky)"
ansible-inventory --list

echo "== [4/7] Connectivity test (Ansible ping)"
ansible linux -m ansible.builtin.ping

echo "== [5/7] Syntax check playbook"
ansible-playbook playbooks/labo02_bootstrap_rocky.yml --syntax-check

echo "== [6/7] Run 1 (should show changes)"
ansible-playbook playbooks/labo02_bootstrap_rocky.yml

echo "== [7/7] Run 2 (should be idempotent / mostly ok)"
ansible-playbook playbooks/labo02_bootstrap_rocky.yml

echo "== DONE: If run 2 shows no unexpected changes, Labo 2 baseline is OK."
