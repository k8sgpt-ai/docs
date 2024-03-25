# K8sGPT AI Backends

A Backend (also called Provider) is a service that provides access to the AI language model. There are many different backends available for K8sGPT. Each backend has its own strengths and weaknesses, so it is important to choose the one that is right for your needs.

Currently, we have a total of 8 backends available:

- [OpenAI](https://openai.com/)
- [Cohere](https://cohere.com/)
- [Amazon Bedrock](https://aws.amazon.com/bedrock/)
- [Amazon SageMaker](https://aws.amazon.com/sagemaker/)
- [Azure OpenAI](https://azure.microsoft.com/en-us/products/cognitive-services/openai-service)
- [Google Gemini](https://ai.google.dev/docs/gemini_api_overview)
- [LocalAI](https://github.com/go-skynet/LocalAI)
- FakeAI

## OpenAI

OpenAI is the default backend for K8sGPT. We recommend using OpenAI first if you are new to K8sGPT and if you have an account on [OpenAI](https://openai.com/). OpenAI comes with the access to powerful language models such as GPT-3.5-Turbo, GPT-4. If you are looking for a powerful and easy-to-use language modeling service, OpenAI is a great option.

- To use OpenAI you'll need an OpenAI token for authentication purposes. To generate a token use:
    ```bash
    k8sgpt generate
    ```
- To set the token in K8sGPT, use the following command:
    ```bash
    k8sgpt auth add 
    ```
- Run the following command to analyze issues within your cluster using OpenAI:
    ```bash
    k8sgpt analyze --explain
    ```

## Cohere

Cohere allows building conversational apps. It uses Retrieval Augmented Generation (RAG) toolkit that improves LLM's answer accuracy.

- To use Cohere, visit [Cohere dashboard](https://dashboard.cohere.ai/api-keys).
- To configure backend in K8sGPT, use the following command:
    ```bash
    k8sgpt auth add --backend cohere --model command-nightly
    ```
- Run the following command to analyze issues within your cluster using Cohere:
    ```bash
    k8sgpt analyze --explain --backend cohere
    ```

## Amazon Bedrock

Amazon Bedrock allows building and scaling generative AI applications.

- To use Bedrock, make sure you have access to Bedrock API and models e.g. in AWS Console you should see something like this:

  ![Bedrock](../../imgs/bedrock.png)

- You will need to set the follow local environmental variables:
    ```
    - AWS_ACCESS_KEY
    - AWS_SECRET_ACCESS_KEY
    - AWS_DEFAULT_REGION
    ```

- To configure backend in K8sGPT use auth command:
    ```bash
    k8sgpt auth add --backend amazonbedrock --model anthropic.claude-v2
    ```
- Run the following command to analyze issues within your cluster using Amazon Bedrock:
    ```bash
    k8sgpt analyze --explain --backend amazonbedrock
    ```

## Amazon SageMaker

The Amazon SageMaker backend allows you to leverage a self-deployed and managed Language Models (LLM) on Amazon SageMaker.

Example how to deploy Amazon SageMaker with cdk is available in [llm-sagemaker-jumpstart-cdk](https://github.com/zaremb/llm-sagemaker-jumpstart-cdk) repo.

- To use SageMaker, make sure you have [the AWS CLI configured on your machine](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html).
- You need to have [an Amazon SageMaker instance set up](https://github.com/zaremb/llm-sagemaker-jumpstart-cdk).
- Run the following command to add SageMaker:
    ```bash
    k8sgpt auth add --backend amazonsagemaker --providerRegion eu-west-1 --endpointname endpoint-xxxxxxxxxx
    ```
- Now you are ready to analyze with the Amazon SageMaker backend:
    ```bash
    k8sgpt analyze --explain --backend amazonsagemaker
    ```

## Azure OpenAI

Azure OpenAI Provider provides REST API access to OpenAI's powerful language models. It gives the users an advanced language AI with powerful models with the security and enterprise promise of Azure.

- The Azure OpenAI Provider requires a deployment as a prerequisite. You can visit their [documentation](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/how-to/create-resource?pivots=web-portal#create-a-resource) to create your own.
  To authenticate with k8sgpt, you would require an Azure OpenAI endpoint of your tenant `https://your Azure OpenAI Endpoint`,the API key to access your deployment, the Deployment name of your model and the model name itself.

- Run the following command to authenticate with Azure OpenAI:
    ```bash
    k8sgpt auth add --backend azureopenai --baseurl https://<your Azure OpenAI endpoint> --engine <deployment_name> --model <model_name>
    ```
- Now you are ready to analyze with the Azure OpenAI backend:
    ```bash
    k8sgpt analyze --explain --backend azureopenai
    ```

## Google Gemini

Google [Gemini](https://blog.google/technology/ai/google-gemini-ai/#performance) allows generative AI capabilities with multimodal approach (it is capable to understand not only text, but also code, audio, image and video). With Gemini models, a new [API](https://ai.google.dev/docs/gemini_api_overview) was introduced, and this is what is now built-in K8sGPT. This API also works against the [Google Cloud Vertex AI](https://ai.google.dev/docs/migrate_to_cloud) service. See also [Google AI Studio](https://ai.google.dev/tutorials/ai-studio_quickstart) to get started.

> NOTE: Gemini API might be still rolling to some regions. See the [available regions](https://ai.google.dev/available_regions) for details.

- To use Google Gemini API in K8sGPT, obtain [the API key](https://ai.google.dev/tutorials/setup).
- To configure Google backend in K8sGPT with `gemini-pro` model (see all [models](https://ai.google.dev/models) here) use auth command:
    ```bash
    k8sgpt auth add --backend google --model gemini-pro --password "<Your API KEY>"
    ```
- Run the following command to analyze issues within your cluster with the Google provider:
    ```bash
    k8sgpt analyze --explain --backend google
    ```

## LocalAI

LocalAI is a local model, which is an OpenAI compatible API. It uses llama.cpp and ggml to run inference on consumer-grade hardware. Models supported by LocalAI for instance are Vicuna, Alpaca, LLaMA, Cerebras, GPT4ALL, GPT4ALL-J and koala.

- To run local inference, you need to download the models first, for instance you can find `ggml` compatible models in [huggingface.com](https://huggingface.co/models?search=ggml)(for example vicuna, alpaca and koala).
- To start the API server, follow the instruction in [LocalAI](https://github.com/go-skynet/LocalAI#example-use-gpt4all-j-model).
- Authenticate K8sGPT with LocalAI:
    ```bash
    k8sgpt auth add --backend localai --model <model_name> --baseurl http://localhost:8080/v1
    ```
- Analyze with a LocalAI backend:
    ```bash
    k8sgpt analyze --explain --backend localai
    ```

## Ollama (via LocalAI backend)

Ollama is a local model, which has an OpenAI compatible API. It supports the models listed in the [Ollama libary](https://ollama.com/library). 


- To start the API server, follow the instruction in the [Ollama docs](https://github.com/ollama/ollama?tab=readme-ov-file#quickstart).
- Authenticate K8sGPT with LocalAI:
    ```bash
    k8sgpt auth add --backend localai --model  <model_name> --baseurl http://localhost:11434/v1
    ```
- Analyze with a LocalAI backend:
    ```bash
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
    k8sgpt analyze --explain --backend noopai
    ```

