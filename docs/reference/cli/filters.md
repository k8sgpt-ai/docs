# Using Integration and Filters in K8sGPT

K8sGPT offers integration with other tools. Once an integration is added to K8sGPT, it is possible to use its resources as additional filters.

* Filters are a way of selecting which resources you wish to be part of your default analysis.
* Integrations are a way to add resources to the filter list.


The first integration that has been added is Trivy.
[Trivy](https://github.com/aquasecurity/trivy) is an open source, cloud native security scanner, maintained by Aqua Security.

K8sGPT also supports a [Prometheus](https://prometheus.io) integration. Prometheus is an open source monitoring solution.

Use the following command to access all K8sGPT CLI options related to integrations:
```bash
k8sgpt integrations
```

## Prerequisites
For using the K8sGPT integrations please ensure that you have the latest version of the [K8sGPT CLI](https://docs.k8sgpt.ai/getting-started/installation/) installed.
Also, please make sure that you are connected to a Kubernetes cluster.

## Activating a new integration

**Prerequisites**

* Connected to a running Kubernetes cluster, any cluster will work for demonstration purposes

To list all integrations run the following command:
```bash
k8sgpt integrations list
```

This will provide you with a list of available integrations.

## Trivy

Activate the Trivy integration:
```bash
k8sgpt integration activate trivy
```

Once activated, you should see the following success message displayed:
```
Activated integration trivy
```

This will install the Trivy Kubernetes Operator into the Kubernetes cluster and make it possible for K8sGPT to interact with the results of the Operator.

Once the Trivy Operator is installed inside the cluster, K8sGPT will have access to VulnerabilityReports and ConfigAuditReports:
```bash
❯ k8sgpt filters list

Active:
> VulnerabilityReport (integration)
> Pod
> ConfigAuditReport (integration)
Unused:
> PersistentVolumeClaim
> Service
> CronJob
> Node
> MutatingWebhookConfiguration
> Deployment
> StatefulSet
> ValidatingWebhookConfiguration
> ReplicaSet
> Ingress
> HorizontalPodAutoScaler
> PodDisruptionBudget
> NetworkPolicy
```

More information can be found on the official [Trivy-Operator documentation.](https://aquasecurity.github.io/trivy-operator/latest/docs/crds/)

### Using the new filters to analyze your cluster

Any of the filters listed in the previous section can be used as part of the `k8sgpt analyze` command.

To use the `VulnerabilityReport` filter from the Trivy integration, set it through the `--filter` flag:
```bash
k8sgpt analyze --filter VulnerabilityReport
```

This command will analyze your cluster Vulnerabilities through K8sGPT. Depending on the VulnerabilityReports available in your cluster, the result of the report will look different:
```bash
❯ k8sgpt analyze --filter VulnerabilityReport

0 demo/nginx-deployment-7bcfc88bbf(Deployment/nginx-deployment)
- Error: critical Vulnerability found ID: CVE-2023-23914 (learn more at: https://avd.aquasec.com/nvd/cve-2023-23914)
- Error: critical Vulnerability found ID: CVE-2023-27536 (learn more at: https://avd.aquasec.com/nvd/cve-2023-27536)
- Error: critical Vulnerability found ID: CVE-2023-23914 (learn more at: https://avd.aquasec.com/nvd/cve-2023-23914)
- Error: critical Vulnerability found ID: CVE-2023-27536 (learn more at: https://avd.aquasec.com/nvd/cve-2023-27536)
- Error: critical Vulnerability found ID: CVE-2019-8457 (learn more at: https://avd.aquasec.com/nvd/cve-2019-8457)
```

## Prometheus

The Prometheus integration does not deploy resources in your cluster. Instead,
it detects a running Prometheus stack in the provided namespace using the
`--namespace` flag. If you do not have Prometheus running, you can install it
using [prometheus-operator](https://prometheus-operator.dev) or [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus).

Activate the [Prometheus](https://prometheus.io) integration:
```bash
k8sgpt integration activate prometheus --namespace <namespace>
```

If successful, you should see the following success message displayed:
```
Activating prometheus integration...
Found existing installation
Activated integration prometheus
```

Otherwise, it will report an error:
```
Activating prometheus integration...
Prometheus installation not found in namespace: <namespace>.
                Please ensure Prometheus is deployed to analyze.
Error: no prometheus installation found
```

Once activated, K8sGPT will have access to new filters:
```bash
❯ k8sgpt filters list

Active:
> PersistentVolumeClaim
> Service
> ValidatingWebhookConfiguration
> MutatingWebhookConfiguration
> PrometheusConfigRelabelReport (integration)
> Deployment
> CronJob
> Node
> Pod
> PrometheusConfigValidate (integration)
> Ingress
> StatefulSet
> PrometheusConfigReport
> ReplicaSet
Unused:
> HorizontalPodAutoScaler
> PodDisruptionBudget
> NetworkPolicy
> Log
> GatewayClass
> Gateway
> HTTPRoute
```

### Using the new filters to analyze your cluster

Any of the filters listed in the previous section can be used as part of the `k8sgpt analyze` command.

The `PrometheusConfigValidate` analyzer does a basic "sanity-check" on your
Prometheus configuration to ensure it is formatted correctly and that Prometheus
can load it properly. For example, if Prometheus is deployed in the `monitoring`
namespace and has a bad config, we can analyze the issue using the `--filter` flag:
```bash
❯ k8sgpt analyze --filter PrometheusConfigValidate --namespace monitoring --explain

0 monitoring/prometheus-test-0(StatefulSet/prometheus-test)
- Error: error validating Prometheus YAML configuration: unknown relabel action "keeps"
Error: Unknown relabel action "keeps" in Prometheus configuration.

Solution:
1. Check the Prometheus documentation for valid relabel actions.
2. Correct the relabel action to a valid one, such as "keep" or "drop".
3. Ensure the relabel configuration is correct and matches the intended behavior.
4. Restart Prometheus to apply the changes.
```

The `PrometheusConfigRelabelReport` analyzer parses your Prometheus relabeling
rules and reports groups of labels needed by your targets to be scraped successfully.
```bash
❯ k8sgpt analyze --filter PrometheusConfigRelabelReport --namespace monitoring --explain

Discovered and parsed Prometheus scrape configurations.
For targets to be scraped by Prometheus, ensure they are running with
at least one of the following label sets:
- Job: prom-example
  - Service Labels:
    - app.kubernetes.io/name=prom-example
  - Pod Labels:
    - app.kubernetes.io/name=prom-example
  - Namespaces:
    - default
  - Ports:
    - metrics
  - Containers:
    - prom-example
- Job: collector
  - Service Labels:
    - app.kubernetes.io/name=collector
  - Pod Labels:
    - app.kubernetes.io/name=collector
  - Namespaces:
    - monitoring
  - Ports:
    - prom-metrics
  - Containers:
    - collector
```

Note: the LLM prompt includes a subset of your Prometheus relabeling rules to
avoid using too many tokens, so you may not see every label set in the output.

## AWS

The AWS Operator is a tool that allows Kubernetes to manage AWS resources directly, making it easier to integrate AWS services with other Kubernetes applications. This integration helps K8sGPT to interact with the AWS resources managed by the Operator. As a result, you can use K8sGPT to analyze and manage not only your Kubernetes resources but also your AWS resources that are under the management of the AWS Operator.

Activate the AWS integration:
```bash
k8sgpt integration activate aws
```
Once activated, you should see the following success message displayed:
```
Activated integration aws
```

This will activate the AWS Kubernetes Operator into the Kubernetes cluster and make it possible for K8sGPT to interact with the results of the Operator.

Once the AWS integration is activated inside the cluster, K8sGPT will have access to EKS:
```bash
❯ k8sgpt filters list

Active:
> StatefulSet
> Ingress
> Pod
> Node
> ValidatingWebhookConfiguration
> Service
> EKS (integration)
> PersistentVolumeClaim
> MutatingWebhookConfiguration
> CronJob
> Deployment
> ReplicaSet
Unused:
> Log
> GatewayClass
> Gateway
> HTTPRoute
> HorizontalPodAutoScaler
> PodDisruptionBudget
> NetworkPolicy
```

More information can be found on the official [AWS-Operator documentation](https://aws.amazon.com/blogs/opensource/aws-service-operator-kubernetes-available/).

### Using the new filters to analyze your cluster

Any of the filters listed in the previous section can be used as part of the `k8sgpt analyze` command.

> **Note:** Ensure the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables are set as outlined in the [AWS CLI environment variables documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html).

To use the `EKS` filter from the AWS integration, specify it with the --filter flag:
```bash
k8sgpt analyze --filter EKS
```

This command analyzes your cluster's EKS resources using K8sGPT. Make sure your EKS cluster is working in the specified namespace. The report's results will vary based on the EKS reports available in your cluster.

## Adding and removing default filters

_Remove default filters_

```
k8sgpt filters add [filter(s)]
```

- Simple filter : `k8sgpt filters add Service`
- Multiple filters : `k8sgpt filters add Ingress,Pod`


_Remove default filters_

```
k8sgpt filters remove [filter(s)]
```

- Simple filter : `k8sgpt filters remove Service`
- Multiple filters : `k8sgpt filters remove Ingress,Pod`

