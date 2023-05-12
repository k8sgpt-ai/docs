# K8sGPT Operator

K8sGPT can run as a Kubernetes Operator inside the cluster.
The scan results are provided as Kubernetes YAML manifests.

This section will only detail how to configure the operator. For installatio  instrusction, please see the [getting-started section.](../../getting-started/in-cluster-operator.md)

## Architecture

The diagram below showcases the different components that the K8sGPT Operator installs and manages:

![Operator Architecture](../../imgs/operator.png)

## Customising the Operator

As with other Helm Charts, the K8sGPT Operator can be customised by modifying [the `values.yaml` file.](https://github.com/k8sgpt-ai/k8sgpt/blob/main/charts/k8sgpt/values.yaml)

The following fields can be customised in the Helm Chart Deployment:

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `serviceMonitor.enabled` | Enable Prometheus Operator ServiceMonitor | `false` |
| `controllerManager.manager.image.repository` | Image repository | `k8sgpt/k8sgpt-operator` |
| `controllerManager.manager.image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `controllerManager.manager.imagePullSecrets` | Image pull secrets | `[]` |

### For example: In-cluster metrics

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