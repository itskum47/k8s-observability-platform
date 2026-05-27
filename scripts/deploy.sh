#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-dev}"
OVERLAY_PATH="manifests/overlays/${ENVIRONMENT}"

if [[ ! -d "${OVERLAY_PATH}" ]]; then
  echo "Unknown environment: ${ENVIRONMENT}"
  exit 1
fi

echo "[deploy] Applying workload manifests for ${ENVIRONMENT}"
kubectl apply -k "${OVERLAY_PATH}"

if [[ "${SKIP_MONITORING:-false}" != "true" ]]; then
  kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -
  echo "[deploy] Applying monitoring resources"
  kubectl apply -k monitoring
else
  echo "[deploy] Skipping monitoring resources"
fi

echo "[deploy] Waiting for rollout"
for deployment in frontend backend; do
  kubectl rollout status "deployment/${deployment}" -n "observability-${ENVIRONMENT}" --timeout=180s
done

echo "[deploy] Completed deployment for ${ENVIRONMENT}"
