# Observability Guide

## Stack components

- **Prometheus**: metrics collection, alert evaluation, and rule execution.
- **Grafana**: operational dashboards for workload and scaling visibility.
- **ServiceMonitor**: declarative workload scraping for frontend/backend services.
- **PrometheusRule**: high-signal alerts for deployment and runtime reliability.

## Monitored signals

- Pod restarts and crash frequency
- Deployment availability and unavailable replicas
- Backend request rate
- Namespace-level CPU and memory pressure
- HPA saturation (current replicas at max)

## Dashboard provisioning

Dashboards are loaded through:

- `monitoring/grafana/dashboard-configmap.yaml`
- `monitoring/grafana/k8s-platform-dashboard.json`

## Installation sequence

Install kube-prometheus-stack:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace \
  -f monitoring/prometheus/kube-prometheus-stack-values.yaml
```

Apply platform-specific monitors and rules:

```bash
kubectl apply -k monitoring
```

## Alert policy strategy

- **Critical alerts**: service unavailability, restart storms.
- **Warning alerts**: sustained CPU/memory pressure, HPA saturation.
- Alert metadata includes `team=platform` for ownership routing.

## Production integration recommendations

- Forward Alertmanager notifications to Slack, PagerDuty, or Opsgenie.
- Add long-term metrics retention using Thanos/Cortex/VictoriaMetrics.
- Enable SLO burn-rate alerting on API success/latency objectives.
