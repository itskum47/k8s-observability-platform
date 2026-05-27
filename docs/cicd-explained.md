# CI/CD Workflow Explanation

## Objectives

- Prevent invalid Kubernetes changes from reaching runtime environments.
- Ensure container security posture before deployment.
- Prove deployment and rollback behavior continuously.

## `ci.yaml` stages

1. **YAML validation**
   - Lints repository YAML to catch syntax and policy issues early.
2. **Container build + scan**
   - Builds backend/frontend images.
   - Scans images with Trivy for critical/high vulnerabilities.
3. **Manifest validation**
   - Renders Kustomize overlays.
   - Validates resources with `kubeconform`.
   - Lints Helm chart.
4. **Integration deployment**
   - Deploys to ephemeral Kind cluster.
   - Runs smoke tests.
   - Simulates failed rollout and validates rollback.

## `deploy.yaml` stages

1. Build and push release images to GHCR.
2. Update Kustomize overlay image tags.
3. Deploy to selected environment (`dev`/`staging`/`prod`).
4. Run smoke tests.
5. Validate rollback path using rollout history and dry-run undo.

## Security and reliability controls

- Automated vulnerability checks in CI.
- Deployment blocking on validation failures.
- Rollback readiness verified continuously.
- Environment-specific overlays reduce accidental cross-environment drift.
