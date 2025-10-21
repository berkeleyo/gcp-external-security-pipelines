# SECURITY

- **No secrets** in repo. Use WIF or Secret Manager.
- Enforce **least privilege** on service accounts.
- **Egress controls**: central NAT, firewall allowlist by FQDN/IP ranges.
- **Transport**: TLS 1.2+ with pinned CA bundle; prefer **mTLS** for collector.
- **Host hardening**: Shielded VMs, OS baseline (CIS), disable unused services.
- **Monitoring**: Alert on ingest failures, TLS errors, SNAT exhaustion, config drift.
