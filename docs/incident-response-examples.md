# Incident Response Examples

## Scenario 1: Backend CrashLoopBackOff after release

### Detection

- Alert: `PlatformPodCrashLooping`
- Signal: restart count spike in `observability-prod`

### Triage

1. Identify impacted release revision:
   ```bash
   kubectl rollout history deploy/backend -n observability-prod
   ```
2. Capture logs and events:
   ```bash
   kubectl logs deploy/backend -n observability-prod --all-containers=true --tail=200
   kubectl get events -n observability-prod --sort-by='.lastTimestamp' | tail -n 30
   ```

### Mitigation

- Roll back deployment revision:
  ```bash
  ./scripts/rollback.sh prod backend
  ```
- Verify recovery via smoke tests and dashboard.

### Follow-up

- Root cause analysis and probe threshold review.
- Add pre-deployment regression test for failure path.

## Scenario 2: Staging rollout succeeds but API returns 5xx

### Detection

- Smoke test failure from `scripts/smoke-test.sh`.
- Grafana backend request anomalies.

### Triage

1. Validate service routing and endpoints.
2. Compare environment config changes between last successful and current deployment.
3. Check secret/config drift.

### Mitigation

- Roll back backend deployment.
- Restore known-good ConfigMap and secret payload.

### Follow-up

- Add config schema validation in CI.
- Add staging canary gate before promotion.

## Scenario 3: HPA stuck at max replicas

### Detection

- Alert: `HPAAtMaxReplicas` for sustained interval.

### Triage

- Identify capacity bottleneck:
  - CPU saturation
  - external dependency latency
  - thread/connection exhaustion

### Mitigation

- Increase max replicas temporarily.
- Apply backend performance tuning profile.
- Scale node group or adjust pod resources.

### Follow-up

- Capacity planning update.
- Add SLO/error-budget based autoscaling alerting.
