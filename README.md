# LGTM
Umbrella chart for a distributed Loki, Grafana, Tempo and Mimir stack

## Architecture
![](./assets/lgtm-architecture.svg)

### [Loki](./docs/loki.md)
Grafana Loki is an open source, set of components that can be composed into a fully featured logging stack. For more information, refer to Loki documentation.
### [Grafana](./docs/grafana.md)
Grafana helps you collect, correlate, and visualize data with beautiful dashboards — the open source data visualization and monitoring solution that drives informed decisions, enhances system performance, and streamlines troubleshooting.
### [Tempo](./docs/tempo.md)
Grafana Tempo is an open source, easy-to-use and high-volume distributed tracing backend. For more information, refer to Tempo documentation.
### [Mimir](./docs/mimir.md)
Grafana Mimir is an open source software project that provides a scalable long-term storage for Prometheus. For more information about Grafana Mimir, refer to Grafana Mimir documentation.

<br>

---

## Get Started

```bash
kustomize build ./overlays/dev --enable-helm --load-restrictor=LoadRestrictionsNone | kubectl apply -f -
```