# CUTOVER CHECKLIST

- [ ] **Change record** approved, maintenance window scheduled.
- [ ] **Canaries** selected (≤10% fleet), dual‑write enabled.
- [ ] **Egress allowlist** applied and verified from canaries.
- [ ] **TLS**: CA bundle present; handshake validates against external collector.
- [ ] **Metrics** dashboards published (lag, error rate, SNAT usage).
- [ ] **Runbook** reviewed by on‑call engineer.
- [ ] **Backout plan** tested on canary.
- [ ] **Stakeholders** notified (SOC, platform, security engineering).
