# Caching

Remote caching is a mechanism used to store and retrieve frequently accessed data in a location separate from the primary system. In the context of `K8sGPT`, it allows users to offload cached data to a remote storage service, like AWS S3, rather than managing it on the local machine.
This approach offers several benefits, such as reducing local storage requirements and ensuring cache persistence even when the local environment is updated or restarted.

## AWS S3 Integration

K8sGPT provides seamless integration with **AWS S3**, a widely adopted and reliable object storage service offered by **Amazon Web Services**. By leveraging this integration, users can take advantage of AWS S3's scalability, durability, and availability to store their cached data remotely.

### Prerequisites

To use the remote caching feature with AWS S3 in **K8sGPT**, you need to have the following prerequisites set up:

- `AWS_ACCESS_KEY_ID`: An access key ID is required to authenticate with AWS S3 programmatically.

- `AWS_SECRET_ACCESS_KEY`: The corresponding secret access key that pairs with the AWS access key ID.

_Adding a Remote Cache_:

Users can easily add a remote cache to the K8sGPT CLI by executing the following command:

```
k8sgpt cache add --region <aws region> --bucket <name>
```

The command above will create a new bucket in the specified AWS region if it does not already exist. The created bucket will serve as the remote cache for K8sGPT.

_Listing Cache Items_:

To view the items stored in the remote cache, users can use the following command:

```
k8sgpt cache list
```

_Removing the Remote Cache_:

If users wish to remove the remote cache without deleting the associated AWS S3 bucket, they can use the following command:

```
k8sgpt cache remove
```

This command ensures that the cache items are removed from the K8sGPT CLI, but the bucket and its contents in AWS S3 will remain intact for potential future usage.


## Azure Blob Storage Integration
K8sGPT offers integration with **Azure Blob Storage**, a scalable and cost-effective object storage solution provided by **Microsoft Azure**.

### Prerequisites
Before using the remote caching feature with Azure Blob Storage in K8sGPT, ensure you have the following prerequisites set up:

- `AZURE_STORAGE_ACCOUNT`: An Azure storage account is required to authenticate with azure CLI programmatically.

_Adding a Remote Cache_:

Users can add a remote cache to the K8sGPT CLI by executing the following command:

```
k8sgpt cache add --azure --storage <azure storage account name> --container <container name>
```

This command will create a new container in the specified Azure Storage Account if it does not already exist. The created container will serve as the remote cache for K8sGPT.

_Listing Cache Items_:

To view the items stored in the remote cache, users can use the following command:

```g
k8sgpt cache list
```

_Removing the Remote Cache_:

If users wish to remove the remote cache without deleting the associated Azure Blob Storage container, they can use the following command:

```
k8sgpt cache remove
```

This command ensures that the cache items are removed from the K8sGPT CLI, but the container and its contents in Azure Blob Storage will remain intact for potential future usage.

## Google Cloud Storage (GCS) Integration
K8sGPT  integrates with **Google Cloud Storage (GCS)**, a highly available and durable object storage service provided by **Google Cloud Platform.**

### Prerequisites
Before using the remote caching feature with Google Cloud Storage in K8sGPT, ensure you have the following prerequisites set up:

- `GOOGLE_CLOUD_STORAGE_ACCOUNT`: An Google Cloud Storage Account is required to authenticate with gcloud CLI programmatically.

_Adding a Remote Cache_:

Users can add a remote cache to the K8sGPT CLI by executing the following command:

```
k8sgpt cache add --gcs --bucket <bucket name> --region <region name> --projectid <project id>
```

This command will create a new bucket in the specified Google Cloud Storage project if it does not already exist. The created bucket will serve as the remote cache for K8sGPT.

_Listing Cache Items_:

To view the items stored in the remote cache, users can use the following command:

```
k8sgpt cache list
```

_Removing the Remote Cache_:

If users wish to remove the remote cache without deleting the associated Google Cloud Storage bucket, they can use the following command:

```
k8sgpt cache remove
```

This command ensures that the cache items are removed from the K8sGPT CLI, but the bucket and its contents in Google Cloud Storage will remain intact for potential future usage.