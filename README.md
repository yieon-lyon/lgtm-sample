Umbrella chart for a distributed Loki, Grafana, Tempo and Mimir stack + OpenTelemetry

```bash
kubectl kustomize ./overlays/platform --enable-helm --load-restrictor=LoadRestrictionsNone | kubectl apply -f -
```

