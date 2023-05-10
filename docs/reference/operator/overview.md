# K8sGPT Operator

K8sGPT can run as a Kubernetes Operator inside the cluster.
The scan results are provided as Kubernetes YAML manifests.

This section will only detail how to configure the operator. For installatio  instrusction, please see the [getting-started section.](../../getting-started/in-cluster-operator.md)

## Customising the Operator

As with other Helm Charts, the K8sGPT Operator can be customised by modifying [the `values.yaml` file.](https://github.com/k8sgpt-ai/k8sgpt/blob/main/charts/k8sgpt/values.yaml)

### In-cluster metrics

It is possible to enable metrics of the operator so that they can be scraped through Prometheus.

This is the configuration required in the `values.yaml` manifest:
```yaml
serviceMonitor:
  enabled: true
```

The new `values.yaml` manifest can then be provided upon installing the Operator inside the cluster:
```bash
helm install release k8sgpt/k8sgpt-operator --values values.yaml
```