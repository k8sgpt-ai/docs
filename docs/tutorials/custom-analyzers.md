# Custom Analyzers

In this tutorial, we will learn how to create custom analyzers for K8sGPT.
We will create a custom analyzer that checks a Linux host for resource issues and provides recommendations.

[Full example code](https://github.com/k8sgpt-ai/go-custom-analyzer)

### Why?

There are usecases where you might want to create custom analyzers to check for specific issues in your environment. This would be in conjunction with the K8sGPT built-in analyzers.
For example, you may wish to scan the Kubernetes cluster nodes more deeply to understand if there are underlying issues that are related to issues in the cluster.

## Prerequisites

- [K8sGPT CLI](https://github.com/k8sgpt-ai/k8sgpt.git)
- [Golang](https://golang.org/doc/install) go1.22 or higher



### Writing a simple analyzer

 The K8sGPT CLI, operator and custom analyzers all use a GRPC API to communicate with each other. The API is defined in the [buf.build/k8sgpt-ai/k8sgpt](https://buf.build/k8sgpt-ai/k8sgpt/docs/main:schema.v1) repository. Buf is a tool that helps you manage Protobuf files. You can install it by following the instructions [here](https://docs.buf.build/installation).
 Another advantage of buf is that when you import a Protobuf file, it will automatically download the dependencies for you. This is useful when you are working with Protobuf files that have dependencies on other Protobuf files. Additionally, you'll always be able to get the latest version of the Protobuf files.

### Project setup

Let's create a new simple golang project. We will use the following directory structure:

```bash
mkdir -p custom-analyzer
cd custom-analyzer
go mod init github.com/<username>/custom-analyzer
```

Once we have this structure let's create a simple main.go file with the following content:

```go
// main.go
package main

import (
	rpc "buf.build/gen/go/k8sgpt-ai/k8sgpt/grpc/go/schema/v1/schemav1grpc"
	"errors"
	"fmt"
	"github.com/k8sgpt-ai/go-custom-analyzer/pkg/analyzer"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
	"net"
	"net/http"
)

func main() {

	var err error
	address := fmt.Sprintf(":%s", "8085")
	lis, err := net.Listen("tcp", address)
	if err != nil {
		panic(err)
	}
	grpcServer := grpc.NewServer()
	reflection.Register(grpcServer)
	aa := analyzer.Analyzer{}
	rpc.RegisterAnalyzerServiceServer(grpcServer, aa.Handler)
	if err := grpcServer.Serve(
		lis,
	); err != nil && !errors.Is(err, http.ErrServerClosed) {
		return
	}
}
```

The most important part of this file is here:
```
aa := analyzer.Analyzer{}
	rpc.RegisterAnalyzerServiceServer(grpcServer, aa.Handler)
```

Let's go ahead and create the `analyzer` package with the following structure:

```bash
mkdir -p pkg/analyzer
```

Now let's create the `analyzer.go` file with the following content:

```go
// analyzer.go

package analyzer

import (
	rpc "buf.build/gen/go/k8sgpt-ai/k8sgpt/grpc/go/schema/v1/schemav1grpc"
	v1 "buf.build/gen/go/k8sgpt-ai/k8sgpt/protocolbuffers/go/schema/v1"
	"context"
)

type Handler struct {
	rpc.AnalyzerServiceServer
}
type Analyzer struct {
	Handler *Handler
}

func (a *Handler) Run(context.Context, *v1.AnalyzerRunRequest) (*v1.AnalyzerRunResponse, error) {

	response := &v1.AnalyzerRunResponse{
		Result: &v1.Result{
			Name:    "example",
			Details: "example",
			Error: []*v1.ErrorDetail{
				&v1.ErrorDetail{
					Text: "This is an example error message!",
				},
			},
		},
	}

	return response, nil
}
```

This file contains the `Handler` struct which implements the `Run` method. This method is called when the analyzer is run. In this example, we are returning an error message.
The `Run` method takes a context and an `AnalyzerRunRequest` as arguments and returns an `AnalyzerRunResponse` and an error. Find the API available [here](https://buf.build/k8sgpt-ai/k8sgpt/file/main:schema/v1/analyzer.proto#L16).

### Implementing some custom logic

Now that we have the basic structure in place, let's implement some custom logic. We will check the disk usage on the host and return an error if it is above a certain threshold.

```go
// analyzer.go
import "github.com/ricochet2200/go-disk-usage/du"
var KB = uint64(1024)
func (a *Handler) Run(context.Context, *v1.AnalyzerRunRequest) (*v1.AnalyzerRunResponse, error) {

	usage := du.NewDiskUsage("/")
	diskUsage := int((usage.Size() - usage.Free()) * 100 / usage.Size())
	var response = &v1.AnalyzerRunResponse{}
	if diskUsage > 90 {
		response = &v1.AnalyzerRunResponse{
			Result: &v1.Result{
				Name:    "Disk Usage",
				Details: "Disk usage is above 90%",
				Error: []*v1.ErrorDetail{
					&v1.ErrorDetail{
						Text: "Disk usage is above 90%",
					},
				},
			},
		}
	}
	return response, nil
}
```

### Testing it out

To test this with K8sGPT we need to update the local K8sGPT CLI configuration to point to the custom analyzer.

To get the path of the local configuration:
```bash
❯ k8sgpt help
Kubernetes debugging powered by AI

Usage:
  k8sgpt [command]

Available Commands:
  analyze     This command will find problems within your Kubernetes cluster
  auth        Authenticate with your chosen backend
  cache       For working with the cache the results of an analysis
  completion  Generate the autocompletion script for the specified shell
  filters     Manage filters for analyzing Kubernetes resources
  generate    Generate Key for your chosen backend (opens browser)
  help        Help about any command
  integration Integrate another tool into K8sGPT
  serve       Runs k8sgpt as a server
  version     Print the version number of k8sgpt

Flags:
      --config string        Default config file (`<PATH>`)
  -h, --help                 help for k8sgpt
      --kubeconfig string    Path to a kubeconfig. Only required if out-of-cluster.
      --kubecontext string   Kubernetes context to use. Only required if out-of-cluster.

Use "k8sgpt [command] --help" for more information about a command.
```

After that, We can do this by running the following command (Please remember to replace the `<PATH>` with the real path):

```bash
❯ cat `<PATH>`
custom_analyzers:
  - name: Disk Usage
    connection:
      url: localhost
      port: 8085
```

This will add the custom analyzer to the list of available analyzers in the K8sGPT CLI.
To execute the analyzer we can run the following command:

```bash
k8sgpt analyze --custom-analysis
```

## What's next?

Now you've got the basics of how to write a custom analyzer, you can extend this to check for other issues on your hosts or in your Kubernetes cluster. You can also create more complex analyzers that check for multiple issues and provide more detailed recommendations.

