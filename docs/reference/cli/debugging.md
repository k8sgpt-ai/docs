# Debugging K8sGPT

If you are experiencing issues that you believe are related to K8sGPT.
Please cut us an issue [here](https://github.com/k8sgpt-ai/k8sgpt/issues) and upload your K8sGPT dump file.

To create a K8sGPT dump file run `k8sgpt dump`.
This will create a `dump_<time>_json` file which you can attach to your github issue.

```
❯ cat dump_20241112200820.json
{
 "AIConfiguration": {
  "Providers": [
   {
    "Name": "openai",
    "Model": "gpt-3.5-turbo",
    "Password": "sk-p***",
    "BaseURL": "",
    "ProxyEndpoint": "",
    "ProxyPort": "",
    "EndpointName": "",
    "Engine": "",
    "Temperature": 0.7,
    "ProviderRegion": "",
    "ProviderId": "",
    "CompartmentId": "",
    "TopP": 0.5,
    "TopK": 50,
    "MaxTokens": 2048,
    "OrganizationId": "",
    "CustomHeaders": []
   }
  ],
  "DefaultProvider": ""
 },
 "ActiveFilters": [
  "Deployment",
  "StatefulSet",
  "ReplicaSet",
  "Ingress",
  "ValidatingWebhookConfiguration",
  "PersistentVolumeClaim",
  "CronJob",
  "MutatingWebhookConfiguration",
  "Gateway"
 ],
 "KubenetesServerVersion": {
  "major": "1",
  "minor": "31",
  "gitVersion": "v1.31.0",
  "gitCommit": "9edcffcde5595e8a5b1a35f88c421764e575afce",
  "gitTreeState": "clean",
  "buildDate": "2024-08-13T07:28:49Z",
  "goVersion": "go1.22.5",
  "compiler": "gc",
  "platform": "linux/amd64"
 },
 "K8sGPTInfo": {
  "Version": "dev",
  "Commit": "HEAD",
  "Date": "unknown"
 }
}%
```