# RUNBOOK — Operations Guide

> Scope: Operating the **GCP Compute → External Security Pipelines** integration in production.

## 1) Health Checks (Daily)

- **Data freshness**: External SIEM shows host logs within SLO (e.g., ≤120s).
- **Volume drift**: Compare daily message count vs 7‑day baseline (±15%).
- **Error budget**: Ingest HTTP 4xx/5xx < 0.1%; agent retry queues < 5% capacity.
- **NAT egress**: SNAT utilization < 70%; no port exhaustion alerts.
- **Firewall**: No new denies toward allowed collector FQDNs.

## 2) On‑Call Runbook

1. **Alert: Missing Logs (single VM)**
   - Check VM CPU/mem; `systemctl status google-cloud-ops-agent`.
   - Confirm `/etc/google-cloud-ops-agent/config.yaml` checksum equals baseline.
   - Restart agent (`sudo systemctl restart google-cloud-ops-agent`).

2. **Alert: Pipeline 5xx from External Collector**
   - Verify TLS chain (root/intermediate) not expired.
   - Fail open? **No** — hold data locally (retry with backoff).
   - If extended outage > 30 min, switch to **Pub/Sub buffer** path per change record.

3. **Alert: NAT Port Exhaustion**
   - Drain canary VMs; roll out **connection pooling** and **keep‑alive** in agent config.
   - Scale NAT or shard egress across multiple NATs.

## 3) Standard Changes

- **Update allowlist**: PR against `scripts/bash/example-egress-allowlist.json` → change ticket → apply via `04_firewall_egress.sh`.
- **Rotate CA bundle**: Replace bundle on VMs, restart agents in waves.
- **Add workload**: Label VM, attach baseline Ops Agent config, enroll in dashboards.

## 4) Emergency Changes (Rollback, Cutover)

- Use `docs/ROLLBACK.md` and `docs/CUTOVER_CHECKLIST.md`.
- Preserve evidence: export `gcloud` command logs, attach to incident record.

## 5) Metrics & Observability

- **Lag (s)** from VM write → external ingest.
- **Delivery success %**, **HTTP 429/5xx rate**, **retries**.
- NAT **SNAT port usage**, **connections**, **errors**.
- Agent **CPU/mem**, **queue depth**.

## 6) Security Controls Summary

- Egress via **central NAT** only; deny direct Internet from subnets.
- Firewall rules **allowlist FQDNs** of collectors via managed lists.
- **mTLS** or token auth to external collector; rotate every 90 days.
- **Least privilege** service accounts; deny metadata API from untrusted processes.
- **Shielded VMs**, OS hardening baseline, CIS where applicable.

---

**Remember**: Never paste tenant IDs, IPs, or hostnames into tickets or PRs. Use redacted tokens (e.g., `collector.example`).
