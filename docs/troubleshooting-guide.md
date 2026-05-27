# Troubleshooting Guide

## kubectl debugging workflow

1. Inspect workloads:
   ```bash
   kubectl get pods -n <namespace> -o wide
   ```
2. Describe failing pod:
   ```bash
   kubectl describe pod <pod-name> -n <namespace>
   ```
3. Check logs:
   ```bash
   kubectl logs <pod-name> -n <namespace> --previous
   ```
4. Inspect rollout and events:
   ```bash
   kubectl rollout status deploy/<deployment> -n <namespace>
   kubectl get events -n <namespace> --sort-by='.lastTimestamp'
   ```

## CrashLoopBackOff

- Validate startup command and container entrypoint.
- Check probe endpoints and timeout thresholds.
- Use `kubectl logs --previous` for pre-crash diagnostics.
- Confirm config/secret values are present and valid.

## ImagePullBackOff

- Verify image exists and tag is correct.
- Validate registry auth/imagePullSecret.
- Confirm node egress/network access to registry.
- Re-run with known-good image to isolate registry vs workload issues.

## Failed deployments

- Inspect deployment conditions:
  ```bash
  kubectl describe deploy <deployment> -n <namespace>
  ```
- Check `ReplicaSet` events for scheduling/probe failures.
- Ensure resource requests fit node capacity.
- Validate rollout history before rollback:
  ```bash
  kubectl rollout history deploy/<deployment> -n <namespace>
  ```

## DNS resolution issues

- Verify CoreDNS status:
  ```bash
  kubectl get pods -n kube-system -l k8s-app=kube-dns
  ```
- Test DNS from in-cluster shell:
  ```bash
  kubectl run dns-test --rm -it --image=busybox --restart=Never -- nslookup backend.<namespace>.svc.cluster.local
  ```
- Validate Service and Endpoints resources.

## High resource usage

- Check real-time resource pressure:
  ```bash
  kubectl top pods -n <namespace>
  kubectl top nodes
  ```
- Compare usage to resource limits/requests.
- Confirm HPA behavior and throttling indicators.

## Pod restart investigation

- Query restart counts:
  ```bash
  kubectl get pods -n <namespace> -o custom-columns=NAME:.metadata.name,RESTARTS:.status.containerStatuses[*].restartCount
  ```
- Correlate restarts with events and recent deployment changes.
- Use Prometheus restart alerts to narrow incident window.
