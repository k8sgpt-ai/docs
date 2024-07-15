# K8sGPT AI Backends

A Backend (also called Provider) is a service that provides access to the AI language model. There are many different backends available for K8sGPT. Each backend has its own strengths and weaknesses, so it is important to choose the one that is right for your needs.

Currently, we have a total of 11 backends available:

- [OpenAI](https://openai.com/)
- [Cohere](https://cohere.com/)
- [Amazon Bedrock](https://aws.amazon.com/bedrock/)
- [Amazon SageMaker](https://aws.amazon.com/sagemaker/)
- [Azure OpenAI](https://azure.microsoft.com/en-us/products/cognitive-services/openai-service)
- [Google Gemini](https://ai.google.dev/docs/gemini_api_overview)
- [Google Vertex AI](https://cloud.google.com/vertex-ai)
- [Hugging Face](https://huggingface.co)
- [IBM watsonx.ai](https://www.ibm.com/products/watsonx-ai)
- [LocalAI](https://github.com/go-skynet/LocalAI)
- [Ollama](https://github.com/ollama/ollama)
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
  To authenticate with k8sgpt, you would require an Azure OpenAI endpoint of your tenant `https://your Azure OpenAI Endpoint`,the API key to access your deployment, the deployment name of your model and the model name itself.

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
    k8sgpt auth add --backend googlevertexai --model gemini-pro --password "<Your API KEY>"
    ```
- Run the following command to analyze issues within your cluster with the Google provider:
    ```bash
    k8sgpt analyze --explain --backend google
    ```

## Google Gemini via Vertex AI

Google [Gemini](https://blog.google/technology/ai/google-gemini-ai/#performance) allows generative AI capabilities with multimodal approach (it is capable to understand not only text, but also code, audio, image and video). 

- To use [Google Vertex AI](https://cloud.google.com/vertex-ai?#build-with-gemini) you need to be authorized via [Google Cloud SDK](https://cloud.google.com/sdk/install). 
    The [Vertex AI API](https://console.cloud.google.com/apis/library/vertex-ai.googleapis.com) needs to be enabled.

> Note: Vertex AI Gemini API is currently available in these [regions](https://cloud.google.com/vertex-ai/docs/generative-ai/model-reference/gemini?hl=de#http_request), verify if those are working for your environment

- Open a terminal or command prompt and run the following command to authenticate using your Google Cloud credentials:
    ```bash
    gcloud auth application-default login
    ```

- To configure Google backend in K8sGPT with `gemini-pro` model (see all [models](https://ai.google.dev/models) here) use auth command:
    ```bash
    k8sgpt auth add --backend googlevertexai --model "gemini-pro" --providerRegion "us-central1" --providerId "<your project id>"
    ```
- Run the following command to analyze issues within your cluster with the Google provider:
    ```bash
    k8sgpt analyze --explain --backend googlevertexai
    ``` 

## HuggingFace

Hugging Face is a versatile backend for K8sGPT, offering access to a wide range of pre-trained language models. It provides easy-to-use interfaces for both training and inference tasks. Refer to the Hugging Face [documentation](https://huggingface.co/docs) for further insights into model usage and capabilities.

- To use Hugging Face API in K8sGPT, obtain [the API key](https://huggingface.co/settings/tokens).
- Configure the HuggingFace backend in K8sGPT by specifying the desired model (see all [models](https://huggingface.co/models) here) using auth command:
    ```bash
    k8sgpt auth add --backend huggingface --model <model name>
    ```
> NOTE: Since the default gpt-3.5-turbo model is not available in Hugging Face, a valid backend model is required.

- Once configured, you can analyze issues within your cluster using the Hugging Face provider with the following command:
    ```bash
    k8sgpt analyze --explain --backend huggingface
    ```

## IBM watsonx.ai

IBM® watsonx.ai™ AI studio is part of the IBM watsonx™ AI and data platform, bringing together new generative AI (gen AI) capabilities powered by foundation models and traditional machine learning (ML) into a powerful studio spanning the AI lifecycle. Tune and guide models with your enterprise data to meet your needs with easy-to-use tools for building and refining performant prompts. With watsonx.ai, you can build AI applications in a fraction of the time and with a fraction of the data. 

- To use [IBM watsonx.ai](https://dataplatform.cloud.ibm.com/login?context=wx), you'll need a watsonx API key and project ID for authentication.

- You will need to set the follow local environmental variables:
    ```
    - WATSONX_API_KEY
    - WATSONX_PROJECT_ID
    ```
- To configure backend in K8sGPT use auth command:
    ```bash
    k8sgpt auth add --backend watsonxai --model ibm/granite-13b-chat-v2
    ```
- Run the following command to analyze issues within your cluster using IBM watsonx.ai:
    ```bash
    k8sgpt analyze --explain --backend watsonxai
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

Ollama is a local model, which has an OpenAI compatible API. It supports the models listed in the [Ollama library](https://ollama.com/library). 

- To start the API server, follow the instruction in the [Ollama docs](https://github.com/ollama/ollama?tab=readme-ov-file#quickstart).
- Authenticate K8sGPT with LocalAI:
    ```bash
    k8sgpt auth add --backend localai --model <model_name> --baseurl http://localhost:11434/v1
    ```
- Analyze with a LocalAI backend:
    ```bash
    k8sgpt analyze --explain --backend localai
    ```

## Ollama

Ollama can get up and running locally with large language models. It runs Llama 2, Code Llama, and other models.

- To start the Ollama server, follow the instruction in [Ollama](https://github.com/ollama/ollama?tab=readme-ov-file#start-ollama).
    ```bash
    ollama serve
    ```
  It can also run as an docker image, follow the instruction in [Ollama BLog](https://ollama.com/blog/ollama-is-now-available-as-an-official-docker-image)
    ```bash
    docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
    ```

- Authenticate K8sGPT with Ollama:
    ```bash
    k8sgpt auth add --backend ollama --model llama2 --baseurl http://localhost:11434/v1
    ```
- Analyze with a Ollama backend:
    ```bash
    k8sgpt analyze --explain --backend ollama
    ```
## FakeAI

FakeAI or the NoOpAiProvider might be useful in situations where you need to test a new feature or simulate the behaviour of an AI based-system without actually invoking it. It can help you with local development, testing and troubleshooting.
The NoOpAiProvider does not actually perform any AI-based operations but simulates them by echoing the input given as a problem.

Follow the steps outlined below to learn how to utilize the NoOpAiProvider:

- Authorize k8sgpt with `noopai` or `noop` as the Backend Provider:
    ```
    k8sgpt auth add -b noopai
    ```
- For the auth token, you can leave it blank as the NoOpAiProvider is configured to work fine with or without any token.

- Use the analyze and explain command to check for errors in your kubernetes cluster and the NoOpAiProvider should return the error as the solution itself:
    ```
    k8sgpt analyze --explain --backend noopai
    ```

