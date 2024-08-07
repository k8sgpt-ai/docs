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
k8sgpt auth add
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

_Serve mode with GRPC_

```
k8sgpt serve
```

_Analysis with GRPC serve mode_
```
grpcurl -plaintext localhost:8080 schema.v1.ServerService/Analyze
```

_Serve mode with GRPC and non-default backend (amazonbedrock)_

```
k8sgpt serve -b amazonbedrock
```

_Analysis with GRPC serve mode and non-default backend (amazonbedrock)_
```
grpcurl -plaintext -d '{"explain": true, "backend": "amazonbedrock"}' localhost:8080 schema.v1.ServerService/Analyze
```

_Serve mode with REST API_
```
k8sgpt serve --http
```

_Analysis with REST API serve mode_
```
curl -X POST "http://localhost:8080/v1/analyze"
```

_Serve mode with REST API serve mode and non-default backend (amazonbedrock)_
```
k8sgpt serve --http -b amazonbedrock
```

_Analysis with REST API serve mode and non-default backend (amazonbedrock)_
```
curl -X POST "http://localhost:8080/v1/analyze?explain=true&backend=amazonbedrock"
```
