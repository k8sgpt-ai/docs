# Advanced Operator installation options

This documentation lists advanced installation options for the K8sGPT Operator.

## ArgoCD

ArgoCD is a continuous deployment tool that implements GitOps best practices to install and manage Kubernetes resources.

### Prerequisites

To install and manage K8sGPT through ArgoCD, ensure that you have ArgoCD installed and running inside your cluster.
The ArgoCD [getting-started-guide](https://argo-cd.readthedocs.io/en/stable/getting_started/) provides detailed information.

### Installing K8sGPT

K8sGPT can be installed through ArgoCD by applying an `Application` CRD to the ArgoCD namespaces in your cluster (with ArgoCD running):

K8sGPT Application CRD:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: k8sgpt
  namespace: argocd
spec:
  project: default
  source:
    chart: k8sgpt-operator
    repoURL: https://charts.k8sgpt.ai/
    targetRevision: <VERSION>
    helm:
      values: |
        serviceMonitor:
          enabled: true
        GrafanaDashboard:
          enabled: true
  destination:
    server: https://kubernetes.default.svc
    namespace: k8sgpt-operator-system
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

Note:

* Ensure that the `namespace` is correctly set to your ArgoCD namespace.
* Ensure that the `<VERSION>` is set to the [K8sGPT Operator Release Version](https://github.com/k8sgpt-ai/k8sgpt-operator/releases) that you want to use.
* Modify the `helm.values` section with the Helm Values that you would like to overwrite. Check the [values.yaml](https://github.com/k8sgpt-ai/k8sgpt-operator/tree/main/chart/operator) file of the Operator for options.

Applying the resource:

```bash
kubectl apply -f application.yaml
```

### Installing the remaining Operator resources

You will still need to install the

* K8sGPT Operator CRD
* K8sGPT secret to access the AI backend

that are both detailed in the Operator installation page. The above application resource will only install the Operator pods themselves not additional resources. Note that you could manage those resources also through ArgoCD. Please refer to the official [ArgoCD documentation](https://argo-cd.readthedocs.io/en/stable/getting_started/) for further information.
