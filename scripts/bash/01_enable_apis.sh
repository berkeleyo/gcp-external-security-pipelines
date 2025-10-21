#!/usr/bin/env bash
set -euo pipefail
# 01_enable_apis.sh — enable core services for logging bridge (idempotent).

PROJECT_ID="${PROJECT_ID:-<your-project-id>}"
gcloud config set project "${PROJECT_ID}"

services=(
  compute.googleapis.com
  logging.googleapis.com
  monitoring.googleapis.com
  pubsub.googleapis.com
  dataflow.googleapis.com
  iam.googleapis.com
  serviceusage.googleapis.com
)

for s in "${services[@]}"; do
  echo "Enabling API: $s"
  gcloud services enable "$s" --project "${PROJECT_ID}"
done

echo "✅ APIs enabled for ${PROJECT_ID}."
