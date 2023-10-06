# K8sGPT AI Backends

A Backend or a Provider is a service that provides access to the AI language model. There are many different backends available for K8sGPT. Each backend has its own strengths and weaknesses, so it is important to choose the one that is right for your needs.

Currently we have a total of 4 backends available:

- [OpenAI](https://openai.com/)
- [Azure OpenAI](https://azure.microsoft.com/en-us/products/cognitive-services/openai-service)
- [LocalAI](https://github.com/go-skynet/LocalAI)
- FakeAI

## OpenAI

OpenAI is the default backend for K8sGPT. We recommend using OpenAI first if you are new to K8sGPT.
OpenAI comes with the access to powerful language models such as GPT-3.5-Turbo, GPT-4. If you are looking for a powerful and easy-to-use language modeling service, OpenAI is a great option.

- To use OpenAI you'll need an OpenAI token for authentication purposes. To generate a token use:
    ```
    k8sgpt generate
    ```
- To set the token in K8sGPT, use the following command:
    ```
    k8sgpt auth new
    ```
- Run the following command to analyze issues within your cluster using OpenAI:
    ```
    k8sgpt analyze
    ```

## Azure OpenAI

Azure OpenAI Provider provides REST API access to OpenAI's powerful language models. It gives the users an advanced language AI with powerful models with the security and enterprise promise of Azure.

- The Azure OpenAI Provider requires a deployment as a prerequisite. You can visit their [documentation](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/how-to/create-resource?pivots=web-portal#create-a-resource) to create your own.
To authenticate with k8sgpt, you would require an Azure OpenAI endpoint of your tenant `https://your Azure OpenAI Endpoint`,the API key to access your deployment, the Deployment name of your model and the model name itself.

- Run the following command to authenticate with Azure OpenAI:
    ```
    k8sgpt auth --backend azureopenai --baseurl https://<your Azure OpenAI endpoint> --engine <deployment_name> --model <model_name>
    ```
- Now you are ready to analyze with the Azure OpenAI backend:
    ```
    k8sgpt analyze --explain --backend azureopenai
    ```

## LocalAI

LocalAI is a local model, which is an OpenAI compatible API. It uses llama.cpp and ggml to run inference on consumer-grade hardware. Models supported by LocalAI for instance are Vicuna, Alpaca, LLaMA, Cerebras, GPT4ALL, GPT4ALL-J and koala.

- To run To run local inference, you need to download the models first, for instance you can find `ggml` compatible models in [huggingface.com](https://huggingface.co/models?search=ggml)(for example vicuna, alpaca and koala).
- To start the API server, follow the instruction in [LocalAI](https://github.com/go-skynet/LocalAI#example-use-gpt4all-j-model). 
- Authenticate K8sGPT with LocalAI:
    ```
    k8sgpt auth new --backend localai --model <model_name> --baseurl http://localhost:8080/v1
    ```
- Analyze with a LocalAI backend:
    ```
    k8sgpt analyze --explain --backend localai

    ```

## FakeAI

FakeAI or the NoOpAiProvider might be useful in situations where you need to test a new feature or simulate the behaviour of an AI based-system without actually invoking it. It can help you with local development, testing and troubleshooting.
The NoOpAiProvider does not actually perfornm any AI-based operations but simulates them by echoing the input given as a problem.

Follow the steps outlined below to learn how to utilize the NoOpAiProvider:

- Authorize k8sgpt with `noopai` or `noop` as the Backend Provider:
    ```
    k8sgpt auth -b noopai
    ```
- For the auth token, you can leave it blank as the NoOpAiProvider is configured to work fine with or without any token.

- Use the analyze and explain command to check for errors in your kubernetes cluster and the NoOpAiProvider should return the error as the solution itself:
    ```
    k8sgpt analyze --explain
    ```
