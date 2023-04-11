# Installation

This page provides further information on installation guidelines.

## Linux/Mac via brew

### Prerequisites

Ensure that you have Homebrew installed:

- Homebrew for Mac
- Homebrew for Linux
Homebrew for Linux also works on WSL

### Installation

Install K8sGPT on your machine with the following commands:

```bash
brew tap k8sgpt-ai/k8sgpt
brew install k8sgpt
```

Verify that K8sGPT is installed correctly:

```bash
k8sgpt version

k8sgpt version 0.1.3
```

### Common Issues

Failing Installation on WSL or Linux (missing gcc)
When installing Homebrew on WSL or Linux, you may encounter the following error:

```bash
==> Installing k8sgpt from k8sgpt-ai/k8sgpt Error: The following formula cannot be installed from bottle and must be 
built from source. k8sgpt Install Clang or run brew install gcc.
```

If you install gcc as suggested, the problem will persist. Therefore, you need to install the build-essential package.

```bash
   sudo apt-get update
   sudo apt-get install build-essential
```

### Upgrading the brew installation

To upgrade the K8sGPT brew installation run the following command:

```bash
brew upgrade k8sgpt
```
