#!/usr/bin/env bash
set -euo pipefail

echo "[validate] Rendering all overlays"
for env in dev staging prod; do
  kubectl kustomize "manifests/overlays/${env}" >/tmp/"${env}"-rendered.yaml
done

echo "[validate] Running kubeconform validation"
for env in dev staging prod; do
  kubeconform -strict -summary /tmp/"${env}"-rendered.yaml
done

echo "[validate] Linting Helm chart"
helm lint helm/k8s-observability-platform

echo "[validate] All manifest checks passed"
