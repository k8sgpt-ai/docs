# K8sGPT Serve mode

## Prerequisites

1. Have [grpcurl](https://github.com/fullstorydev/grpcurl) installed

## Run `k8sgpt` serve mode

```bash
$ k8sgpt serve
{"level":"info","ts":1684309627.113916,"caller":"server/server.go:83","msg":"binding metrics to 8081"}
{"level":"info","ts":1684309627.114198,"caller":"server/server.go:68","msg":"binding api to 8080"}
```

This command starts two servers:

1. The health server runs on port 8081 by default and serves metrics and health endpoints.
2. The API server runs on port 8080 (gRPC) by default and serves the analysis handler.

For more details about the gRPC implementation, refer to this [link](https://buf.build/k8sgpt-ai/k8sgpt/docs/main).

## Analyze your cluster with `grpcurl`

Make sure you are connected to a Kubernetes cluster:

```bash
kubectl get nodes
```

Next, run the following command:

```bash
grpcurl -plaintext localhost:8080 schema.v1.Server/Analyze
```

This command provides a list of issues in your Kubernetes cluster.

## Analyze with parameters

You can specify parameters using the following command:

```bash
grpcurl -plaintext -d '{"explain": false, "filters": ["Ingress"], "namespace": "k8sgpt"}' localhost:8080 schema.v1.Server/Analyze
```

In this example, the analyzer will only consider the `k8sgpt` namespace without AI explanation and only focus on the `Ingress` filter.