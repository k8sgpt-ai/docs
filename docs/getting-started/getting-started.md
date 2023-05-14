# Getting Started Guide

## Prerequisites

1. Ensure `k8sgpt` is installed correctly on your environment by following the [installation](./installation.md).
2. You need to be connected to any Kubernetes cluster.

### Setting up a Kubernetes cluster

To give 'k8sgpt` a try, set up a basic KinD Kubernetes cluster if you are not connected to any other cluster.
Please only use K8sGPT on environments XXX

The [KinD documentation](https://kind.sigs.k8s.io/docs/user/quick-start/) provides several installation options to set up a local cluster with two commands.

## Using K8sGPT

You can view the different command options through 

```bash
k8sgpt --help

Kubernetes debugging powered by AI

Usage:
  k8sgpt [command]

Available Commands:
  analyze     This command will find problems within your Kubernetes cluster
  auth        Authenticate with your chosen backend
  completion  Generate the autocompletion script for the specified shell
  generate    Generate Key for your chosen backend (opens browser)
  help        Help about any command
  version     Print the version number of k8sgpt

Flags:
      --config string       config file (default is $HOME/.k8sgpt.yaml)
  -h, --help                help for k8sgpt
      --kubeconfig string   Path to a kubeconfig. Only required if out-of-cluster.
      --master string       The address of the Kubernetes API server. Overrides any value in kubeconfig. Only required if out-of-cluster.
  -t, --toggle              Help message for toggle

Use "k8sgpt [command] --help" for more information about a command.
```

## Authenticate with ChatGPT

First, you will need to authenticate with your chosen backend. The backend is the AI provider such as OpenAI's ChatGPT.

[Ensure that you have created an account.](https://chat.openai.com/auth/login)

Next, generate a token from the backend:

```bash
k8sgpt generate
```

This will provide you with a URL to generate a token, follow the URL from the commandline to your browser to then generate the token.

![Generate a token on the OpenAI website](../imgs/generate-token.png)

Copy the token for the next step.

Then, authenticate with the following command:

```bash
k8sgpt auth
```

This will request the token that has just been generated. Paste the token into the commandline.

You should then see the following success message:
> Enter openai Key: key added

## Analyze your cluster

Ensure that you are connected to a Kubernetes cluster:

```bash
kubectl get nodes
```

Next, you can go ahead an analyze your cluster:

```bash
k8sgpt analyze
```

This will provide you with a list of issues of your Kubernetes cluster.
