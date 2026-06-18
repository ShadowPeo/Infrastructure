# Work/iac — Session Log

## Current Status
Active build-out of infrastructure playbook suite. Core provision/security/bootstrap playbooks solid. New this session: `motd.yml` (server stats MOTD + legal banner), `security.yml` (users+hardening re-apply), `crowdsec.yml` (hub/spoke CrowdSec - Docker LAPI on hub, native agent+bouncer on all hosts). Ansible KB created in KnowledgeBase vault. Harden temporarily commented out of provision.yml — needs reverting. Next immediate task: clone and provision SRV-MC (the central hub for CrowdSec LAPI, etc.).

---

## 2026-06-18 — Session 1

- Fixed Ubuntu 26.04 sudo-rs bootstrap issue (pre-bootstrap NOPASSWD step), documented in bootstrap.yml and KB
- Created `security.yml` playbook (users + harden, skips app stack)
- Created `motd` role and `motd.yml` playbook — dynamic server stats MOTD (physical/ZFS/NVIDIA fact-based detection), legal AUP banner via existing `banner` role; `motd.yml` added to `provision.yml`
- Added `motd_owner` override pattern (falls back to `client_name` then 'This System'); fixed `ansible_facts[]` deprecation warnings
- Created Ansible KB at `Knowledge Base/Applications/Ansible/` — Quick Reference + Playbook Variables docs
- Designed and built CrowdSec hub/spoke role: Docker LAPI (`Work/ansible/roles/crowdsec`), native agent+bouncer (`Work/iac/ansible/roles/crowdsec`); `crowdsec.yml` playbook
- Harden temporarily commented out of `provision.yml` for a re-run — **needs uncommenting**
- SRV-MC identified as hub host (172.16.10.30), not yet provisioned — next task

---
