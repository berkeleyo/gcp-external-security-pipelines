#!/usr/bin/env bash
set -euo pipefail
# 02_create_pubsub.sh — create Pub/Sub topics/subscriptions for security export.

PROJECT_ID="${PROJECT_ID:-<your-project-id>}"
TOPIC="${TOPIC:-sec-logs}"
SUB="${SUB:-sec-logs-pull}"
gcloud config set project "${PROJECT_ID}"

gcloud pubsub topics describe "$TOPIC" >/dev/null 2>&1 || gcloud pubsub topics create "$TOPIC"
gcloud pubsub subscriptions describe "$SUB" >/dev/null 2>&1 || gcloud pubsub subscriptions create "$SUB" --topic "$TOPIC"

echo "✅ Pub/Sub ready: topic=${TOPIC}, subscription=${SUB}"
