# Rollback Procedures

## Rollback decision triggers

- Elevated 5xx errors after deployment
- Sustained `CrashLoopBackOff` or probe failures
- `DeploymentUnavailable` alerts
- Smoke test failures in staging or production

## Standard rollback command

```bash
./scripts/rollback.sh <dev|staging|prod> <backend|frontend>
```

Equivalent kubectl command:

```bash
kubectl rollout undo deployment/<deployment> -n observability-<env>
```

## Verification checklist after rollback

1. `kubectl rollout status` reports successful rollout.
2. Pod readiness is healthy and restart count stabilizes.
3. Smoke tests pass.
4. Alerts normalize.
5. Grafana metrics return to baseline trend.

## Rollback safeguards

- Keep `revisionHistoryLimit` > 1 on deployments.
- Avoid schema-breaking database migrations without compatibility strategy.
- Store immutable image tags for each release.
- Annotate deployments with release metadata for traceability.

## Roll-forward strategy

After stabilization:

1. Complete root-cause analysis.
2. Patch and test in `dev` then `staging`.
3. Redeploy with a new immutable tag.
4. Monitor 30-60 minutes against key SLO indicators.
