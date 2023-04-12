# Installation

This page provides further information on installation guidelines.

## Linux/Mac via brew

**Prerequisites**

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

<details>
  <summary>RPM-based installation (RedHat/CentOS/Fedora)</summary>

  **32 bit:**
  <!---x-release-please-start-version-->
  ```
  curl -LO https://github.com/k8sgpt-ai/k8sgpt/releases/download/v0.2.1/k8sgpt_386.rpm
  sudo rpm -ivh k8sgpt_386.rpm
  ```
  <!---x-release-please-end-->

  **64 bit:**
 
  <!---x-release-please-start-version-->
  ```
  curl -LO https://github.com/k8sgpt-ai/k8sgpt/releases/download/v0.2.1/k8sgpt_amd64.rpm
  sudo rpm -ivh -i k8sgpt_amd64.rpm
  ```
  <!---x-release-please-end-->
</details>

<details>
  <summary>DEB-based installation (Ubuntu/Debian)</summary>

  **32 bit:**
  <!---x-release-please-start-version-->
  ```
  curl -LO https://github.com/k8sgpt-ai/k8sgpt/releases/download/v0.2.1/k8sgpt_386.deb
  sudo dpkg -i k8sgpt_386.deb
  ```
  <!---x-release-please-end-->
  **64 bit:**
 
  <!---x-release-please-start-version-->
  ```
  curl -LO https://github.com/k8sgpt-ai/k8sgpt/releases/download/v0.2.1/k8sgpt_amd64.deb
  sudo dpkg -i k8sgpt_amd64.deb
  ```
  <!---x-release-please-end-->
</details>

<details>

  <summary>APK-based installation (Alpine)</summary>

  **32 bit:**
  <!---x-release-please-start-version-->
  ```
  curl -LO https://github.com/k8sgpt-ai/k8sgpt/releases/download/v0.2.1/k8sgpt_386.apk
  apk add k8sgpt_386.apk
  ```
  <!---x-release-please-end-->
  **64 bit:**
  <!---x-release-please-start-version-->
  ```
  curl -LO https://github.com/k8sgpt-ai/k8sgpt/releases/download/v0.2.1/k8sgpt_amd64.apk
  apk add k8sgpt_amd64.apk
  ```
  <!---x-release-please-end-->x
</details>

<details>
  <summary>Failing Installation on WSL or Linux (missing gcc)</summary>
  When installing Homebrew on WSL or Linux, you may encounter the following error:

  ```
  ==> Installing k8sgpt from k8sgpt-ai/k8sgpt Error: The following formula cannot be installed from a bottle and must be 
  built from the source. k8sgpt Install Clang or run brew install gcc.
  ```

If you install gcc as suggested, the problem will persist. Therefore, you need to install the build-essential package.
  ```
     sudo apt-get update
     sudo apt-get install build-essential
  ```
</details>

## Windows

* Download the latest Windows binaries of **k8sgpt** from the [Release](https://github.com/k8sgpt-ai/k8sgpt/releases) 
  tab based on your system architecture.
* Extract the downloaded package to your desired location. Configure the system *path* variable with the binary location

## Verify installation

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