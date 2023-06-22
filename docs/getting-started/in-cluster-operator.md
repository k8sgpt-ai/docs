# K8sGPT Operator

## Prerequisites

- To begin you will require a Kubernetes cluster available and `KUBECONFIG` set.
- You will also need to install helm v3. See the [Helm documentation](https://helm.sh/docs/intro/install/) for more information.

## Operator Installation

To install the operator, run the following command:

```bash
helm repo add k8sgpt https://charts.k8sgpt.ai/
helm repo update
helm install release k8sgpt/k8sgpt-operator -n k8sgpt-operator-system --create-namespace
```

This will install the Operator into the cluster, which will await a `K8sGPT` resource before anything happens.

## Deploying an OpenAI secret

Whilst there are multiple backends supported ( OpenAI, Azure OpenAI and Local ), in this example we'll use OpenAI.
Whatever backend you are using, you need to make sure to have a secret that works with the backend.

For instance, this means you will need to install your OpenAI token as a secret into the cluster:

```bash
kubectl create secret generic k8sgpt-sample-secret --from-literal=openai-api-key=$OPENAI_TOKEN -n default
```

## Deploying a K8sGPT resource

To deploy a K8sGPT resource, you will need to create a YAML file with the following contents:

```yaml
kubectl apply -f - << EOF
apiVersion: core.k8sgpt.ai/v1alpha1
kind: K8sGPT
metadata:
  name: k8sgpt-sample
  namespace: k8sgpt-operator-system
spec:
  ai:
    enabled: true
    model: gpt-3.5-turbo
    backend: openai
    secret:
      name: k8sgpt-sample-secret
      key: openai-api-key
    # anonymized: false
    # language: english
  noCache: false
  version: v0.3.8
  # filters:
  #   - Ingress
  # sink:
  #   type: slack
  #   webhook: <webhook-url>
  # extraOptions:
  #   backstage:
  #     enabled: true
EOF
```

Please replace the `<VERSION>` field with the [current release of K8sGPT](https://github.com/k8sgpt-ai/k8sgpt/releases). At the time of writing this is `v0.3.6`.

### Regarding out of cluster traffic to AI backends

In the above example `enableAI` is set to `true`.
This option allows the cluster deployment to use the `backend` to filter and improve the responses to the user.
Those responses will appear as `details` within the `Result` custom resources that are created.

The default backend in this example is [OpenAI](https://openai.com/) and allows for additional details to be generated and solutions provided for issues.
If you wish to disable out-of-cluster communication and any Artificial Intelligence processing through models, simply set `enableAI` to `false`.

_It should also be noted that `localai` and `azureopenai` is supported and in-cluster models will be supported in the near future_

## Viewing the results

Once the initial scans have completed after several minutes, you will be presented with results custom resources.

```bash
❯ kubectl get results -o json | jq .
{
  "apiVersion": "v1",
  "items": [
    {
      "apiVersion": "core.k8sgpt.ai/v1alpha1",
      "kind": "Result",
      "metadata": {
        "creationTimestamp": "2023-04-26T09:45:02Z",
        "generation": 1,
        "name": "placementoperatorsystemplacementoperatorcontrollermanagermetricsservice",
        "namespace": "default",
        "resourceVersion": "108371",
        "uid": "f0edd4de-92b6-4de2-ac86-5bb2b2da9736"
      },
      "spec": {
        "details": "The error message means that the service in Kubernetes doesn't have any associated endpoints, which should have been labeled with \"control-plane=controller-manager\". \n\nTo solve this issue, you need to add the \"control-plane=controller-manager\" label to the endpoint that matches the service. Once the endpoint is labeled correctly, Kubernetes can associate it with the service, and the error should be resolved.",
        ...
```
