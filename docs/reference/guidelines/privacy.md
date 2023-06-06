# Privacy

K8sGPT is a privacy-first tool and believe transparency is key for you to understand how we use your data. We have created this page to help you understand how we collect, use, share and protect your data.

## Data we collect

K8sGPT will collect data from Analyzers and either display it directly to you or 
with the `--explain` flag it will send it to the selected AI backend.

The type of data collected depends on the Analyzer you are using. For example, the `k8sgpt analyze pod` command will collect the following data:
- Container status message
- Pod name
- Pod namespace
- Event message

## Data we share

As mentioned, K8sGPT will share data with the selected AI backend **only** when you choose
`--explain` and `auth` against that backend. The data shared will be the same as the data collected.

To learn more about the privacy policy of our default AI backend OpenAI please visit [their privacy policy](https://openai.com/policies/privacy-policy).


## Data we protect

When you are sending data through the `--explain` option, there is the capability of anonymising some of that data. This is done by using the `--anonymize` flag. In the example of the Deployment Analyzer, this will obfusicate the following data:

- Deployment name
- Deployment namespace

## Data we don't collect

- Logs
- API Server data other than the primitives used within our Analyzers.

### Contact

If you have any questions about our privacy policy, please [contact us](https://k8sgpt.ai/contact/).
