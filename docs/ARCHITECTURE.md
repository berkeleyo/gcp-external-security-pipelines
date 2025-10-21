# ARCHITECTURE

## Components (GCP)
- **GCE VMs** with **Ops Agent / Fluent Bit** for host‑level telemetry.
- **Service Accounts** for least‑privileged access to Pub/Sub (if used).
- **VPC + NAT** for controlled egress; **Firewall** to restrict destinations.
- **Pub/Sub** (optional) as a buffer/bus; **Dataflow** (optional) for transform/enrich.
- **Private Service Connect (egress)** when supported by the external provider.

## External
- **Collector/Bridge** (HTTPS/syslog/TCP) with **mTLS/token** auth.
- **Security Data Lake** and **SIEM/SOAR** for analytics and response.

## Data Paths
1. **Agent → External Collector** (direct over TLS 1.2+).  
2. **Logs → Pub/Sub → Bridge → External** (buffered and transformable).

## High‑Level Decisions
- Prefer **mTLS** over token auth where possible.
- Deny all egress by default; maintain a minimal **allowlist**.
- Use **canary VMs** and **dual‑write** during cutover.
