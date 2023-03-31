# CLI Reference

This section provides an overview of the different `k8sgpt` CLI commands.

**Prerequisits**
* You need to be connected to a Kubernetes cluster, K8sGPT will access it through your kubeconfig.
* [Signed-up to OpenAI ChatGPT](https://openai.com/)
* Have the [K8sGPT CLI installed](../../getting-started/installation.md)

## Commands

### Generate

Command:
```bash
k8sgpt generate
```

This command will provide you with a URL to OpenAI to generate an access token.
### Auth     

Command:
```bash
k8sgpt auth
```

This command authenticates you with your chosen backend. Provide the access token generated through the `generate` command here.

### Analyze     

Command:
```bash
k8sgpt analyse
```

This command will find problems within your Kubernetes cluster.

### Completion

Command:
```bash
k8sgpt completion
```

Generate the autocompletion script for the specified shell.

### Help

Command:
```bash
k8sgpt help
```

Provides you with the different command options in the CLI.
### Version

Command:
```bash
k8sgpt version
```

Prints the K8sGPT version you are using.

## Flags

### --config

Define the path to your k8sgpt configuration file:
```bash
--config string
```

The default is located at `$HOME/.k8sgpt.yaml`

### --help

Access more information on the different commands:
```bash
  -h, --help
```

### --kubeconfig

Provide the Path to your KubeConfig:
```bash
      --kubeconfig string
```

### --kubecontext

You can be connected to multiple Kubernetes context. To specify the Kubernetes context, use the following flag:
```bash
--kubecontext string 
```
