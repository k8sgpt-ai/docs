# Installation

This page provides further information on installation guidelines.

## Linux/Mac via brew

### Prerequisites

Ensure that you have Homebrew installed:

- Homebrew for Mac
- Homebrew for Linux
Homebrew for Linux also works on WSL

### Homebrew

Install K8sGPT on your machine with the following commands:
```bash
brew tap k8sgpt-ai/k8sgpt
brew install k8sgpt
```
## Other Installation Options

### RPM-based installation (RedHat/CentOS/Fedora)

**32 bit:**

```bash
curl -LO https://github.com/k8sgpt-ai/k8sgpt/releases/download/v0.3.24/k8sgpt_386.rpm
sudo rpm -ivh k8sgpt_386.rpm
```

**64 bit:**

```bash
curl -LO https://github.com/k8sgpt-ai/k8sgpt/releases/download/v0.3.24/k8sgpt_amd64.rpm
sudo rpm -ivh -i k8sgpt_amd64.rpm
```

### DEB-based installation (Ubuntu/Debian)

  **32 bit:**

```bash
curl -LO https://github.com/k8sgpt-ai/k8sgpt/releases/download/v0.3.24/k8sgpt_386.deb
sudo dpkg -i k8sgpt_386.deb
```

**64 bit:**

```bash
curl -LO https://github.com/k8sgpt-ai/k8sgpt/releases/download/v0.3.24/k8sgpt_amd64.deb
sudo dpkg -i k8sgpt_amd64.deb
```

### APK-based installation (Alpine)

  **32 bit:**

```bash
curl -LO https://github.com/k8sgpt-ai/k8sgpt/releases/download/v0.3.24/k8sgpt_386.apk
apk add k8sgpt_386.apk
```

**64 bit:**

```bash
curl -LO https://github.com/k8sgpt-ai/k8sgpt/releases/download/v0.3.24/k8sgpt_amd64.apk
apk add k8sgpt_amd64.apk
```

## Windows

* Download the latest Windows binaries of **k8sgpt** from the [Release](https://github.com/k8sgpt-ai/k8sgpt/releases) 
  tab based on your system architecture.
* Extract the downloaded package to your desired location. Configure the system *path* variable with the binary location

## Verify installation

Verify that K8sGPT is installed correctly:

```bash
k8sgpt version

k8sgpt version 0.2.7
```

## Common Issues

### Windows WSL
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

### Failing Installation on WSL or Linux (missing gcc)
  When installing Homebrew on WSL or Linux, you may encounter the following error:

  ```
  ==> Installing k8sgpt from k8sgpt-ai/k8sgpt Error: The following formula cannot be installed from a bottle and must be 
  built from the source. k8sgpt Install Clang or run brew install gcc.
  ```

If you install gcc as suggested, the problem will persist. Therefore, you need to install the build-essential package.
  ```bash
     sudo apt-get update
     sudo apt-get install build-essential
  ```

## Running K8sGPT through a container 

If you are running K8sGPT through a container, the CLI will not be able to open the website for the OpenAI token.

You can find the latest container image for K8sGPT in the packages of the GitHub organisation: [Link](https://github.com/k8sgpt-ai/k8sgpt/pkgs/container/k8sgpt)

A volume can then be mounted to the image through e.g. [Docker Compose](https://docs.docker.com/storage/volumes/).
Below is an example:

```bash
version: '2'
services:
 k8sgpt:
   image: ghcr.io/k8sgpt-ai/k8sgpt:dev-202304011623
   volumes:
     -  /home/$(whoami)/.k8sgpt.yaml:/home/root/.k8sgpt.yaml
```

## Installing the K8sGPT Operator Helm Chart

K8sGPT can be installed as an Operator inside the cluster. 
For further information, see the [K8sGPT Operator](in-cluster-operator.md) documentation.

## Upgrading the brew installation

To upgrade the K8sGPT brew installation run the following command:

```bash
brew upgrade k8sgpt
```
