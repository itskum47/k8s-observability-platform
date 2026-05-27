# Kubernetes Architecture Overview

## Workload design

- **Frontend service** exposes web traffic and validates ingress and backend reachability.
- **Backend service** exposes API endpoints, readiness/liveness probes, and Prometheus metrics.
- **Namespace isolation** separates environments (`observability-dev`, `observability-staging`, `observability-prod`).
- **Configuration management** is handled via ConfigMaps and Secrets.
- **Resilience controls** include PodDisruptionBudgets, autoscaling, and rolling updates.

## Networking model

- NGINX Ingress routes:
  - `/` → frontend service
  - `/api` → backend service
- Internal service communication uses ClusterIP services.
- Network policies implement default deny and explicit frontend-to-backend communication.

## Deployment controls

- Rolling updates with controlled surge/unavailable thresholds.
- Probes:
  - `/healthz` for liveness
  - `/readyz` for readiness
- HorizontalPodAutoscaler:
  - CPU and memory scaling for backend
  - CPU scaling for frontend

## Packaging options

- **Kustomize** for environment overlays and operational drift control.
- **Helm** for release packaging and reusable deployment configuration.

## Diagram references

- `diagrams/kubernetes-architecture.mmd`
- `diagrams/deployment-flow.mmd`
