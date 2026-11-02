# AI backend support tiers

K8sGPT supports a growing number of AI backends. To make the maintenance and support commitment behind each backend clear, the project uses two support tiers: **Core** and **Community**.

Tier describes who maintains a backend and how changes to it are tested. It is not a statement about model quality or whether a backend is suitable for a particular workload. A Community backend can be a good choice for production when its named maintainer keeps it current and you test it against your own requirements.

!!! note "Choosing a backend"
    If you are unsure where to start, choose a Core backend. If your provider is not listed, try the [`openai`](#using-an-openai-compatible-endpoint) backend with the provider's OpenAI-compatible base URL, or the [`customrest`](#using-the-custom-rest-adapter) adapter, before asking for a new backend.

## Core tier

A Core backend is owned by the K8sGPT maintainers and is part of the project's normal release quality gate. A backend in this tier has:

- an owner on the K8sGPT maintainer team;
- unit tests in `pkg/ai` that run in the normal `go test ./...` CI job; backends that delegate to another tested client share that client's coverage;
- documented defaults for the model and endpoint where the provider requires them;
- maintainers who update the integration when a model or API is retired; and
- release-blocking status: a broken Core backend is treated as a regression, not as an optional provider problem.

Core tier does not mean every model offered by that provider is supported. The tested models and defaults are listed in [Supported Models](https://github.com/k8sgpt-ai/k8sgpt/blob/main/SUPPORTED_MODELS.md); other models may work, but are outside the support commitment.

## Community tier

A Community backend is maintained by a named member of the community rather than by the core maintainer team. Community backends are welcome in the project and can be used in production, but support is best-effort.

A Community backend has:

- a named maintainer or contact, recorded in the table below;
- tests that pass when the backend is merged and are expected to keep passing in CI;
- documented setup and a supported default model in the backend documentation; and
- a maintainer who keeps the provider integration and defaults current.

K8sGPT maintainers will triage issues and review changes, but fixes depend on the named community maintainer.

### Removal policy

Community backends are reviewed at every minor release. A Community backend is removed after **three consecutive minor releases** in which its tests fail and the named maintainer has not provided a fix or an accepted remediation plan:

1. **First failing minor release:** the maintainers open a tracking issue, add the `provider/at-risk` label, and record the failure in the release notes.
2. **Second consecutive failing minor release:** the backend is marked **deprecated** in this page and in the release notes, with migration guidance to `openai` or `customrest` where practical.
3. **Third consecutive failing minor release:** the backend is removed from `pkg/ai`, the CLI backend list, and the documentation.

A green test run resets the counter. A removed backend can return through the normal contribution process with a named maintainer. A Community backend whose maintainer becomes unresponsive is treated as unmaintained and follows the same three-release path.

## Adding or promoting a backend

Before proposing a new backend, check whether the provider can be reached through an existing generic backend:

- If the provider exposes an OpenAI-compatible Chat Completions API, use [`openai`](#using-an-openai-compatible-endpoint) with `--baseurl`. No new client is needed.
- If the provider exposes a different REST API, use the [`customrest`](#using-the-custom-rest-adapter) adapter and implement the small request/response contract described below. No new client is needed.

A new provider client should only be proposed when neither generic path can work. The proposal should include a named maintainer, tests, documentation, and a supported default model. New backends enter the Community tier.

A Community backend can be promoted to Core after at least two consecutive minor releases with green CI and a K8sGPT maintainer willing to own it. A Core backend can be moved to Community if its original maintainer steps away, provided a new named maintainer adopts it; otherwise the removal policy above applies. Tier changes are recorded in the release notes.

## Using an OpenAI-compatible endpoint

Most private and enterprise LLM gateways expose an OpenAI-compatible Chat Completions API. Use the `openai` backend and point `--baseurl` at the gateway. This works for private endpoints, internal gateways, and providers that do not have a dedicated K8sGPT client.

```bash
export LLM_BASE_URL="https://llm-gateway.example.com/v1"
export LLM_MODEL="my-model"
export LLM_API_KEY="..."

k8sgpt auth add \
  --backend openai \
  --baseurl "$LLM_BASE_URL" \
  --model "$LLM_MODEL" \
  --password "$LLM_API_KEY"

k8sgpt analyze --explain --backend openai
```

`--baseurl` replaces the default OpenAI base URL. K8sGPT appends `/chat/completions` to that value, so include the API version prefix that your gateway expects (usually `/v1`). If your gateway expects a different path or a non-OpenAI request shape, use `customrest` instead.

Use `--custom-headers` on `analyze` for gateways that require extra routing or tenant headers:

```bash
k8sgpt analyze --explain --backend openai \
  --custom-headers "X-API-Key:$LLM_API_KEY" \
  --custom-headers "X-Tenant-ID:platform-team"
```

`--custom-headers` takes `<key>:<value>` pairs and can be repeated. It is an `analyze` flag, not an `auth add` flag.

For a private certificate authority, add the CA to the operating system or container trust store, or set `SSL_CERT_FILE` to the CA bundle path before running K8sGPT. No K8sGPT code change is required.

## Using the custom REST adapter

The `customrest` backend is the escape hatch for services that do not implement the OpenAI Chat Completions API. It posts a JSON request directly to the exact URL supplied with `--baseurl`; it does not append a path.

The adapter expects a `POST` endpoint that accepts:

```json
{
  "model": "my-model",
  "prompt": "Explain why this pod is failing",
  "options": {}
}
```

and returns:

```json
{
  "model": "my-model",
  "created_at": "2024-01-01T00:00:00Z",
  "response": "The pod is failing because ..."
}
```

The `Content-Type` is `application/json`. If a token is configured, K8sGPT sends it as a Bearer token. The response body must be a single JSON object matching the schema above; the client reads the complete body and unmarshals it as one response.

```bash
k8sgpt auth add \
  --backend customrest \
  --baseurl "http://localhost:8090/completion" \
  --model "llama3.1"

k8sgpt analyze --explain --backend customrest
```

See the [Custom REST backend tutorial](../../tutorials/custom-rest-backend.md) for a complete example server and error-handling guidance.

## Current backend tiers

The table below follows the backend order in `pkg/ai/iai.go`. The **Named maintainer** column identifies the community contact for Community backends; Core backends are owned by the K8sGPT maintainers.

| Backend (`--backend`) | Provider or API | Tier | Named maintainer | Notes |
| --- | --- | --- | --- | --- |
| `openai` | OpenAI Chat Completions and OpenAI-compatible APIs | Core | K8sGPT maintainers | Default backend; use `--baseurl` for compatible gateways. |
| `anthropic` | Anthropic Messages API | Core | K8sGPT maintainers | Default model `claude-sonnet-4-6`. |
| `localai` | LocalAI and OpenAI-compatible local servers | Core | K8sGPT maintainers | Reuses the OpenAI client. |
| `ollama` | Ollama local API | Core | K8sGPT maintainers | Default endpoint `http://localhost:11434`, default model `llama3`. |
| `azureopenai` | Azure OpenAI Service | Core | K8sGPT maintainers | Deployment name and API version are configured separately. |
| `cohere` | Cohere API | Community | [@maxbrunet](https://github.com/maxbrunet) | Legacy integration; community-maintained. |
| `amazonbedrock` | Amazon Bedrock | Core | K8sGPT maintainers | Uses AWS credentials and region selection. |
| `amazonbedrockconverse` | Amazon Bedrock Converse API | Core | K8sGPT maintainers | Uses the Bedrock Converse request format. |
| `amazonsagemaker` | Amazon SageMaker endpoints | Community | [@dkuroczk](https://github.com/dkuroczk) | Requires an endpoint name and region. |
| `google` | Google Gemini API | Core | K8sGPT maintainers | Gemini models through Google AI Studio. |
| `noopai` | FakeAI / no-op backend | Core | K8sGPT maintainers | Test and dry-run backend; does not call a model. |
| `huggingface` | Hugging Face Inference API | Community | [@JuHyung-Son](https://github.com/JuHyung-Son) | Community-maintained. |
| `googlevertexai` | Google Vertex AI | Core | K8sGPT maintainers | Uses a Google Cloud project and region. |
| `oci` | OCI Generative AI | Community | [@anders-swanson](https://github.com/anders-swanson) | Community-maintained. |
| `customrest` | Any REST completion endpoint | Core | K8sGPT maintainers | Exact URL, custom request/response contract. |
| `ibmwatsonxai` | IBM watsonx.ai | Community | [@jinsongo](https://github.com/jinsongo) | Community-maintained. |
| `groq` | Groq Chat Completions | Community | [@majiayu000](https://github.com/majiayu000) | OpenAI-compatible; `openai` with `--baseurl` is the simpler route. |
| `bedrockmantle` | Amazon Bedrock Mantle | Community | [@sankeyraut](https://github.com/sankeyraut) | OpenAI-compatible endpoint; has dedicated tests. |
| `litellm` | LiteLLM proxy | Community | [@prodmanpd](https://github.com/prodmanpd) | Use `openai` with `--baseurl` for simple LiteLLM deployments. |
| `gpt2giga` | GPT2Giga proxy | Community | [@doppoluv](https://github.com/doppoluv) | Community-maintained proxy integration. |

## Related pages

- [AI backends](backend.md) — setup instructions for the supported backends.
- [Custom REST backend tutorial](../../tutorials/custom-rest-backend.md) — build a compatible endpoint.
- [Supported models](https://github.com/k8sgpt-ai/k8sgpt/blob/main/SUPPORTED_MODELS.md) — default and tested models.
- [Contributing guide](https://github.com/k8sgpt-ai/k8sgpt/blob/main/CONTRIBUTING.md) — contribution and review process.
