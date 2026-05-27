#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${1:-observability-dev}"

echo "[debug] Pods"
kubectl get pods -n "${NAMESPACE}" -o wide

echo "[debug] Recent events"
kubectl get events -n "${NAMESPACE}" --sort-by='.lastTimestamp' | tail -n 25

echo "[debug] Deployments"
kubectl get deploy -n "${NAMESPACE}"

echo "[debug] Describe backend deployment"
kubectl describe deploy backend -n "${NAMESPACE}"

echo "[debug] Tail backend logs"
kubectl logs -l app.kubernetes.io/name=backend -n "${NAMESPACE}" --tail=100
