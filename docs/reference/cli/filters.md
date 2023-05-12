# Using Integration and Filters in K8sGPT

K8sGPT offers integration with other tools. Once an integration is added to K8sGPT, it is possible to use its resources as additional filters.

* Filters are a way of selecting which resources you wish to be part of your default analysis.
* Integrations are a way to add in additional resources to the filter list.


The first integration that has been added is Trivy.
[Trivy](https://github.com/aquasecurity/trivy) is an open source, cloud native security scnaner, maintained by Aqua Security.

Use the following command to access all K8sGPT CLI options related to integrations:
```bash
k8sgpt integrations
```

## Activating a new integration

**Prerequisites**

* Connected to a running Kubernetes cluster, any cluster will work for demonstration purposes

To list all integrations run the following command:
```bash
k8sgpt integrations list
```

This will provide you with a list of available integrations. 

Activate the Trivy integration:
```bash
k8sgpt integration activate trivy
```

This will install the Trivy Kubernetes Operator into the Kubernetes cluster and make it possible for K8sGPT to interact with the results of the Operator.

Once the Trivy Operator is installed inside the cluster, K8sGPT will have access to VulnerabilityReports:
```bash
k8sgpt filters list

Active: 
> VulnerabilityReport (integration)
Unused: 
> Pod
> Deployment
> Service
> StatefulSet
> ReplicaSet
> PersistentVolumeClaim
> Ingress
> CronJob
> Node
> NetworkPolicy
> HorizontalPodAutoScaler
> PodDisruptionBudget
```

## Using the new filters to analyse your cluster

Any of the filters listed in the previous section can be used as part of the `k8sgpt analyse` command.

To use the `VulnerabilityReport` filter from the Trivy integration, set it through the `--filter` flag:
```bash
k8sgpt analyse --filter VulnerabilityReport
```

This command will analyse your cluster Vulnerabilities through K8sGPT. Depnding on the VulnerabilityReports available in your cluster, the result of the report will look different:
```bash
❯ k8sgpt analyse --filter VulnerabilityReport

0 demo/nginx-deployment-7bcfc88bbf(Deployment/nginx-deployment)
- Error: critical Vulnerability found ID: CVE-2023-23914 (learn more at: https://avd.aquasec.com/nvd/cve-2023-23914)
- Error: critical Vulnerability found ID: CVE-2023-27536 (learn more at: https://avd.aquasec.com/nvd/cve-2023-27536)
- Error: critical Vulnerability found ID: CVE-2023-23914 (learn more at: https://avd.aquasec.com/nvd/cve-2023-23914)
- Error: critical Vulnerability found ID: CVE-2023-27536 (learn more at: https://avd.aquasec.com/nvd/cve-2023-27536)
- Error: critical Vulnerability found ID: CVE-2019-8457 (learn more at: https://avd.aquasec.com/nvd/cve-2019-8457)
```

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