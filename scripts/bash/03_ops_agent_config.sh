#!/usr/bin/env bash
set -euo pipefail
# 03_ops_agent_config.sh — push Ops Agent logging config to a VM via SSH.
# Requires OS Login/IAP or your preferred method. Replace placeholders.

VM="${VM:-<vm-name>}"
ZONE="${ZONE:-<zone>}"
CONFIG_FILE="${CONFIG_FILE:-scripts/bash/sample_ops_agent_logging.yaml}"

echo "Uploading ${CONFIG_FILE} to ${VM} (${ZONE})..."
gcloud compute scp "${CONFIG_FILE}" "${VM}":/tmp/config.yaml --zone "${ZONE}"

echo "Installing/Restarting Ops Agent..."
gcloud compute ssh "${VM}" --zone "${ZONE}" --command "sudo su -c '
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
bash add-google-cloud-ops-agent-repo.sh --also-install
mv /tmp/config.yaml /etc/google-cloud-ops-agent/config.yaml
systemctl restart google-cloud-ops-agent
systemctl status google-cloud-ops-agent --no-pager
'"
echo "✅ Ops Agent configured on ${VM}."
