# Integrate K8sGPT operator with Slack  
## Slack prerequisites 
- Create a slack channel
- Create a slack app
- Enable and create an incoming webhook
- Copy the webhook URL value

You can follow Slack's documentation to create the [webhook](https://api.slack.com/messaging/webhooks)

## Configure the K8sGPT operator  

Install the operator with HELM  
```bash
helm repo add k8sgpt https://charts.k8sgpt.ai/
helm repo update
helm install release k8sgpt/k8sgpt-operator -n k8sgpt-operator-system --create-namespace
```
Create OpenAI's secret  
```bash
kubectl create secret generic k8sgpt-sample-secret --from-literal=openai-api-key=$OPENAI_TOKEN -n k8sgpt-operator-system
```

Last but not least, deploy your K8sGPT Custom Resource
```yaml
kubectl apply -f - << EOF
apiVersion: core.k8sgpt.ai/v1alpha1
kind: K8sGPT
metadata:
  name: k8sgpt-sample
  namespace: k8sgpt-operator-system
spec:
  ai:
    enabled: true
    model: gpt-3.5-turbo
    backend: openai
    secret:
      name: k8sgpt-sample-secret
      key: openai-api-key
  noCache: false
  version: v0.3.8
  sink:
    type: slack
    webhook: <your webhook url>
EOF
```
