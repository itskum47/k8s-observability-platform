#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-dev}"
DEPLOYMENT="${2:-backend}"
NAMESPACE="observability-${ENVIRONMENT}"

echo "[rollback] Triggering rollout undo for ${DEPLOYMENT} in ${NAMESPACE}"
kubectl rollout undo "deployment/${DEPLOYMENT}" -n "${NAMESPACE}"
kubectl rollout status "deployment/${DEPLOYMENT}" -n "${NAMESPACE}" --timeout=180s

echo "[rollback] Current image after rollback:"
kubectl get deployment "${DEPLOYMENT}" -n "${NAMESPACE}" -o jsonpath='{.spec.template.spec.containers[0].image}'
echo
