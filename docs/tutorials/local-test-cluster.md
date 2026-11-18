# Local Test Cluster

If you want to see K8sGPT find real problems without touching a shared cluster, you can run a complete demo environment on your laptop. The [**autonomous-sre-training**](https://github.com/data-agent-co/autonomous-sre-training) repository, an Apache-2.0 project maintained by [DataAgent](https://data-agent.co/), builds one with a single script.

The demo creates a one-node Kubernetes cluster with sample applications, a monitoring stack, and the K8sGPT Operator. You then break an application on purpose and review output from K8sGPT and custom Perses dashboards.

An LLM backend is optional. Without one, K8sGPT still reports problems but doesn't add AI explanations. The demo works with any OpenAI-compatible API, including local models served by Ollama or LM Studio.

The environment is built for learning. Don't use it in production.