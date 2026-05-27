# k8s-observability-platform

Production-grade Kubernetes observability and deployment platform showcasing platform engineering practices for multi-service workloads, deployment reliability, and operational troubleshooting.

## What this repository demonstrates

- Multi-service Kubernetes architecture (`frontend` + `backend`) with rolling deployments, probes, autoscaling, and namespace isolation.
- Environment separation using Kustomize overlays (`dev`, `staging`, `prod`).
- Helm chart packaging for reusable release management.
- Observability foundation with Prometheus, Grafana dashboards, and actionable alerting rules.
- CI/CD automation with GitHub Actions for validation, image build, security scanning, deployment, smoke testing, and rollback verification.
- Incident response and troubleshooting runbooks for common Kubernetes failures.

## Repository structure

```text
k8s-observability-platform/
├── apps/                      # Backend + frontend containerized workloads
├── manifests/                 # Base Kubernetes resources and Kustomize overlays
├── helm/                      # Helm chart packaging for platform deployment
├── monitoring/                # Prometheus rules, ServiceMonitors, Grafana dashboards
├── ingress/                   # NGINX ingress routing
├── scripts/                   # Deployment, smoke tests, rollback, and debug helpers
├── docs/                      # Architecture and operations documentation
├── diagrams/                  # Mermaid architecture and flow diagrams
├── .github/workflows/         # CI/CD workflows
└── README.md
```

## Quick start

### 1) Build application images

```bash
docker build -t ghcr.io/your-org/k8s-observability-backend:dev ./apps/backend
docker build -t ghcr.io/your-org/k8s-observability-frontend:dev ./apps/frontend
```

### 2) Deploy workload manifests

```bash
./scripts/deploy.sh dev
```

### 3) Run smoke tests

```bash
./scripts/smoke-test.sh dev
```

### 4) Rollback a deployment revision

```bash
./scripts/rollback.sh dev backend
```

## CI/CD workflow summary

- `ci.yaml`:
  - YAML linting
  - Docker image build
  - Trivy container vulnerability scanning
  - Kubernetes manifest validation (`kustomize`, `kubeconform`, `helm lint`)
  - Integration deployment on Kind
  - Smoke tests and rollback validation

- `deploy.yaml`:
  - Manual environment deployment (`dev`, `staging`, `prod`)
  - Image build and push to GHCR
  - Overlay image update
  - Deployment + smoke tests
  - Rollback command-path verification

## Operational guides

- Architecture: `docs/architecture-overview.md`
- Deployment workflow: `docs/deployment-workflow.md`
- Observability: `docs/observability-guide.md`
- Troubleshooting: `docs/troubleshooting-guide.md`
- Incident response: `docs/incident-response-examples.md`
- CI/CD details: `docs/cicd-explained.md`
- Rollback strategy: `docs/rollback-procedures.md`

## EKS and enterprise adaptation notes

This repository is Kubernetes-distribution agnostic and can be deployed to Amazon EKS by integrating:

- `aws-auth` and IAM roles for service accounts (IRSA)
- ECR image registries instead of GHCR
- Route53 + ACM for ingress DNS/TLS
- CloudWatch/Prometheus remote write for long-term metrics retention

## Recruiter-facing highlights

- Kubernetes production operations
- CI/CD reliability engineering
- Observability and alerting design
- Incident response runbook ownership
- Platform engineering with reusable deployment architecture
