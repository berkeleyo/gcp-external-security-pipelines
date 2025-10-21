# ROLLBACK

**Trigger conditions** (examples):
- Error rate > 2% over 15 minutes.
- Data lag > 5 minutes sustained.
- Security control failure (TLS/mTLS validation issues).

**Actions**:
1. Disable new routes to external collector (revert firewall allowlist).
2. Re‑enable prior logging path (e.g., internal sink) if applicable.
3. Drain agent queues; confirm durable local retry succeeds.
4. Post‑incident review; root cause and preventative actions.
