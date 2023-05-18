# CLI Reference

This section provides an overview of the different `k8sgpt` CLI commands.

**Prerequisites**

* You need to be connected to a Kubernetes cluster, K8sGPT will access it through your kubeconfig.
* [Signed-up to OpenAI ChatGPT](https://openai.com/)
* Have the [K8sGPT CLI installed](../../getting-started/installation.md)

## Commands

_Run a scan with the default analyzers_

```
k8sgpt generate
k8sgpt auth new
k8sgpt analyze --explain
```

_Filter on resource_

```
k8sgpt analyze --explain --filter=Service
```

_Filter by namespace_
```
k8sgpt analyze --explain --filter=Pod --namespace=default
```

_Output to JSON_

```
k8sgpt analyze --explain --filter=Service --output=json
```

_Anonymize during explain_

```
k8sgpt analyze --explain --filter=Service --output=json --anonymize
```

## Additional commands

_List configured backends_

```
k8sgpt auth list
```

_Remove configured backends_

```
k8sgpt auth remove --backend $MY_BACKEND
```

_List integrations_

```
k8sgpt integrations list
```

_Activate integrations_

```
k8sgpt integrations activate [integration(s)]
```

_Use integration_

```
k8sgpt analyze --filter=[integration(s)]
```

_Deactivate integrations_

```
k8sgpt integrations deactivate [integration(s)]
```

_Serve mode_

```
k8sgpt serve
```

_Analysis with serve mode_

```
curl -X GET "http://localhost:8080/analyze?namespace=k8sgpt&explain=false"
```
