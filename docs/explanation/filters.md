# Filters

## Description

Filters in the K8sGPT CLI allow users to selectively analyze and process Kubernetes resources based on specific criteria.

By specifying the `--filter` option followed by the desired resource name, such as Service, users can narrow down the analysis to only that particular resource type. 
This is particularly useful when users want to focus on a specific aspect of their Kubernetes deployment.
```
k8sgpt analyze --explain --filter=Service
```

In addition to filtering by resource type, users can further refine the analysis by specifying a particular namespace. By including the `--namespace` flag along with
the `--filter` option, users can limit the analysis to resources within the specified namespace. This feature enables users to gain insights
into resource usage and behavior within a specific namespace.
```
k8sgpt analyze --explain --filter=Pod --namespace=default
```

## Adding filters
The `add` command enables users to expand the default set of filters used during resource analysis. By adding new filters, users can
refine their analysis to focus on specific Kubernetes resource types or attributes.

When utilizing this, users can specify one or more filters to be added. These filters are supplied as arguments to the command.
For example, users can add filters for resources like Service, Ingress, or Pod based on their analysis requirements.

The add command first verifies the existence and validity of the provided filters. It checks against the available filters provided by the analyzer package to
ensure that the specified filters are recognized and supported.
The command retrieves the currently defined active filters from the configuration. If no active filters are set, it defaults to the core filters.
The active filters represent the filters that will be applied during analysis.
The add command then merges the active filters with the newly specified filters, removing any duplicates. This ensures that the resulting set of filters remains unique,
preventing redundant analysis.

The `add` command is particularly useful in scenarios where users want to narrow down the analysis scope to specific resource types or attributes. By selectively adding
filters, users can focus on analyzing and understanding the behavior, usage, and interactions of targeted Kubernetes resources.
```
k8sgpt filters add [filter(s)]
```
Examples:

- Simple filter : `k8sgpt filters add Service`
- Multiple filters : `k8sgpt filters add Ingress,Pod`

## Removing filters
The `remove` command is designed to remove one or more filters from the default set of filters used in resource analysis within the K8sGPT CLI.
This command provides users with the ability to refine their analysis by excluding specific Kubernetes resource types or attributes.

When using the remove command, users can specify the filters to be removed as arguments.
For example, users can remove filters for resources such as Pod, Service, or any other previously added filters.

The command verifies if the specified filters exist in the configuration file and updates the default filters accordingly. If any filter is not found in the configuration,
an error message is displayed, indicating which filters are missing. The command also removes any duplicate filters to avoid redundancy during the removal process.
The specified filters are then removed from the default filters.

The `remove` command is a valuable tool when users need to fine-tune their analysis by eliminating specific resource types or attributes from consideration. By removing
filters, users can streamline their analysis process and concentrate on the most relevant aspects of the Kubernetes resources. This allows for a focused examination of
behavior, usage, and interactions, enabling users to gain deeper insights and make informed decisions based on the remaining filters.
```
k8sgpt filters remove [filter(s)]
```
Examples:

- Simple filter : `k8sgpt filters remove Service`
- Multiple filters : `k8sgpt filters remove Ingress,Pod`
