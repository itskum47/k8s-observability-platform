# Deployment Workflow

## GitOps-oriented flow

1. Engineer updates application code or manifest configuration.
2. Pull request triggers CI validation and integration test deployment.
3. After merge, release is deployed via `deploy.yaml` workflow.
4. Smoke tests confirm endpoint and rollout health.
5. Rollout history is retained for rollback.

## Environment promotion strategy

- `dev`: fast feedback and integration validation.
- `staging`: release-candidate verification and pre-production checks.
- `prod`: controlled rollout after staging sign-off.

## Commands

Deploy specific environment:

```bash
./scripts/deploy.sh <dev|staging|prod>
```

Run smoke tests:

```bash
./scripts/smoke-test.sh <dev|staging|prod>
```

Trigger rollback:

```bash
./scripts/rollback.sh <dev|staging|prod> <deployment-name>
```

## Safety controls

- Health probes block traffic to unready pods.
- Rolling strategy prevents full-service disruption.
- HPA reduces saturation risk under load.
- PodDisruptionBudget reduces blast radius during node maintenance.
