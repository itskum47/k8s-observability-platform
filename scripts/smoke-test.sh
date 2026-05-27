#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-dev}"
NAMESPACE="observability-${ENVIRONMENT}"

echo "[smoke] Verifying workloads in ${NAMESPACE}"
kubectl get pods -n "${NAMESPACE}"

echo "[smoke] Checking deployment availability"
kubectl wait --for=condition=Available deployment/frontend -n "${NAMESPACE}" --timeout=120s
kubectl wait --for=condition=Available deployment/backend -n "${NAMESPACE}" --timeout=120s

echo "[smoke] Checking backend health endpoint via port-forward"
kubectl port-forward -n "${NAMESPACE}" svc/backend 18080:80 >/tmp/backend-port-forward.log 2>&1 &
PF_PID=$!
trap 'kill ${PF_PID} >/dev/null 2>&1 || true' EXIT
sleep 4
curl -fsS "http://127.0.0.1:18080/healthz" >/dev/null
curl -fsS "http://127.0.0.1:18080/readyz" >/dev/null

echo "[smoke] Smoke tests passed"
