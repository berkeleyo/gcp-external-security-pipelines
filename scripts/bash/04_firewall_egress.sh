#!/usr/bin/env bash
set -euo pipefail
# 04_firewall_egress.sh — apply minimal egress allowlist for external collector endpoints.
# NOTE: Replace network/subnet names and project as needed; use FQDN lists when available.

PROJECT_ID="${PROJECT_ID:-<your-project-id>}"
NETWORK="${NETWORK:-default}"
RULE_NAME="${RULE_NAME:-allow-egress-security-collector}"
ALLOWED_JSON="${ALLOWED_JSON:-scripts/bash/example-egress-allowlist.json}"

gcloud config set project "${PROJECT_ID}"

CIDR_LIST=$(jq -r '.destinations[]' "${ALLOWED_JSON}")
PORTS=$(jq -r '.ports | join(",")' "${ALLOWED_JSON}")

# Create or update egress rule
gcloud compute firewall-rules describe "${RULE_NAME}" --project "${PROJECT_ID}" >/dev/null 2>&1 || CREATE=1

if [[ "${CREATE:-0}" == "1" ]]; then
  gcloud compute firewall-rules create "${RULE_NAME}"     --project "${PROJECT_ID}"     --network "${NETWORK}"     --direction EGRESS     --action ALLOW     --rules "tcp:${PORTS}"     --destination-ranges $(echo "${CIDR_LIST}" | tr '
' ',' | sed 's/,$//')     --priority 1000
else
  gcloud compute firewall-rules update "${RULE_NAME}"     --project "${PROJECT_ID}"     --rules "tcp:${PORTS}"     --destination-ranges $(echo "${CIDR_LIST}" | tr '
' ',' | sed 's/,$//')
fi

echo "✅ Egress rule ${RULE_NAME} applied."
